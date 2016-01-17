//
//  FeautredChannelsCollectionViewCell.swift
//  Recipe
//
//  Created by atif on 6/17/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class FeautredChannelsCollectionViewCell: BackgroundImageLayerCollectionViewCell {

    @IBOutlet weak var channelLabel: UILabel?
    @IBOutlet weak var channelDescription: UILabel?
    @IBOutlet weak var numberOfReceipiesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        channelLabel?.font = Theme.mainTheme().boldFont(25)
        channelDescription?.font = Theme.mainTheme().thinFont(16)
        numberOfReceipiesLabel.font = Theme.mainTheme().regularFont(16)
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func setItem(item:Item){
        
        channelLabel?.text = item.name
        channelDescription?.text = item.itemDescription
        if item.receipeCount != nil && item.receipeCount > 0 {
            numberOfReceipiesLabel.text = "\(item.receipeCount!) recipes"
        } else {
            numberOfReceipiesLabel.text = "No receipes found"
        }
    }

}
