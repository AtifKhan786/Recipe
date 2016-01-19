//
//  BaseViewController.swift
//  Recipe
//
//  Created by atif on 6/7/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var viewSize_:CGSize?
    var oldSize:CGSize?
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    func viewDidChangeSizeBeforeLayoutSubView( oldSize:CGSize, newSize:CGSize){
    
    }
    
    func viewDidChangeSizeAfterLayoutSubView(){
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewSize_ != nil && oldSize != nil {
            if viewSize_!.width != oldSize!.width {
                weak var weakSelf = self
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    weakSelf?.viewDidChangeSizeAfterLayoutSubView()
                })
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if viewSize_?.width != self.view.bounds.size.width && viewSize_?.width > 0 {
            viewDidChangeSizeBeforeLayoutSubView(viewSize_!, newSize: self.view.bounds.size)
        }
        oldSize = viewSize_
        viewSize_ = view.bounds.size

    }
    
    

}
