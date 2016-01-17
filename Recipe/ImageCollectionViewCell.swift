//
//  ImageCollectionViewCell.swift
//  Recipe
//
//  Created by atif on 6/18/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: BackgroundImageLayerCollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    
    override func setItem(item:Item){
        let img = item.getImageForSize(contentView.bounds.size, shouldUseInMemoryCache: true)
        setBackgroundLayerImage(img)
       
    }
}
