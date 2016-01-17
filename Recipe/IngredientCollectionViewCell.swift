//
//  IngredientCollectionViewCell.swift
//  Recipe
//
//  Created by atif on 6/21/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class IngredientCollectionViewCell: BackgroundImageLayerCollectionViewCell {
    var ingredientLabel = PreferredWidthFixLabel()
    var initializeOnce = false
    private let kImgSquareLength = CGFloat(44)
    
    override func setImageLayerFrame(){
        let imgFrame = CGRectMake(10, CGRectGetMidY(self.bounds) - kImgSquareLength/2, kImgSquareLength, kImgSquareLength)
        imgLayer_?.frame = imgFrame
        imgLayer_?.masksToBounds = true
    }
    
    func setSubViewsFrame() {
        setImageLayerFrame()
        ingredientLabel.frame = CGRectMake(20 + kImgSquareLength, 5, bounds.size.width - 30 - kImgSquareLength, bounds.size.height - 10)
    }
    
    override func setItem(item: Item) {
        super.setItem(item)
        commonInit()
        ingredientLabel.text = nil
        
        var completeString = item.name
        
        if completeString != nil {
            completeString = completeString! + " "
        }
        
        if item.quantityDisplay != nil {
            completeString = completeString! + item.quantityDisplay!
        }
        
        let attrText = completeString?.attributeString(Theme.mainTheme().regularFont(17.0), textColor: UIColor(red: 20.0/255.0, green: 141.0/255.0, blue: 228.0/255.0, alpha: 1.0), kern: nil)
        
        ingredientLabel.attributedText = attrText

        if item.quantityDisplay != nil && attrText != nil{
            let modifiedAttributeString = attrText!.attributedStringForFirstMatchWithNewAttributes(item.quantityDisplay!, attributes: NSAttributedString.dictionaryForAttributeString(Theme.mainTheme().lightFont(17.0), textColor: UIColor.darkGrayColor(), kern: nil))
            if modifiedAttributeString != nil {
                ingredientLabel.attributedText = modifiedAttributeString
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSubViewsFrame()
    }
    
    private func commonInit(){
        if initializeOnce {
            return
        }
        initializeOnce = true
        ingredientLabel.numberOfLines = 0
        ingredientLabel.backgroundColor = UIColor.whiteColor()
        ingredientLabel.textAlignment = NSTextAlignment.Left
        ingredientLabel.font = Theme.mainTheme().regularFont(17.0)
        ingredientLabel.textColor = UIColor(red: 20.0/255.0, green: 141.0/255.0, blue: 228.0/255.0, alpha: 1.0)
       backgroundColor = UIColor.whiteColor()
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(ingredientLabel)
        setImageLayerFrame()
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let textWidth = size.width - 30 - kImgSquareLength
        let calcSize = ingredientLabel.systemLayoutSizeFittingSize(CGSizeMake(textWidth - 40, size.height))
        var height = calcSize.height
        let width = calcSize.width + kImgSquareLength + 30
        height += 20
        if height < kImgSquareLength + 20 {
            height = kImgSquareLength + 20
        }
        height = ceil(height)
        let newSize = CGSizeMake(width, height)
        return newSize
    }
}
