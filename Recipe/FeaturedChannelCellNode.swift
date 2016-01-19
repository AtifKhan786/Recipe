//
//  FeaturedChannelCellNode.swift
//  Recipe
//
//  Created by atif on 1/19/16.
//  Copyright © 2016 Atif Khan. All rights reserved.
//

import UIKit

class FeaturedChannelCellNode: ASCellNode {
    
    let titleNode:ASTextNode
    let descrNode:ASTextNode?
    let receipeCountNode:ASTextNode?
    let cellWidth:CGFloat

    init(item:Item, width:CGFloat) {
    
        titleNode = ASTextNode()
        titleNode.maximumNumberOfLines = 0
        
        var tmpDescrNode:ASTextNode? = nil
        if item.itemDescription?.isEmpty == false {
            tmpDescrNode = ASTextNode()
            tmpDescrNode?.maximumNumberOfLines = 3
        }
        
        descrNode = tmpDescrNode

        var tmpCountNode:ASTextNode? = nil
        if "19 receipe".isEmpty == false {
            tmpCountNode = ASTextNode()
        }
        receipeCountNode = tmpCountNode
        cellWidth = width
        super.init()
        
        let themeData = AppTheme.defaultTheme()
        
        titleNode.attributedString = item.name!.attributeString(themeData.titleFont, textColor: themeData.defaultTextColor, kern: nil)
        addSubnode(titleNode)
        if descrNode != nil {
            descrNode!.attributedString = item.itemDescription!.attributeString(themeData.descriptionFont, textColor: themeData.defaultTextColor, kern: nil)
            addSubnode(descrNode!)
        }
        if receipeCountNode != nil {
            receipeCountNode!.attributedString = "19 recipes".attributeString(themeData.subTitleFont, textColor: themeData.tintTextColor, kern: nil)
            addSubnode(receipeCountNode!)
        }
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackLayoutSpec = ASStackLayoutSpec.verticalStackLayoutSpec()
        
        var verticalStackLayoutChildrens = Array<ASLayoutable>()
        verticalStackLayoutChildrens.append(titleNode)
        if descrNode != nil {
            verticalStackLayoutChildrens.append(descrNode!)
        }
        if receipeCountNode != nil {
            verticalStackLayoutChildrens.append(receipeCountNode!)
        }
        
        verticalStackLayoutSpec.setChildren(verticalStackLayoutChildrens)
        
        let insetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: verticalStackLayoutSpec)
        insetSpec.sizeRange = ASRelativeSizeRange.relativeSize(cellWidth, maxHeight: 1000, minHeight: 40)
        
        return ASStaticLayoutSpec(children: [insetSpec])
    }
}
