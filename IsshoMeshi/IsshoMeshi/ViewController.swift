//
//  ViewController.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/14.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Hakuba


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private lazy var hakuba: Hakuba = Hakuba(tableView: self.tableView)
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellModels = ["タケダ","クボ","ハラダ","コモリ"].map { (title) -> CellModel in
            return FriendCellModel(title: "ほげ", selectionHandler: { cell in
            })
        }
        self.hakuba.reset(Section().reset(cellModels).bump()).bump()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

