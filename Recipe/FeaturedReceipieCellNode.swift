//
//  FeaturedReceipieCellNode.swift
//  Recipe
//
//  Created by atif on 1/17/16.
//  Copyright © 2016 Atif Khan. All rights reserved.
//

import UIKit

extension ASRelativeSizeRange {
    
    static func relativeSize(fixedWidth:CGFloat, maxHeight:CGFloat, minHeight:CGFloat) -> ASRelativeSizeRange {
        let cellWidthDimension = ASRelativeDimensionMakeWithPoints(fixedWidth)
        let minSize = ASRelativeSizeMake(cellWidthDimension, ASRelativeDimensionMakeWithPoints(minHeight))
        let maxSize = ASRelativeSizeMake(cellWidthDimension, ASRelativeDimensionMakeWithPoints(maxHeight))
        
        return ASRelativeSizeRange(min: minSize, max: maxSize)
    }
    
    static func relativeSize(fixedWidth:CGFloat, heightPercantage:CGFloat) -> ASRelativeSizeRange {
        let cellWidthDimension = ASRelativeDimensionMakeWithPoints(fixedWidth)
        return ASRelativeSizeRangeMakeWithExactRelativeDimensions(cellWidthDimension, ASRelativeDimensionMakeWithPercent(heightPercantage))

    }
}

class FeaturedReceipieCellNode: ASCellNode, ASNetworkImageNodeDelegate {
    static var index = 0
    var thisIndex:Int
    let imageNode:ASNetworkImageNode
    let textBackImageNode:ASImageNode?
    let receipeNameLabelNode:ASTextNode?
    let cookingTimeLabelNode:ASTextNode?
    let authorLabelNode:ASTextNode?
    let descrLabelNode:ASTextNode?
    
    let dataItem:Item
    let cellSize:CGSize
    
    init(item:Item, size:CGSize) {
        thisIndex = FeaturedReceipieCellNode.index
        FeaturedReceipieCellNode.index++
        
        dataItem = item
        
        // Create nodes as required
        imageNode = ASNetworkImageNode()
        imageNode.contentMode = UIViewContentMode.ScaleAspectFit;
        
        imageNode.shouldCacheImage = true
        
        var tmpTextBackImageNode:ASImageNode? = nil
        
        if item.imageURL != nil {
            if let imageUrl = NSURL(string: item.imageURL!) {
                imageNode.URL = imageUrl
                tmpTextBackImageNode = ASImageNode()
            }
        }
        textBackImageNode = tmpTextBackImageNode
        
        if item.name == nil || item.name?.isEmpty == true {
            receipeNameLabelNode = nil
        }else {
            receipeNameLabelNode    = ASTextNode()
        }
        
        if item.cookingTime == nil || item.cookingTime == 0 {
            cookingTimeLabelNode    = nil
        }else {
            cookingTimeLabelNode    = ASTextNode()
        }
        
        if item.authors?.isEmpty == true || item.authors == nil {
            authorLabelNode         = nil
        }else {
            authorLabelNode         = ASTextNode()
        }
        
        if item.itemDescription?.isEmpty == true || item.itemDescription == nil{
            descrLabelNode = nil
        }else {
            descrLabelNode          = ASTextNode()
            descrLabelNode?.maximumNumberOfLines = 2
        }
        cellSize = size
        
        super.init()
        // Add and initialise nodes for use if they exist
        if textBackImageNode != nil {
            textBackImageNode?.contentMode = UIViewContentMode.ScaleAspectFill
            addSubnode(textBackImageNode!)
        }
        imageNode.delegate = self

        let textColor = UIColor.whiteColor()
        
        if receipeNameLabelNode != nil {
            addSubnode(receipeNameLabelNode!)
            
            receipeNameLabelNode?.attributedString = item.name?.attributeString(UIFont.boldSystemFontOfSize(20), textColor: textColor, kern: nil)
        }
        
        if authorLabelNode != nil {
            addSubnode(authorLabelNode!)
            
            authorLabelNode?.attributedString = item.authors?.attributeString(UIFont.systemFontOfSize(17), textColor: textColor, kern: nil)
        }
        
        if cookingTimeLabelNode != nil {
            addSubnode(cookingTimeLabelNode!)
            
            cookingTimeLabelNode?.attributedString = "35 mins".attributeString(UIFont.systemFontOfSize(17), textColor: textColor, kern: nil)
            //                NSAttributedString(string: "35 mins")
        }
        
        if descrLabelNode != nil {
            addSubnode(descrLabelNode!)
            
            descrLabelNode?.attributedString = item.itemDescription?.attributeString(UIFont.systemFontOfSize(14), textColor: textColor, kern: nil)
        }
        addSubnode(imageNode)

        
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec
    {
        // Set pref sizes
//        imageNode.preferredFrameSize = CGSizeMake(80, 80)
        imageNode.sizeRange = ASRelativeSizeRange.relativeSize(80, maxHeight: 120, minHeight: 80)
        // Main content layout
        
        let mainContentVerticalLayoutSpec = ASStackLayoutSpec.verticalStackLayoutSpec()
        let mainContentHLayoutSpec = ASStackLayoutSpec.horizontalStackLayoutSpec()
        
        mainContentHLayoutSpec.spacing = 5
        mainContentHLayoutSpec.alignItems = ASStackLayoutAlignItems.Center

        var mainContentVerticalLayoutSpecChildrens = Array<ASLayoutable>()

        if receipeNameLabelNode != nil {
            mainContentVerticalLayoutSpecChildrens.append(receipeNameLabelNode!)
        }
        if authorLabelNode != nil {
            mainContentVerticalLayoutSpecChildrens.append(authorLabelNode!)
        }
        
        if cookingTimeLabelNode != nil {
            mainContentVerticalLayoutSpecChildrens.append(cookingTimeLabelNode!)
        }
        
        if descrLabelNode != nil {
            mainContentVerticalLayoutSpecChildrens.append(descrLabelNode!)
        }
        
        mainContentVerticalLayoutSpec.setChildren(mainContentVerticalLayoutSpecChildrens)
        
        mainContentHLayoutSpec.setChildren([ASStaticLayoutSpec(children: [imageNode]), mainContentVerticalLayoutSpec])

        
        // Add Inset layout spec and add it to a container which will be for ground of blured back
        
        let insetMainLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: mainContentHLayoutSpec)
        let insetLayoutContainerSpec = ASStackLayoutSpec.verticalStackLayoutSpec()
        insetLayoutContainerSpec.setChildren([insetMainLayoutSpec])
        
        insetLayoutContainerSpec.sizeRange = ASRelativeSizeRange.relativeSize(cellSize.width, maxHeight: 500, minHeight: 44)
        
        let mainContentBluredBackgroundLayoutSpec = ASBackgroundLayoutSpec(child: ASStaticLayoutSpec(children: [insetLayoutContainerSpec]), background: textBackImageNode!)
      
        
        return mainContentBluredBackgroundLayoutSpec

    }
    

    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {
        let beingTime = NSDate.timeIntervalSinceReferenceDate()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            let blur = image.applyDarkEffect()
            let endTime = NSDate.timeIntervalSinceReferenceDate()
            self.textBackImageNode?.image = blur
            let imgSize = image.size
            print("Index: \(self.thisIndex) After blur, time taken: \(endTime - beingTime), pixel: (\(imgSize.width)x\(imgSize.height))")
        }
    }
    
}
