//
//  CookCell.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Sapporo

class CookCellModel: SACellModel {
    let name :String
    let linkUrl:String
    let good:Int
    
    init(name: String, linkUrl:String, good:Int , selectionHandler: SASelectionHandler) {
        self.name = name
        self.linkUrl = linkUrl
        self.good = good
        let size = CGSize(width: 100, height: 70)
        super.init(cellType: MemberCell.self, size: size, selectionHandler: selectionHandler)
    }
}

class CookCell: SACell ,SACellType {
    typealias CellModel = CookCellModel
    @IBOutlet weak var imageView: UIImageView!
    
    override func configure() {
        super.configure()
        
        guard let cellmodel = cellmodel else {
            return
        }
    }
    
    override func willDisplay(collectionView: UICollectionView) {
        super.willDisplay(collectionView)
    }
}

