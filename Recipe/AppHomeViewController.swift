//
//  AppHomeViewController.swift
//  Recipe
//
//  Created by atif on 6/7/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit

class AppHomeViewController: BaseViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewDelegate:CollectionViewDelegate?
    var transitionImage:UIImage?
    var transitionView:UIView?

    var navDelegate = NavigationControllerDelegate()

    
//    override func viewDidChangeSizeBeforeLayoutSubView(oldSize: CGSize, newSize: CGSize) {
//        super.viewDidChangeSizeBeforeLayoutSubView(oldSize, newSize: newSize)
//        
//    }
    
    override func viewDidChangeSizeAfterLayoutSubView() {
        super.viewDidChangeSizeAfterLayoutSubView()
        if (!(self.isMovingToParentViewController() || self.isBeingPresented())){
            
            let firstVisibleCellIndexPath = collectionView.indexPathsForVisibleItems().first
//            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
            if firstVisibleCellIndexPath != nil {
                collectionView.scrollToItemAtIndexPath(firstVisibleCellIndexPath! , atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        navDelegate.setHelperValues { () -> () in
            weakSelf?.navDelegate.senderView = weakSelf?.transitionView
        }
        navigationController?.delegate = navDelegate
        collectionViewDelegate = CollectionViewDelegate(collectionView: collectionView, interactionDelegate: nil)
        collectionView.dataSource = collectionViewDelegate
        collectionView.delegate = collectionViewDelegate

        collectionViewDelegate?.setCollectionData(Item.simulatedRecipeHomeScreenItems())
        
        collectionViewDelegate?.selection = { (sectionItem:Item, rowItem:Item, indexPath:NSIndexPath, collectionView:UICollectionView) -> Void in
        
            weakSelf?.transitionImage = rowItem.getCachedImage()
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            weakSelf?.transitionView = cell
            let vc = weakSelf?.storyboard?.instantiateViewControllerWithIdentifier("ReceipePageViewController")
            
            if vc != nil {
                weakSelf?.showViewController(vc!, sender: nil)
            }
        }
       
    }
    
    
//    MARK: - Transition delegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        return nil

    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         return nil
    }


    
}
