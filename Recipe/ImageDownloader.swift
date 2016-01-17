//
//  ImageDownloader.swift
//  Recipe
//
//  Created by atif on 6/8/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//
//http://ste.vn/2015/06/10/configuring-app-transport-security-ios-9-osx-10-11/

import UIKit

class ImageDownloader: NSObject {
   
    private let imgURL:NSURL?
    private var originalImageDownloaded:UIImage?
    private var resizeImageInfo:[String:UIImage] = [String:UIImage]()
    private var imageDownloadTask:NSURLSessionDataTask?
    
    static let kImageDownloadNotification = "imageDownloadedNotification"
    
    init(imageURL:NSURL?) {
        imgURL = imageURL
        super.init()
    }
    
    deinit{
        imageDownloadTask?.cancel()
    }
   
    
    func resizeImage(image:UIImage, size:CGSize, isRetina:Bool) -> UIImage {
        
        var newImage:UIImage?
        autoreleasepool { () -> () in
            
            let rect = CGRectIntegral(CGRectMake(0, 0, size.width, size.height))
            let imgRef = image.CGImage
            
            UIGraphicsBeginImageContextWithOptions(size, false, isRetina ? 0:1)
            let context = UIGraphicsGetCurrentContext()
            CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
            let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, size.height)

            CGContextConcatCTM(context, flipVertical);
            CGContextDrawImage(context, rect, imgRef)
            
            let newImageRef = CGBitmapContextCreateImage(context)
            newImage = UIImage(CGImage: newImageRef!)
            
            UIGraphicsEndImageContext()
        }
        
        return newImage!
    }
    
    func resizeOriginalDownloadedImage(size:CGSize) -> UIImage?{
        
        if originalImageDownloaded != nil {
            let imgSize = originalImageDownloaded!.size
            let aspectRatio = imgSize.width/imgSize.height
            var newWidth = size.width
            var newHeight = newWidth/aspectRatio
            
            if newHeight > size.height {
                newHeight = size.height
                newWidth = newHeight * aspectRatio
            }
            
            let newSize = CGSizeMake(newWidth, newHeight)
            return resizeImage(originalImageDownloaded!, size: newSize, isRetina: true)
        }
        
        return nil
    }
    
    func downloadImage(){
        if originalImageDownloaded == nil && imgURL != nil {
            if imageDownloadTask == nil || imageDownloadTask?.state != NSURLSessionTaskState.Running {
                
                weak var weakSelf = self
                
                let request = NSURLRequest(URL: imgURL!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
                
                imageDownloadTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (downloadedData:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    if error == nil {
                        if downloadedData != nil {
                            let image = UIImage(data: downloadedData!)
                            if (image != nil ){
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    weakSelf!.originalImageDownloaded = image
                                    NSNotificationCenter.defaultCenter().postNotificationName(ImageDownloader.kImageDownloadNotification, object: weakSelf)
                                })
                            }
                            
                        }
                    }else {
                        debugPrint("Error :\(error!)")
                    }
                })
                
                imageDownloadTask?.resume()
            }
            
        }
    }
    
//    MARK: Public
    
    func getImageForSize(size:CGSize, shouldUseInMemoryCache:Bool, keepOnlyThisSizeInMemory:Bool) ->UIImage? {
        let sizeKey = "\(size.width)x\(size.height)"
        
        if (keepOnlyThisSizeInMemory) {
            let allKeys = resizeImageInfo.keys
            for key in allKeys {
                if sizeKey != key {
                    resizeImageInfo.removeValueForKey(key)
                }
            }
        }
        
        if shouldUseInMemoryCache {
            let cachedImage = resizeImageInfo[sizeKey]
            if cachedImage != nil { return cachedImage }
        }
        
        
        // If have image process it
        if originalImageDownloaded != nil {
            let resizedImage = resizeOriginalDownloadedImage(size)
            resizeImageInfo[sizeKey] = resizedImage
            
            //Clear downloaded size, from now on image will read from in memory cache. If attempt to get image of other size than it will re-download image
            originalImageDownloaded = nil
            return resizedImage
        }
        
        // Download image, if not already downloading
        downloadImage()
        return nil
    }
    
    func getImageForSize(size:CGSize, shouldUseInMemoryCache:Bool) ->UIImage? {
        
        let sizeKey = "\(size.width)x\(size.height)"
        
        if shouldUseInMemoryCache {
            let cachedImage = resizeImageInfo[sizeKey]
            if cachedImage != nil { return cachedImage }
        }
        
        // If have image process it
        if originalImageDownloaded != nil {
            let resizedImage = resizeOriginalDownloadedImage(size)
            resizeImageInfo[sizeKey] = resizedImage
        
            //Clear downloaded size, from now on image will read from in memory cache. If attempt to get image of other size than it will re-download image
            originalImageDownloaded = nil
            return resizedImage
        }
        
        // Download image, if not already downloading
        downloadImage()
        return nil
    }
    
    func getCachedImage() -> UIImage?{
        if originalImageDownloaded != nil {
            return originalImageDownloaded
        }
        
        for tempImage in resizeImageInfo {
            return tempImage.1
        }
        return nil
    }
}
