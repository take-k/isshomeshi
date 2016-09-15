//
//  CookSelectViewController.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Sapporo

class CookSelectViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var sapporo: Sapporo = Sapporo(collectionView: self.collectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        
        let layout = SAFlowLayout()
        layout.scrollDirection = .Vertical
        layout.itemSize = CGSizeMake( 100, 70)
    }
    
}
