//
//  IntractiveTransitionAnimationAbstract.swift
//  Recipe
//
//  Created by atif on 6/26/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class IntractiveTransitionAnimationAbstract: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    var transitionAnimationDuration = 1.0
    var isPresenting = true
    
    class func interactiveTransitionTransitionGestureHandler(gesture:UIGestureRecognizer, interactiveAnimationDelegate:IntractiveTransitionAnimationAbstract, beginTransition:(() -> ())) {
        
    }
    
    //    MARK: - Trasition Delegate
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionAnimationDuration
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        
    }

}
