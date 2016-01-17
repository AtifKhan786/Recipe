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
        
        receipeDetail = ReceipeItemDetail.simulatedReceipeDetail()
        navigationItem.title = receipeDetail?.name
        collectionViewDelegate = CollectionViewDelegate(collectionView: collectionView, interactionDelegate: nil)
        collectionView.dataSource = collectionViewDelegate
        collectionView.delegate = collectionViewDelegate
        
        collectionViewDelegate?.setCollectionData(receipeDetail?.subItems)
        collectionView.backgroundColor = UIColor.whiteColor()
        
    }

}
