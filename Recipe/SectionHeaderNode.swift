//
//  SectionHeaderNode.swift
//  Recipe
//
//  Created by atif on 1/19/16.
//  Copyright © 2016 Atif Khan. All rights reserved.
//

import UIKit

class SectionHeaderNode: ASCellNode {
    
    let textNode:ASTextNode
    let cellWidth:CGFloat
    
    init(text:String, width:CGFloat) {
        
        textNode = ASTextNode()
        cellWidth = width
        
        super.init()
        
        textNode.maximumNumberOfLines = 0
        addSubnode(textNode)

        let theme = AppTheme.defaultTheme()
        textNode.attributedString = text.attributeString(theme.headerTitleFont, textColor: theme.headerTextColor, kern: nil)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let verticalStack = ASStackLayoutSpec.verticalStackLayoutSpec()
        verticalStack.setChildren([textNode])
        
        let insetLayoutSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(20, 10, 20, 10), child: verticalStack)
        insetLayoutSpec.sizeRange = ASRelativeSizeRange.relativeSize(cellWidth, maxHeight: 40, minHeight: 100)
        return insetLayoutSpec
    }
}
