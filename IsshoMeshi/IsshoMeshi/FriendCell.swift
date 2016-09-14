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
    let name :String
    let imageUrl:String
    var ienow:Int

    init(name: String,imageUrl:String,ienow:Int, selectionHandler: SelectionHandler) {
        self.name = name
        self.imageUrl = imageUrl
        self.ienow = ienow
        super.init(cell: FriendCell.self, selectionHandler: selectionHandler)
    }
}

class FriendCell: Cell,CellType {
    typealias CellModel = FriendCellModel
    
    @IBOutlet weak var ienowButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func configure() {
        guard let cellmodel = cellmodel else {
            return
        }
        nameLabel.text = cellmodel.name
        ienowButton.setTitle("\(cellmodel.ienow)", forState: .Normal)
        if let url = NSURL(string: cellmodel.imageUrl) {
            userImageView.af_setImageWithURL(url)
        }
        
    }
    
    override func willDisplay(tableView: UITableView) {
        super.willDisplay(tableView)
        
    }
}
