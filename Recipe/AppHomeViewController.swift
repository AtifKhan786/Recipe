//
//  AppHomeViewController.swift
//  Recipe
//
//  Created by atif on 6/7/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit

class AppHomeViewController: UIViewController {

    let collectionNode:ASCollectionNode
    let collectionDelegate:CollectionViewDelegate
    let collectionLayout:UICollectionViewFlowLayout
    
    static func layout() -> UICollectionViewFlowLayout {
        let margin = CGFloat(2 )
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = margin
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsetsMake(margin, 0, margin, 0)
        return layout
    }
    
    required init?(coder aDecoder: NSCoder) {
        let layout = AppHomeViewController.layout()
        collectionLayout = layout
        collectionNode = ASCollectionNode(collectionViewLayout: layout)

        collectionDelegate = CollectionViewDelegate(collectionViewNode: collectionNode)
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100)

        collectionNode.backgroundColor = UIColor.blackColor();
        self.view.backgroundColor = UIColor.blackColor()
        collectionNode.view.registerSupplementaryNodeOfKind(UICollectionElementKindSectionHeader)
        collectionNode.view.frame = self.view.bounds
        self.view.addSubview(collectionNode.view)
        
        collectionDelegate.data = Item.simulatedRecipeHomeScreenItems()
//        collectionNode.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionNode.view.frame = self.view.bounds
        collectionLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 60)

    }
    
}
