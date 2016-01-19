//
//  FeaturedCategoryCellNode.swift
//  Recipe
//
//  Created by atif on 1/19/16.
//  Copyright © 2016 Atif Khan. All rights reserved.
//

import UIKit

class FeaturedCategoryCellNode: ASCellNode {
    let imageNode:ASNetworkImageNode
    let titleNode:ASTextNode
    let cellWidth:CGFloat
    
    init(item:Item, width:CGFloat) {
        
        titleNode = ASTextNode()
        imageNode = ASNetworkImageNode()
        cellWidth = width
        
        super.init()
        
        titleNode.maximumNumberOfLines = 0
        
        let themeData = AppTheme.defaultTheme()
        
        titleNode.attributedString = item.name?.attributeString(themeData.mainBodyFont, textColor: themeData.defaultTextColor, kern: nil)
        if item.imageURL != nil {
            let url = NSURL(string: item.imageURL!)
            imageNode.URL = url
        }
        
        imageNode.defaultImage = UIImage(named: "defaultIcon")
        
        addSubnode(imageNode)
        addSubnode(titleNode)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {

        imageNode.preferredFrameSize = CGSizeMake(40, 40)
        
        let horizontalLayoutSpec = ASStackLayoutSpec.horizontalStackLayoutSpec()
        horizontalLayoutSpec.spacing = 5
        horizontalLayoutSpec.alignItems = ASStackLayoutAlignItems.Center
        horizontalLayoutSpec.setChildren([imageNode, titleNode])
        
        let insetLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: horizontalLayoutSpec)
        insetLayoutSpec.sizeRange = ASRelativeSizeRange.relativeSize(cellWidth, maxHeight: 100, minHeight: 44)
        return ASStaticLayoutSpec(children: [insetLayoutSpec])
    }
}
