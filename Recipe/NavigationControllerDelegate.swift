//
//  NavigationControllerDelegate.swift
//  Recipe
//
//  Created by atif on 7/10/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    
    var senderView:UIView?
    var workClouser:( () -> ())?
    
    func setHelperValues(work:( () -> ())) {
    
        workClouser = work
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        senderView = nil
        workClouser?()
        
        if senderView != nil {
            let animation = GateOpenTransition()
            animation.senderView = senderView
            animation.presentation = (operation == UINavigationControllerOperation.Push)
            return animation
        }
        
        return nil 
    }

}
