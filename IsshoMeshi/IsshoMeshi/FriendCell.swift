//
//  FriendCell.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Hakuba
import AlamofireImage

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
        super.init(cell: FriendCell.self, selectionHandler: selectionHandler)
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
//        badgeView.hidden = cellmodel.ienow == 0
        if let url = NSURL(string: cellmodel.imageUrl) {
            userImageView.af_setImageWithURL(url)
        }
        userImageView.layer.cornerRadius = 25
        
    }
    
    override func willDisplay(tableView: UITableView) {
        super.willDisplay(tableView)
        
    }
}
