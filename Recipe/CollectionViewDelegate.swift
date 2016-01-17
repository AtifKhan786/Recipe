//
//  CollectionViewDelegate.swift
//  Recipe
//
//  Created by atif on 6/7/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit

class CollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
    var selection:((sectionItem:Item, rowItem:Item, indexPath:NSIndexPath, collectionView:UICollectionView) -> Void)?
    
    //    MARK: Private
    private let collectionView_:UICollectionView!
    private var data:[Item]?
    private let cellID_FeaturedReceipe  = "cellid_featuredrecipe"
    private let cellID_FavouriteChannel = "cellid_favoritechannel"
    private let cellID_FeaturedChannel  = "cellid_featuredchannel"
    private let cellID_ImageGalleryPreviewCell          = "cellid_imagePreviewCell"
    private let cellID_ReceipeStepCell                  = "cellid_receipeStepCell"
    private let cellID_IngrediantCell                   = "cellid_ingrediantCell"
    private let cellID_CollectionViewCell     = "cellid_ingrediantsCollectionViewCell"
    private let cellID_IngrediantSubCollectionViewCell  = "cellid_ingrediantSubCollectionViewCell"
    private let cellID_OtherItemSubCollectionViewCell  = "cellid_otherItemSubCollectionViewCell"

    private let cellID_CategoryCell                     = "cellid_categoryCell"

    private let sectionHeader_PlainText                 = "header_plaintext"

    private var offscreenCell_channel:FeautredChannelsCollectionViewCell!
    private var offscreenCell_receipeStep = StepsWithImageCollectionViewCell()
    private var offscreenCell_ingrediant = IngredientCollectionViewCell()
    private var offscreenCell_category:CategoryCollectionCell?

    private var offscreenHeader_Basic:BasicCollectionReusableView?
    
    private var otherCollectionViewSectionItemMap = Dictionary<UICollectionView, Item>()

    //    MARK: Cell helper methods
    
    private func registerOtherCollectionView(collectionView:UICollectionView) {
    //cellID_IngrediantSubCollectionViewCell
        let ingredientCell   = UINib(nibName: "ReceipeIngredient", bundle: nil)
        let otherItemCell   = UINib(nibName: "OtherItemSubCollectionViewCell", bundle: nil)

        let headerNib = UINib(nibName: "CollectionSimpleHeader", bundle: nil)

        collectionView.registerNib(ingredientCell, forCellWithReuseIdentifier: cellID_IngrediantSubCollectionViewCell)
        collectionView.registerNib(otherItemCell, forCellWithReuseIdentifier: cellID_OtherItemSubCollectionViewCell)
        
        collectionView.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeader_PlainText)

        let flowlayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0
        flowlayout.sectionInset         = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if collectionView_ != collectionView {
            flowlayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        }else {
            flowlayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        }
    }
    
    private func registerCollectionCell(){
        let featuredReceipeNib = UINib(nibName: "FeaturedReceipePreview", bundle: nil)
        let featuredChannelNib = UINib(nibName: "FeautredChannelsCell", bundle: nil)
        let imageCellNib        = UINib(nibName: "ImageGalleryCollectionViewCell", bundle: nil)
        let collectionViewNib   = UINib(nibName: "CollectionViewCollectionViewCell", bundle: nil)
        let categoryViewNib   = UINib(nibName: "CategoryCollectionCell", bundle: nil)
        
        let headerNib = UINib(nibName: "CollectionSimpleHeader", bundle: nil)
        
        collectionView_.registerNib(featuredReceipeNib, forCellWithReuseIdentifier: cellID_FeaturedReceipe)
        collectionView_.registerNib(featuredChannelNib, forCellWithReuseIdentifier: cellID_FeaturedChannel)
        collectionView_.registerNib(imageCellNib, forCellWithReuseIdentifier: cellID_ImageGalleryPreviewCell)
        collectionView_.registerClass(NSClassFromString("Recipe.StepsWithImageCollectionViewCell"), forCellWithReuseIdentifier: cellID_ReceipeStepCell)
        collectionView_.registerClass(NSClassFromString("Recipe.IngredientCollectionViewCell"), forCellWithReuseIdentifier: cellID_IngrediantCell)
        collectionView_.registerNib(collectionViewNib, forCellWithReuseIdentifier: cellID_CollectionViewCell)
        collectionView_.registerNib(categoryViewNib, forCellWithReuseIdentifier: cellID_CategoryCell)
        
        collectionView_.registerNib(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeader_PlainText)
        
        
        registerOtherCollectionView(collectionView_)

        let flowlayout = collectionView_.collectionViewLayout as! UICollectionViewFlowLayout
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0
        flowlayout.sectionInset         = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowlayout.scrollDirection = UICollectionViewScrollDirection.Vertical
    
    }
    
    private func receipieStepsCell(indexPath:NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_ReceipeStepCell, forIndexPath: indexPath) as! StepsWithImageCollectionViewCell
        let sectionItem = data![indexPath.section]
        let item = sectionItem.subItems[indexPath.row]
        cell.setItem(item)
        return cell
    }
    
    private func ingrediantCell(indexPath:NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_IngrediantSubCollectionViewCell, forIndexPath: indexPath) as! IngredientCollectionViewCollectionViewCell
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        cell.setItem(item)
        return cell
    }
    
    private func otherItemRequiredCell(indexPath:NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_OtherItemSubCollectionViewCell, forIndexPath: indexPath) as! IngredientCollectionViewCollectionViewCell
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        cell.setItem(item)
        return cell
    }
    
    private func categoryCell(indexPath:NSIndexPath, collectionView:UICollectionView) ->CategoryCollectionCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_CategoryCell, forIndexPath: indexPath) as! CategoryCollectionCell
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        cell.setItem(item)
        return cell
    }
    
    private func collectionSectionCell(indexPath:NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_CollectionViewCell, forIndexPath: indexPath) as! GenericCollectionViewCell
        if cell.collectionView != nil {
            let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
            let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
            // Register cell
            registerOtherCollectionView(cell.collectionView)
            cell.collectionView.dataSource = self
            cell.collectionView.delegate    = self
            let needToReload = otherCollectionViewSectionItemMap[cell.collectionView] != sectionItem
            // Set Delegates
            otherCollectionViewSectionItemMap[cell.collectionView] = sectionItem
            
            if needToReload {
                cell.collectionView.reloadData()
            }
        }
        
        return cell
    }
    
    private func featuredReceipeCell(indexPath:NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_FeaturedReceipe, forIndexPath: indexPath) as! FeaturedReceipeCollectionViewCell
        
        let sectionItem = data![indexPath.section]
        let item = sectionItem.subItems[indexPath.row]
        
        cell.setItem(item)
        return cell
    }
    
    private func featuredChannelCell(indexPath:NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_FeaturedChannel, forIndexPath: indexPath) as! FeautredChannelsCollectionViewCell
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        
        cell.setItem(item)
        return cell

    }
    
    private func imageGalleryPreviewCell(indexPath: NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_ImageGalleryPreviewCell, forIndexPath: indexPath) as! ImageCollectionViewCell
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        
        cell.setItem(item)
        return cell
    }
    
    private func cell(indexPath:NSIndexPath, collectionView:UICollectionView) -> UICollectionViewCell!{
        
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        
        if sectionItem.itemType == ItemType.ImageGallery {
            return imageGalleryPreviewCell(indexPath, collectionView: collectionView)
        }
        
        if item.itemType == ItemType.Receipe {
            return featuredReceipeCell(indexPath, collectionView: collectionView)
        } else if item.itemType == ItemType.Channel {
            return featuredChannelCell(indexPath, collectionView: collectionView)
        } else if item.itemType == ItemType.ReceipeStep {
            return receipieStepsCell(indexPath, collectionView: collectionView)
        }
        
        if sectionItem.itemType == ItemType.Collection && collectionView_ == collectionView {
            return collectionSectionCell(indexPath, collectionView: collectionView)
        }
        
        if item.itemType == ItemType.ReceipeIngredient {
            return ingrediantCell(indexPath, collectionView: collectionView)
        }
        
        if item.itemType == ItemType.ReceipCategory {
            return categoryCell(indexPath, collectionView: collectionView)
        }
        
        if item.itemType == ItemType.OtherItemRequired {
            return otherItemRequiredCell(indexPath, collectionView: collectionView)
        }
        
        return UICollectionViewCell()
//        return collectionView_!.dequeueReusableCellWithReuseIdentifier("thiswillcrash", forIndexPath: indexPath) as UICollectionViewCell
    }
    
//    MARK: Image download notification helper
    
    private func addImageDownloadNotificationObservers(senders:[Item]?){

        if senders == nil {
            return
        }
        
        let sel = Selector("imageDownloadedForDataSubItem:")
        if self.respondsToSelector(sel) {
            for item in senders! {
                for subItem in item.subItems {
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDownloadedForDataSubItem:", name: ImageDownloader.kImageDownloadNotification, object: subItem)
                }
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDownloadedForDataSubItem:", name: ImageDownloader.kImageDownloadNotification, object: item)
            }
        }
       
        
        
    }
    
    private func removeImageDownloadNotificationObservers(senders:[Item]?){
        
        if senders == nil {
            return
        }
        
        for item in senders! {
            for subItem in item.subItems {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDownloadedForDataSubItem:", name: ImageDownloader.kImageDownloadNotification, object: subItem)
            }
            NSNotificationCenter.defaultCenter().removeObserver(item)
        }
    }
    
//  MARK: Image Downloaded notification
    @objc private func imageDownloadedForDataSubItem(notification:NSNotification){
        if notification.object == nil || data == nil {return}
        
        let sender = notification.object as! Item
        let parentOfSender = sender.parentItem
        
        if parentOfSender == nil {return}
        
        let sectionPosition = data!.indexOf(parentOfSender!)
        
        if sectionPosition != NSNotFound {
            let rowPosition = parentOfSender!.subItems.indexOf(sender)
            if rowPosition == NSNotFound || rowPosition == nil {return}
            
            
            
            if parentOfSender?.itemType == ItemType.Collection {
                let indexPath = NSIndexPath(forRow: 0, inSection: sectionPosition!)
                let cell  = collectionView_.cellForItemAtIndexPath(indexPath)

                let genericCell = cell as? GenericCollectionViewCell
                let subItemIndexPath = NSIndexPath(forRow: rowPosition!, inSection: 0)
                
                let subItemCell = genericCell?.collectionView.cellForItemAtIndexPath(subItemIndexPath) as? IngredientCollectionViewCollectionViewCell
                
                if subItemCell == nil {
//                    genericCell?.collectionView.reloadItemsAtIndexPaths([subItemIndexPath])
                }else {
                    subItemCell?.setItem(sender)
                }
                
                
            }else {
                let indexPath = NSIndexPath(forRow: rowPosition!, inSection: sectionPosition!)

                let cell  = collectionView_.cellForItemAtIndexPath(indexPath)

                let cellClassRequired:AnyClass? = NSClassFromString("Recipe.BackgroundImageLayerCollectionViewCell")
                if cellClassRequired != nil {
                    if (cell != nil && cell?.isKindOfClass(cellClassRequired!) == true) {
                        let featuredReceipeCell = cell as! BackgroundImageLayerCollectionViewCell
                        featuredReceipeCell.setItem(sender)
                    }else {
                        //  collectionView_.reloadItemsAtIndexPaths([indexPath])
                    }
                }
            }
            
            
            
        }
        
    }
    
//    MARK: Public Methods
    required init(collectionView:UICollectionView!, interactionDelegate:AnyObject?) {
        collectionView_ = collectionView
        super.init()
        self.registerCollectionCell()
        offscreenCell_channel = (NSBundle.mainBundle().loadNibNamed("FeautredChannelsCell", owner: self, options: nil).last) as! FeautredChannelsCollectionViewCell
        
        offscreenCell_channel.contentView.setContentHuggingPriority(248, forAxis: UILayoutConstraintAxis.Vertical)
        offscreenCell_channel.contentView.setContentHuggingPriority(248, forAxis: UILayoutConstraintAxis.Horizontal)

    }
    
    func setCollectionData(collectionData:[Item]?){
        removeImageDownloadNotificationObservers(data)
        addImageDownloadNotificationObservers(collectionData)
        data = collectionData
        collectionView_.reloadData()
    }
    
//    MARK: Collection view datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView == collectionView_ {
            if data == nil { return 0 }
            return data!.count
        }
        
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let count = otherCollectionSection?.subItems.count > 0 ? 1: 1
        return count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == collectionView_ {
            if data == nil {return 0}
            let item = data![section]
            if item.itemType == ItemType.Collection {
                return item.subItems.count > 0 ? 1:0
            }
            return item.itemType == ItemType.Invalid ? 0:item.subItems.count;
        }
        
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        if otherCollectionSection == nil {
            return 0
        }else {
            return otherCollectionSection!.subItems.count
        }
   
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return cell(indexPath, collectionView: collectionView)
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeader_PlainText, forIndexPath: indexPath) as! BasicCollectionReusableView
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!

        header.label.text = sectionItem.name
        
        header.clipsToBounds = true
        return header
    }

    
    
    
//    MARK: Flow layout delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        
        let flowLayput = collectionViewLayout as! UICollectionViewFlowLayout
        var width = collectionView.bounds.size.width - flowLayput.sectionInset.left - flowLayput.sectionInset.right;

        if item.itemType == ItemType.Receipe || item.itemType == ItemType.Image {
            var height:CGFloat
            if item.imageAspectRatio <= 0 {
                height = 150
            }else {
                height = width/item.imageAspectRatio
                height = ceil(height)
            }
            
            let isLandscape = collectionView.bounds.size.width > collectionView.bounds.size.height
            
            let maxHeight = isLandscape ? collectionView.bounds.size.height: collectionView.bounds.size.height/2.0
            
            if height > maxHeight {
                height = maxHeight
            }
            
            if collectionView.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular {
                if (width/2.0 < 320.0) {
                    width = width/2.0
                }else {
                    let numberOfItemCanBeFit = Int(width/320.0)
                    if numberOfItemCanBeFit > 1 {
                        width = width/CGFloat(numberOfItemCanBeFit)
                    }
                    
                }
            }
            
            return CGSizeMake(width, height)
        } else if (item.itemType == ItemType.Channel) {
            offscreenCell_channel.setItem(item)
            offscreenCell_channel.channelDescription?.preferredMaxLayoutWidth = width - 40
            offscreenCell_channel.channelLabel?.preferredMaxLayoutWidth = width - 40
            let height = offscreenCell_channel.systemLayoutSizeFittingSize(CGSizeMake(width, 500)).height
            return CGSizeMake(width, ceil( height))
        } else if (item.itemType == ItemType.ReceipeStep) {
            offscreenCell_receipeStep.frame = CGRectMake(0, 0, collectionView.bounds.size.width, 1000)
            offscreenCell_receipeStep.setItem(item)
            let height = offscreenCell_receipeStep.systemLayoutSizeFittingSize(CGSizeMake(width, 1000)).height
            return CGSizeMake(width, ceil( height))
        } else if item.itemType == ItemType.ReceipCategory {
            if offscreenCell_category == nil {
                let option = Dictionary<NSObject, AnyObject>()
                offscreenCell_category = NSBundle.mainBundle().loadNibNamed("CategoryCollectionCell", owner: self, options: option).last as? CategoryCollectionCell
            }
            offscreenCell_category!.frame = CGRectMake(0, 0, collectionView.bounds.size.width, 1000)
            offscreenCell_category!.setNeedsLayout()
            offscreenCell_category!.layoutIfNeeded()
            offscreenCell_category!.setItem(item)
            let height = offscreenCell_category!.systemLayoutSizeFittingSize(CGSizeMake(width, 1000)).height
            return CGSizeMake(width, ceil( height))
        }
        
        if (sectionItem.itemType == ItemType.Collection || sectionItem.itemType == ItemType.Collection) && collectionView_ == collectionView{
            return CGSizeMake(width, 202)
        }
        
        if item.itemType == ItemType.ReceipeIngredient || item.itemType == ItemType.OtherItemRequired {
            return CGSizeMake(180, collectionView.bounds.size.height)
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if collectionView_ == collectionView {
            if offscreenHeader_Basic == nil {
                //let nib = UINib(nibName: "CollectionSimpleHeader", bundle: nil)
                let options = Dictionary<NSObject, AnyObject>()
                offscreenHeader_Basic = NSBundle.mainBundle().loadNibNamed("CollectionSimpleHeader", owner: self, options: options).last as? BasicCollectionReusableView
            }
            let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
            let sectionItem = otherCollectionSection == nil ? data![section]: otherCollectionSection!
            
            offscreenHeader_Basic!.label.text = sectionItem.name
            
            offscreenHeader_Basic?.frame = CGRectMake(0, 0, collectionView.bounds.size.width, 400)
            offscreenHeader_Basic?.setNeedsLayout()
            offscreenHeader_Basic?.layoutIfNeeded()
            
            let height = ceil(offscreenHeader_Basic!.systemLayoutSizeFittingSize(CGSizeMake(collectionView.bounds.size.width, 400)).height)
            
            return CGSizeMake(collectionView.bounds.size.width, height)
        }
        
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let otherCollectionSection = otherCollectionViewSectionItemMap[collectionView]
        let sectionItem = otherCollectionSection == nil ? data![indexPath.section]: otherCollectionSection!
        let item = sectionItem.subItems[indexPath.row]
        
        selection?(sectionItem:sectionItem, rowItem:item, indexPath:indexPath, collectionView:collectionView)
        
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
//    
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
//    
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
//    
//    }
    
}
