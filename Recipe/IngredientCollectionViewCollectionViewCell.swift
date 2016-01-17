//
//  IngredientCollectionViewCollectionViewCell.swift
//  Recipe
//
//  Created by atif on 7/6/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class IngredientCollectionViewCollectionViewCell: BackgroundImageLayerCollectionViewCell {
    @IBOutlet weak var labelCentericContainerView: UIView?
    @IBOutlet weak var labelContainView: UIView?
    
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var label2: UILabel?
    
    var initializeOnce = false
    private let kImgHeight = CGFloat(120)
    
    override func setImageLayerFrame(){
        let imgFrame = CGRectMake(0, 0, self.bounds.size.width, kImgHeight)
        imgLayer_?.frame = imgFrame
        imgLayer_?.masksToBounds = true
    }
    
    func setTextBackgroundColor(backColor:UIColor){
        labelCentericContainerView?.backgroundColor = backColor
        labelContainView?.backgroundColor = backColor
    }
    
    override func setItem(item: Item) {
        super.setItem(item)
        label?.text = item.name
        label2?.text = item.quantityDisplay
        
        if item.itemType == ItemType.OtherItemRequired {
            label?.textColor = UIColor.whiteColor()
            setTextBackgroundColor(UIColor.OtherNeedItemTextureBackground())
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageLayerFrame()
    }
}
