//
//  PagerViewController.swift
//  Recipe
//
//  Created by atif on 6/2/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit
//V:[topGuide]

@objc class PagerViewChildController : UIViewController {
    var pagerPositionIndex  : Int?
    weak var  pagerViewController : PagerViewController?
    
    func becomeActiveInPager(){}
    func willTransitionByInteraction(from:PagerViewChildController, toViewController:PagerViewChildController){}
    func didCompleteTransitionByInteraction(from:PagerViewChildController, toViewController:PagerViewChildController) {}
}

@objc protocol PagerViewControllerDataSource : NSObjectProtocol {
    
    func numberOfViewControllers() -> Int
    
    optional func pagerScrollViewHeight() -> Int
    
    func childViewController(index:Int, pageController:PagerViewController) -> PagerViewChildController
    
}

class PagerViewController: UIViewController {

    internal var viewcontrollers_:[PagerViewChildController]?
    internal let kPagerScrollViewHeight:Int = 60

    var activeViewController:PagerViewChildController?
    
    var viewControllersScroller:UIScrollView?
    var pageScrollView:UIScrollView?
    var pagerScrollViewHeight:Int = 60
    
    weak var pagerDelegate:PagerViewControllerDataSource?
    
    // MARK: - Private
    
    internal func transitionColor(fromColor:UIColor!, toColor:UIColor!, progress:Float) -> UIColor {

        var from_red:CGFloat = 0
        var from_blue:CGFloat = 0
        var from_green:CGFloat = 0
//        var from_alpha:CGFloat = 0
        
        var to_red:CGFloat      = 0
        var to_blue:CGFloat     = 0
        var to_green:CGFloat    = 0
        
        let prog = (progress < 0 ? 0: progress > 1 ? 1:progress)
        
        fromColor.getRed(&from_red, green: &from_green, blue: &from_blue, alpha: nil )
        toColor.getRed(&to_red, green: &to_green, blue: &to_blue, alpha: nil )

        let newRed = CGFloat((1-prog)) * from_red + CGFloat(prog) * to_red
        let newGreen = CGFloat((1-prog)) * from_green + CGFloat(prog) * to_green
        let newBlue = CGFloat((1-prog)) * from_blue + CGFloat(prog) * to_blue

        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha:1)
    }
    
    internal func constraintForView(view:UIView!, superView:UIView!) ->[NSLayoutConstraint] {
        var filteredConstraints = [NSLayoutConstraint]()
        let oldConstraints = superView.constraints as [NSLayoutConstraint]
        
        for constraint in oldConstraints {
            if constraint.firstItem as? UIView == view || constraint.secondItem as? UIView == view {
                filteredConstraints.append(constraint)
            }
        }
        return filteredConstraints
    }
    
    internal func updateScrollViewConstraints(){
        if viewControllersScroller != nil {
            
            let binding:[String:AnyObject] = ["scrollView":viewControllersScroller!,"pageScroller":pageScrollView!]

            let oldConstraints = self.constraintForView(viewControllersScroller!, superView: viewControllersScroller!.superview)
            viewControllersScroller!.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageScroller]-0-[scrollView]-0-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: binding))
            viewControllersScroller!.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: binding))
            
            viewControllersScroller!.superview?.removeConstraints(oldConstraints)
        }
    }
    
    internal func updatePageScrollViewConstraints() {
        if pageScrollView != nil {
            let topGuide = self.topLayoutGuide
            let binding:[String:AnyObject] = ["topGuide":topGuide, "scrollView":pageScrollView!]
            let metrics:[String:AnyObject] = ["height":kPagerScrollViewHeight]

            let oldConstraints = self.constraintForView(pageScrollView!, superView: pageScrollView!.superview)
            pageScrollView!.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topGuide]-0-[scrollView(height)]", options: NSLayoutFormatOptions(), metrics: metrics, views: binding))
            pageScrollView!.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: binding))
            pageScrollView!.superview?.removeConstraints(oldConstraints)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateScrollViewConstraints()
    }
    
    internal func createAndSetUpScrollView() {
        
        createPageScrollView()
        
        if viewControllersScroller == nil {
            viewControllersScroller = UIScrollView()
            viewControllersScroller?.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(viewControllersScroller!)
            viewControllersScroller?.backgroundColor = UIColor.lightGrayColor()
            updateScrollViewConstraints()
        }
        self.view.layoutSubviews()
    }
    
    internal func createPageScrollView() {
        if pageScrollView == nil {
        
            pageScrollView = UIScrollView()
            pageScrollView?.backgroundColor = UIColor.redColor()
            pageScrollView?.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(pageScrollView!)
            updatePageScrollViewConstraints()
        }
    }
    
    // MARK: - Public
    
    func loadViewControllers() {
        if pagerDelegate == nil {return}
        
        viewcontrollers_ = []
        createAndSetUpScrollView()

        let numberOfViewControllers = pagerDelegate!.numberOfViewControllers()
        
        if pagerDelegate!.pagerScrollViewHeight == nil {
            pagerScrollViewHeight = kPagerScrollViewHeight
        }else {
            pagerScrollViewHeight = pagerDelegate!.pagerScrollViewHeight!()
        }
        
//        if delegate!.respondsToSelector("pagerScrollViewHeight") {
//            pagerScrollViewHeight = delegate!.pagerScrollViewHeight!()
//        }else {
//            pagerScrollViewHeight = kPagerScrollViewHeight
//        }
        if numberOfViewControllers > 0 {
            for index in 0...numberOfViewControllers-1 {
                let childVCs = pagerDelegate!.childViewController(index, pageController: self)
                
                childVCs.pagerPositionIndex = index
                childVCs.pagerViewController = self
                
                viewcontrollers_?.append(childVCs)
            }
        }
        
    }
}
