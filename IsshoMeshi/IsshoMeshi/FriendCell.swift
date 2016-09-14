//
//  FriendCell.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Hakuba

class FriendCellModel: CellModel {
    let title: String
    
    init(title: String, selectionHandler: SelectionHandler) {
        self.title = title
        super.init(cell: FriendCell.self, selectionHandler: selectionHandler)
    }
}

class FriendCell: Cell,CellType {
    typealias CellModel = FriendCellModel
    
    @IBOutlet weak var titleLabel: Label!
    
    override func configure() {
        guard let cellmodel = cellmodel else {
            return
        }
        
        titleLabel.text = cellmodel.title + "(\(cellmodel.indexPath.section),\(cellmodel.indexPath.row))"
    }
    
    override func willDisplay(tableView: UITableView) {
        super.willDisplay(tableView)
        
    }
}
