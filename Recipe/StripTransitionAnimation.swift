//
//  StripTransitionAnimation.swift
//  Recipe
//
//  Created by atif on 6/26/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit


class StripTransitionAnimation: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

    var transitionAnimationDuration = 5.0
    var isPresenting = true
//    var stripImages:Array<UIImage>?
    var stripImageLayers:Array<CALayer>?
    
    class func stripTransitionInteractiveTransitionGestureHandler(gesture:UIGestureRecognizer, interactiveAnimationDelegate:StripTransitionAnimation, beginTransition:(() -> ())) {
    
    }
    
    class func viewToImage(view:UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    class func cropImage(cropRect:CGRect, imageRef:CGImageRef, scale:CGFloat, orientation:UIImageOrientation) -> UIImage {
        let imgRef = CGImageCreateWithImageInRect(imageRef, cropRect)
        let outImage = UIImage(CGImage: imgRef!, scale: scale, orientation: orientation)
        return outImage
    }
    
    class func cropImage(cropRect:CGRect, image:UIImage!) -> UIImage {
        let scale = image.scale
        let imgRef = CGImageCreateWithImageInRect(image.CGImage!, cropRect)
        let outImage = UIImage(CGImage: imgRef!, scale: scale, orientation: image.imageOrientation)
        
        return outImage
    }
    
    func setStripArrayForImage(image:UIImage, inLayer:CALayer){
//        var stripImages = Array<UIImage>()
        stripImageLayers = []
        
        let imgSize = image.size
        let width = imgSize.width
        var stripWidth = CGFloat(20)
        let numberOfStrips = Int(width/stripWidth)
        
        stripWidth = width/CGFloat(numberOfStrips)
        
        let imgRef = image.CGImage!
        let scale = image.scale
//        let orientation = image.imageOrientation
        
        for (var index = 0; index < numberOfStrips; index++) {
            let cropRect = CGRectMake(CGFloat(index) * stripWidth * scale, 0, stripWidth * scale, imgSize.height * scale)
            let cropedImgRef = CGImageCreateWithImageInRect(imgRef, cropRect)
            let layer = CALayer()
            layer.contents = cropedImgRef
            layer.drawsAsynchronously = true
            layer.frame = CGRectMake(CGFloat(index) * stripWidth, 0, stripWidth, imgSize.height)
            stripImageLayers?.append(layer)
            inLayer.addSublayer(layer)
        }
    }
    
    func setStripFrameForLayers(initial:Bool) {
        
        let count = stripImageLayers!.count
        
        for (var index = 0; index < count; index++){
            let layer = stripImageLayers![index]
            let even = index % 2 == 0
            if isPresenting {
                
            } else {
                if initial {
                
                }else {
                    var frame = layer.frame
                    frame.origin.y = even ? frame.size.height : -frame.size.height
                    layer.frame = frame
                }
            }
        }
    }
    
    //float scale = originalImage.scale;
//    CGImageRef imageRef = CGImageCreateWithImageInRect(originalImage.CGImage, cropRect);
//    UIImage* outImage = [UIImage imageWithCGImage:imageRef scale:originalImage.scale orientation:originalImage.imageOrientation]];
//    CGImageRelease(imageRef);
    
//    MARK: - Trasition Delegate
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionAnimationDuration
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let toView = toViewController?.view
        let fromView = fromViewController?.view
        
        let containerView = transitionContext.containerView()
        
        let animationDuration = self.transitionDuration(transitionContext)
        
        if isPresenting {
            
            toView?.frame = containerView!.bounds
            containerView?.addSubview(toView!)
            toView?.hidden = true
        }
        
        let image = StripTransitionAnimation.viewToImage(isPresenting ? toView!: fromView!)
        setStripArrayForImage(image, inLayer: containerView!.layer)
        
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                toView?.alpha = 0
                self.setStripFrameForLayers(false)
            }, completion: { (completed:Bool) -> Void in
                transitionContext.completeTransition(true)

        })
        
        
      
    }
    
    // This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
    func animationEnded(transitionCompleted: Bool){}
}
