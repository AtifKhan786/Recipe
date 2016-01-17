//
//  CategoryCollectionCell.swift
//  Recipe
//
//  Created by atif on 7/7/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class CategoryCollectionCell: BackgroundImageLayerCollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var seperatorView: UIView!

    var initializeOnce = false
    private let kImgSquareLength = CGFloat(34)
    
    override func setImageLayerFrame(){
        let imgFrame = CGRectMake(20, CGRectGetMidY(self.bounds) - kImgSquareLength/2, kImgSquareLength, kImgSquareLength)
        imgLayer_?.frame = imgFrame
        imgLayer_?.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageLayerFrame()
    }
    
    private func commonInit(){
        if initializeOnce {
            return
        }
        initializeOnce = true
      
        backgroundColor = UIColor.whiteColor()
        contentView.backgroundColor = UIColor.whiteColor()
        setImageLayerFrame()
    }

    override func setItem(item: Item) {
        super.setItem(item)
        commonInit()
        label?.text = item.name
        let indexInSubItems = item.parentItem?.subItems.indexOf(item)
        
        seperatorView.hidden = false
        if indexInSubItems != nil && indexInSubItems != NSNotFound {
            if (indexInSubItems! + 1) == item.parentItem?.subItems.count {
                seperatorView.hidden = true
            }
        }
    }
}
