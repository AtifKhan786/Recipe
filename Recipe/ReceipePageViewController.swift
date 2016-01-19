//
//  ReceipePageViewController.swift
//  Recipe
//
//  Created by atif on 6/18/15.
//  Copyright © 2015 Atif Khan. All rights reserved.
//

import UIKit

class ReceipePageViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var receipeDetail:ReceipeItemDetail?
    var collectionViewDelegate:CollectionViewDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
