//
//  MemberCell.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Sapporo

class MemberCellModel: SACellModel {
    let name :String
    let imageUrl:String
    
    init(name: String, imageUrl:String,  selectionHandler: SASelectionHandler) {
        self.name = name
        self.imageUrl = imageUrl
        let size = CGSize(width: 80, height: 80)
        super.init(cellType: MemberCell.self, size: size, selectionHandler: selectionHandler)
    }
}


class MemberCell: SACell, SACellType {
    typealias CellModel = MemberCellModel
    @IBOutlet weak var imageView: UIImageView!
    
    override func configure() {
        super.configure()
        
        guard let cellmodel = cellmodel else {
            return
        }
        
        if let imageUrl = NSURL(string:cellmodel.imageUrl) {
            //imageView.af_setImageWithURL(imageUrl)
        }
        
    }
    
    override func willDisplay(collectionView: UICollectionView) {
        super.willDisplay(collectionView)
    }
}
