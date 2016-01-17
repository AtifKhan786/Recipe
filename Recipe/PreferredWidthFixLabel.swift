//
//  PreferredWidthFixLabel.swift
//  Recipe
//
//  Created by atif on 7/5/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class PreferredWidthFixLabel: UILabel {

    override var bounds:CGRect {
        didSet {
            self.preferredMaxLayoutWidth = bounds.size.width
        }
    }

}
