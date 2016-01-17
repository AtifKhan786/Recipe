//
//  ImageTransitionAnimation.swift
//  Recipe
//
//  Created by atif on 7/4/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class ImageTransitionAnimation: IntractiveTransitionAnimationAbstract {
    
    let refImg_:UIImage?
    let refView_:UIView?
    let refImgView_ = UIImageView()
    
    init(image:UIImage?, referenceView:UIView?) {
        refImg_ = image
        refView_ = referenceView
    }
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        // let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let toView = toViewController?.view
        // let fromView = fromViewController?.view
        
        let containerView = transitionContext.containerView()
        
        let animationDuration = self.transitionDuration(transitionContext)
        var refImgSize:CGSize? = nil
        if refImg_ != nil {
         refImgSize = refImg_!.size
            let refImgAspectRatio = refImgSize!.width/refImgSize!.height
            let imgWidth = containerView!.bounds.size.width
            let imgHeight = imgWidth/refImgAspectRatio
            refImgView_.frame = CGRectMake(0, 0, imgWidth, imgHeight)

        }
       
        
        
        refImgView_.contentMode = UIViewContentMode.ScaleAspectFill
        refImgView_.image = refImg_
        containerView?.addSubview(refImgView_)
        
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.refImgView_.frame = containerView!.bounds

            }) { (success:Bool) -> Void in
                if self.isPresenting {
                    toView?.frame = containerView!.bounds
                    containerView?.addSubview(toView!)
                }
                transitionContext.completeTransition(true)
        }
    
    }
}
