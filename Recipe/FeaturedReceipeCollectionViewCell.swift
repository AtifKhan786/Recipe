//
//  FeaturedReceipeCollectionViewCell.swift
//  Recipe
//
//  Created by atif on 6/8/15.
//  Copyright (c) 2015 Atif Khan. All rights reserved.
//

import UIKit

class FeaturedReceipeCollectionViewCell: BackgroundImageLayerCollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingrediantsLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    private var topGradiant:CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = Theme.mainTheme().regularFont(25)
        ingrediantsLabel.font = Theme.mainTheme().lightFont(16)
        authorLabel.font = Theme.mainTheme().boldFont(14)
        clipsToBounds = true 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpGradiantLayers()
    }
    
    private func setUpGradiantLayers(){

        
        if (topGradiant == nil ){
            topGradiant = CAGradientLayer()
            topGradiant?.backgroundColor = UIColor.clearColor().CGColor
            topGradiant!.colors = [
                UIColor.blackColor().CGColor,
                UIColor.clearColor().CGColor
            ]
            contentView.layer.insertSublayer(topGradiant!, above: imgLayer_!)
        }
        
        let frame           = CGRectMake(0, 0, self.contentView.bounds.size.width, ingrediantsLabel.frame.origin.y + ingrediantsLabel.frame.size.height + 20.0)
        topGradiant!.frame  = frame
        topGradiant!.drawsAsynchronously = true
    }
    
    override func setItem(item:Item){
        
        let img = item.getImageForSize(contentView.bounds.size, shouldUseInMemoryCache: true)
        setBackgroundLayerImage(img)
        nameLabel.text = item.name
        authorLabel.text = item.authors
        ingrediantsLabel.text = item.itemDescription
        setUpGradiantLayers()
    }
    
}
