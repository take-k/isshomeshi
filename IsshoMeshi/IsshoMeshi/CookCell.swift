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
    let id:Int
    let name :String
    let linkUrl:String
    var good:Int
    
    init(name: String, id:Int, linkUrl:String, good:Int , selectionHandler: SASelectionHandler) {
        self.id = id
        self.name = name
        self.linkUrl = linkUrl
        self.good = good
        let size = CGSize(width: 100, height: 70)
        super.init(cellType: CookCell.self, size: size, selectionHandler: selectionHandler)
    }
}

class CookCell: SACell ,SACellType {
    typealias CellModel = CookCellModel
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var goodLabel: UILabel!
    
    @IBOutlet weak var goodButton: UIButton!

    var imageView:UIImageView!
    var selectedImageView:UIImageView!
    
    var backId:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        imageView = UIImageView(image: UIImage(named: "cell0"))
        selectedImageView = UIImageView(image: UIImage(named: "touch0"))
        self.backgroundView?.addSubview(imageView)
        self.selectedBackgroundView?.addSubview(selectedImageView)
    }
    
    override func configure() {
        super.configure()
        
        guard let cellmodel = cellmodel else {
            return
        }
        if backId != cellmodel.id {
            let num = cellmodel.id % 4
            imageView.image = UIImage(named: "cell\(num)")
            selectedImageView.image = UIImage(named: "touch\(num)")
            backId = cellmodel.id
        }
        
        //imageView.image = UIImage(named: cellmodel.linkUrl)
        nameLabel.text = cellmodel.name
        goodLabel.text = "\(cellmodel.good)"
    }
    
    override func willDisplay(collectionView: UICollectionView) {
        super.willDisplay(collectionView)
    }
}

