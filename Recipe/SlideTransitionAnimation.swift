//
//  SlideTransitionAnimation.swift
//  Recipe
//
//  Created by atif on 7/4/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class SlideTransitionAnimation: IntractiveTransitionAnimationAbstract {
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
       // let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let toView = toViewController?.view
       // let fromView = fromViewController?.view
        
        let containerView = transitionContext.containerView()
        
        let animationDuration = self.transitionDuration(transitionContext)
        
        if isPresenting {
            var rect = containerView!.bounds
            rect.origin.y = rect.size.height
            toView?.frame = rect
            
            containerView?.addSubview(toView!)
        }
        
        
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            var rect = containerView!.bounds

            if self.isPresenting {
                toView?.frame = rect
            }else {
                rect.origin.y = rect.size.height
                toView?.frame = rect
            }
            }) { (completed:Bool) -> Void in
                transitionContext .completeTransition(true)
        }
        
    }}
