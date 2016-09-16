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
    let id:Int
    let name :String
    let imageUrl:String
    let ienow:Int
    
    init(name: String,id:Int, imageUrl:String, ienow:Int , selectionHandler: SASelectionHandler) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.ienow = ienow
        let size = CGSize(width: 70, height: 50)
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
        
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        if let imageUrl = NSURL(string:cellmodel.imageUrl) {
            imageView.af_setImageWithURL(imageUrl)
        }
        
    }
    
    override func willDisplay(collectionView: UICollectionView) {
        super.willDisplay(collectionView)
    }
}
