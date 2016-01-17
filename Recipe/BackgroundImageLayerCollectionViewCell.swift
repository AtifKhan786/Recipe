//
//  BackgroundImageLayerCollectionViewCell.swift
//  Recipe
//
//  Created by atif on 6/17/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class BackgroundImageLayerCollectionViewCell: UICollectionViewCell {
    var imgLayer_:CALayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBackgroundImageLayer()
    }
    
    func setImageLayerFrame(){
        let imgFrame = contentView.bounds
        imgLayer_?.frame = imgFrame
    }
    
    func setItem(item:Item){
        let img = item.getImageForSize(contentView.bounds.size, shouldUseInMemoryCache: true)
        setBackgroundLayerImage(img)
        
    }
    
    func setBackgroundLayerImage(img:UIImage?){
        if img != nil {
            imgLayer_?.contents = img!.CGImage
        }else {
            imgLayer_?.contents = nil
        }
        resetAllCustomAnimationFromChildLayers()
        updateBackgroundImageLayer()
        imgLayer_?.transform = CATransform3DIdentity
    }

    func updateBackgroundImageLayer() {
        if (imgLayer_ == nil) {
            imgLayer_ = CALayer()
            imgLayer_?.drawsAsynchronously  = true
            imgLayer_?.contentsGravity      = "resizeAspectFill"
            imgLayer_?.anchorPoint          = CGPointMake(CGFloat(0.5), CGFloat(0.5))
            contentView.layer.insertSublayer(imgLayer_!, atIndex: 0)
        }
        
        setImageLayerFrame()
    }
    
    class func springAnimationTimingFunction() -> CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.5, 1.8, 1, 1)
    }
    
    func layerAnimation(fromValue:NSValue, toValue:NSValue, property:String,  duration:CGFloat, removeOnCompletion:Bool, timingFunction:CAMediaTimingFunction?) ->CABasicAnimation {
        
        let basicAnimation = CABasicAnimation(keyPath: property)
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        
        basicAnimation.duration = CFTimeInterval(duration)
        basicAnimation.removedOnCompletion = removeOnCompletion
        
        basicAnimation.timingFunction = timingFunction
        
        return basicAnimation
    }
    
    func resetAllCustomAnimationFromChildLayers(){
        imgLayer_?.removeAnimationForKey("transformAnimation")
    }
    
    func animateImgLayerWithTransform(transform: CATransform3D, duration: CGFloat, removeOnCompletion:Bool, timingFunction:CAMediaTimingFunction?){
        let fromTransform = (imgLayer_!.presentationLayer() as! CALayer).transform
        let transformAnimation = layerAnimation(NSValue(CATransform3D:fromTransform), toValue: NSValue(CATransform3D:transform), property: "transform", duration: duration, removeOnCompletion: removeOnCompletion, timingFunction: timingFunction)
        imgLayer_?.addAnimation(transformAnimation, forKey: "transformAnimation")
    }
    
    func resetTouchAnimation(){
        var transform = CATransform3DIdentity
        transform.m34 = 1/(-500.0)
        imgLayer_?.transform = transform
        animateImgLayerWithTransform(transform, duration: 0.4, removeOnCompletion: false, timingFunction: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event!)
        var transform = CATransform3DIdentity
        transform.m34 = 1/(-500.0)
        transform = CATransform3DTranslate(transform, 0, 0, -20)
        transform = CATransform3DScale(transform, 1.2, 1.2, 1)
        imgLayer_?.transform = transform
        
        animateImgLayerWithTransform(transform, duration: CGFloat(0.4), removeOnCompletion: false, timingFunction: FeaturedReceipeCollectionViewCell.springAnimationTimingFunction())
    }
    
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        resetTouchAnimation()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        resetTouchAnimation()
    }
}
