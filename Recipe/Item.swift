//
//  Item.swift
//  Recipe
//
//  Created by atif on 6/7/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit

enum ItemType{
    case Invalid

    case CollectionFeaturedReceipe
    case CollectionFeaturedChannels
    case CollectionReceipeStepCollection
    case ImageGallery
    case Receipe
    case Channel
    case Image
    case ReceipeStep

    case ReceipeIngredient
    case RecipeCategories
    case ReceipCategory
    case Collection
    case OtherItemRequired
}

class Item: ImageDownloader {
    
    static let kItemTypeName_Channel                    = "Channel"
    static let kItemTypeName_Receipe                    = "Recipe"
    static let kItemTypeName_CollectionFeaturedReceipes = "CollectionFeaturedReceipes"
    static let kItemTypeName_CollectionFeaturedChannels = "CollectionFeaturedChannels"

    static let kItemTypeName_ImageGallery               = "ImageGallery"
    static let kItemTypeName_Image                      = "Image"
    static let kItemTypeName_Ingredients                = "Ingredients"
    static let kItemTypeName_ReceipeIngredient          = "ReceipeIngredient"
    static let kItemTypeName_ReceipeStep                = "ReceipeStep"
    static let kItemTypeName_YoutubeLink                = "YoutubeLink"
    static let kItemTypeName_CollectionReceipeStep      = "CollectionReceipeStep"
    static let kItemTypeName_ReceipeCategories          = "Categories"
    static let kItemTypeName_ReceipeCategory            = "Category"
    
    static let kItemTypeName_Collection                 = "Collection"
    static let kItemTypeName_OtherItemRequired          = "OtherItemRequired"

    let itemType:ItemType
    let itemId:String?
    let name:String?
    let cookingTime:Int?
    let authors:String?
    let itemDescription:String?
    let imageURL:String?
    let imageAspectRatio:CGFloat
    let receipeCount:Int?
    let subItemIndex:Int?
    let quantityDisplay:String?
    weak var parentItem:Item?
    var subItems:[Item] = []
    
    //TODO: Create ingredients class, store ingrediants with their quantities. Than add a property of to store array of ingrediants
    
    class func itemTypeForName(name:NSString?) -> ItemType{
        if name != nil {
            //
            if name!.isEqualToString(kItemTypeName_ImageGallery) {return .ImageGallery}
            if name!.isEqualToString(kItemTypeName_Image) {return .Image}
            
            if name!.isEqualToString(kItemTypeName_Channel) {return .Channel}
            if name!.isEqualToString(kItemTypeName_Receipe) {return .Receipe}
            if name!.isEqualToString(kItemTypeName_CollectionFeaturedReceipes) {return .CollectionFeaturedReceipe}
            if name!.isEqualToString(kItemTypeName_CollectionFeaturedChannels) {return .CollectionFeaturedChannels}
            
            if name!.isEqualToString(kItemTypeName_CollectionReceipeStep) {return .CollectionReceipeStepCollection}
            
            if name!.isEqualToString(kItemTypeName_ReceipeStep) {return .ReceipeStep}
            if name!.isEqualToString(kItemTypeName_ReceipeIngredient) {return .ReceipeIngredient}
            
            if name!.isEqualToString(kItemTypeName_ReceipeCategories){return .RecipeCategories}
            
            if name!.isEqualToString(kItemTypeName_ReceipeCategory){return .ReceipCategory}
            
            if name!.isEqualToString(kItemTypeName_Collection) {
                return .Collection
            }

            if name!.isEqualToString(kItemTypeName_OtherItemRequired) {
                return .OtherItemRequired
            }
        }
        return .Invalid
    }
    
//    MARK: Intialize instance with dictionary
    init(info:[NSString:AnyObject]) {
        
//      MARK: Read and assign values
        name = info["name"] as? String
        cookingTime = info["time"] as? Int
        authors = info["authors"] as? String
        itemDescription = info["itemDescription"] as? String
        imageURL = info["imgUrl"] as? String
        receipeCount = info["receipesCount"] as? Int
        itemType = Item.itemTypeForName(info["itemType"] as? String)
        subItemIndex = info["subItemIndex"] as? Int
        quantityDisplay = info["quantity-display"] as? String
        itemId          = info["itemId"] as? String
//      MARK: Set image aspect ration required
    
        let imgAspectRatioTmp = info["aspectRatio"] as? CGFloat

        if imgAspectRatioTmp == nil || imgAspectRatioTmp <= 0 {
            imageAspectRatio = 0
        }else {
            imageAspectRatio = imgAspectRatioTmp!
        }
        
//       MARK: Create image url
        var url:NSURL? = nil
        if imageURL != nil {
            url = NSURL(string: imageURL!)
        }
        
        super.init(imageURL: url)

//      MARK: Sub items
        let tempItemsJSON = info["subItems"] as? Array<Dictionary<NSString,AnyObject>>
        if tempItemsJSON != nil {
            for tempItemJSON in tempItemsJSON! {
                let itemTypeString = tempItemJSON["itemType"] as? String
                let tempItemType = Item.itemTypeForName(itemTypeString)
                if tempItemType == ItemType.Invalid {continue}
                
                let item = Item(info:tempItemJSON)
                item.parentItem = self
                subItems.append(item)
            }
        }
    }
    
    
//    MARK: Used only for simulation purpose

    class func simulatedRecipeHomeScreenItems() -> [Item]?{
        
        let url = NSBundle.mainBundle().URLForResource("homejson", withExtension: "json")

        let inputStream = NSInputStream(URL: url!)
        inputStream?.open()
        do {
            let parsedData = (try NSJSONSerialization.JSONObjectWithStream(inputStream!, options: NSJSONReadingOptions.MutableContainers)) as? Array<Dictionary<NSString,AnyObject>>
            var items = Array<Item>()
            for itemJSON in parsedData! {
                let item = Item(info:itemJSON)
                items.append(item)
            }
            
            return items
        } catch {
            
        }
       
        return nil
    }
    
}
