//
//  FriendCell.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Hakuba
import Kingfisher

class FriendCellModel: CellModel {
    let id:Int
    let name :String
    let imageUrl:String
    var ienow:Int

    init(id:Int, name: String,imageUrl:String,ienow:Int, selectionHandler: SelectionHandler) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.ienow = ienow
        super.init(cell: FriendCell.self,height:60, selectionHandler: selectionHandler)
    }
}

class FriendCell: Cell,CellType {
    typealias CellModel = FriendCellModel
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    @IBOutlet weak var badgeView: UIView!
    override func configure() {
        guard let cellmodel = cellmodel else {
            return
        }
        
        nameLabel.text = cellmodel.name
        
        badgeLabel.text = "\(cellmodel.ienow)"
        //badgeView.hidden = cellmodel.ienow == 0
        var scaled:CGFloat = 0.5 + CGFloat(cellmodel.ienow) * 0.01
        scaled = scaled < 1.2 ? scaled : 1.2
        badgeView.transform = CGAffineTransformMakeScale(scaled, scaled)
        
        if let url = NSURL(string: cellmodel.imageUrl) {
            userImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "men"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        userImageView.layer.cornerRadius = 25
        
    }
}
