//
//  PageCurlInteractiveTransition.swift
//  Recipe
//
//  Created by atif on 6/26/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class PageCurlInteractiveTransition: IntractiveTransitionAnimationAbstract {

    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let toView = toViewController?.view
        let fromView = fromViewController?.view
        
        let containerView = transitionContext.containerView()
        
        let animationDuration = self.transitionDuration(transitionContext)
        let snapShot = isPresenting ? fromView?.snapshotViewAfterScreenUpdates(false) : toView?.snapshotViewAfterScreenUpdates(false)
        if isPresenting {
            containerView?.addSubview(snapShot!)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                UIView.transitionWithView(containerView!, duration: animationDuration, options: UIViewAnimationOptions.TransitionCurlDown, animations: { () -> Void in
                    snapShot?.removeFromSuperview()
                    containerView?.addSubview(toView!)
                    }, completion: { (success:Bool) -> Void in
                        transitionContext.completeTransition(true)
                        
                })
            })
        } else {
            UIView.transitionWithView(containerView!, duration: animationDuration, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                    fromView?.removeFromSuperview()
                    containerView?.addSubview(snapShot!)
                }, completion: { (success:Bool) -> Void in
                    transitionContext.completeTransition(true)
                    snapShot?.removeFromSuperview()
            })
        }
        
    }
}
