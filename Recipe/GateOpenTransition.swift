//
//  GateOpenTransition.swift
//  Recipe
//
//  Created by atif on 7/10/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class GateOpenTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var animationDuration:NSTimeInterval = 1.0
    var presentation = true
    var senderView:UIView?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
        let containerView = transitionContext.containerView()
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let toView = toVC!.view
        let fromView = fromVC!.view
        
        fromView.frame = containerView!.bounds
        toView.frame = containerView!.bounds

        if presentation || toView.superview != containerView{
            containerView?.addSubview(toView)
        }

        let senderRectInFromView = containerView!.convertRect(senderView!.bounds, fromView: senderView!)
        
        var topPart:UIImage? = nil;
        var bottomPart:UIImage? = nil
        
        let snapShotView = presentation ? fromView:toView
        let snapShot = UIView.convertToImage(snapShotView, afterScreenUpdate: false)
        let scale = snapShot.scale
        let snapShotCG = snapShot.CGImage!
        
        let topSnapshotHeight = senderRectInFromView.origin.y
        let bottomSnapshotHeight = containerView!.bounds.size.height - senderRectInFromView.size.height - senderRectInFromView.origin.y
        
        let topRect = CGRectMake(0, 0, toView.bounds.size.width, topSnapshotHeight)
        let bottomRect = CGRectMake(0, senderRectInFromView.origin.y + senderRectInFromView.size.height, toView.bounds.size.width, bottomSnapshotHeight)
        
        if topSnapshotHeight > 0 {
            let scaledTopRect = CGRectMake(topRect.origin.x * scale, topRect.origin.y * scale, topRect.size.width * scale, topRect.size.height * scale)
            let topCGImage = CGImageCreateWithImageInRect(snapShotCG, scaledTopRect)
            topPart = UIImage(CGImage: topCGImage!)
        }
        
        if bottomSnapshotHeight > 0 {
            let scaledBottomRect = CGRectMake(bottomRect.origin.x * scale, bottomRect.origin.y * scale, bottomRect.size.width * scale, bottomRect.size.height * scale)

            let bottomCGImage = CGImageCreateWithImageInRect(snapShotCG, scaledBottomRect)
            bottomPart = UIImage(CGImage: bottomCGImage!)
        }
        fromView.hidden = true
        toView.hidden = false

        var topImgView:UIImageView? = nil
        var bottomImgView:UIImageView? = nil
        
        if topPart != nil {
         topImgView = UIImageView()
            topImgView?.image = topPart
            topImgView?.frame = topRect
            containerView?.addSubview(topImgView!)
        }
        
        if bottomPart != nil {
            bottomImgView = UIImageView()
            bottomImgView?.image = bottomPart
            bottomImgView?.frame = bottomRect
            containerView?.addSubview(bottomImgView!)
        }
        toView.alpha = 0
        if !presentation {
            topImgView?.frame = CGRectMake(0, -topRect.size.height, topRect.size.width, topRect.size.height)
            bottomImgView?.frame = CGRectMake(0, containerView!.bounds.size.height, bottomRect.size.width, bottomRect.size.height)
        }

        weak var weakSelf = self
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            
            toView.alpha = 1

            if weakSelf!.presentation {
                topImgView?.frame = CGRectMake(0, -topSnapshotHeight, topRect.size.width, topSnapshotHeight)
                bottomImgView?.frame = CGRectMake(0, containerView!.bounds.size.height, bottomRect.size.width, bottomSnapshotHeight)
                
            }else  {
                topImgView?.frame = topRect
                bottomImgView?.frame = bottomRect
            }
            }) { (success:Bool) -> Void in
                
                fromView.hidden = false
                toView.hidden = false

                topImgView?.removeFromSuperview()
                bottomImgView?.removeFromSuperview()

                transitionContext.completeTransition(true)
                
        }
    }
}
