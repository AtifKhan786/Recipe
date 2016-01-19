//
//  CollectionViewDelegate.swift
//  Recipe
//
//  Created by atif on 6/7/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit
//ASCollectionViewDelegateFlowLayout
class CollectionViewDelegate: NSObject, ASCollectionDataSource, ASCollectionDelegate {
   
    var data:Array<Item>?
    let collectionNode:ASCollectionNode
    
    init(collectionViewNode:ASCollectionNode) {
        collectionNode = collectionViewNode
        super.init()
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    var selection:((sectionItem:Item, rowItem:Item, indexPath:NSIndexPath, collectionView:UICollectionView) -> Void)?
    
    
    // Datasource
    
//    - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView == collectionNode.view {
            if data == nil { return 0 }
            return data!.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionNode.view {
            if data == nil { return 0}
            let item = data![section]
            if item.itemType == ItemType.CollectionFeaturedReceipe || item.itemType == ItemType.CollectionFeaturedChannels || item.itemType == ItemType.RecipeCategories{
                return item.subItems.count
            }
        }
        
        return 0
    }
    
    func collectionView(collectionView: ASCollectionView, nodeForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let item = data![indexPath.section]
        let title = item.name == nil ? "":item.name!
        let header = SectionHeaderNode(text: title, width: collectionView.bounds.size.width)
        return header
    }
    
    
    func collectionView(collectionView: ASCollectionView, nodeForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
       
        let item = data![indexPath.section]
        let subItem = item.subItems[indexPath.row]
        if item.itemType == ItemType.CollectionFeaturedChannels {
        
            let channelCell = FeaturedChannelCellNode(item: subItem, width: collectionView.bounds.size.width)
            return channelCell
        } else if item.itemType == ItemType.RecipeCategories {
            
            let categoryCell = FeaturedCategoryCellNode(item: subItem, width: collectionView.bounds.size.width)
            return categoryCell
        }
        
        let featuredCell = FeaturedReceipieCellNode(item: subItem, size: CGSizeMake(collectionView.bounds.size.width, 200))
        return featuredCell
    }
   
    func collectionViewLockDataSource(collectionView: ASCollectionView) {
        
    }
    
    func collectionViewUnlockDataSource(collectionView: ASCollectionView) {
        
    }
    
    

}
