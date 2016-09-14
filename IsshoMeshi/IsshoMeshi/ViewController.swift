//
//  ViewController.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/14.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Hakuba
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private lazy var hakuba: Hakuba = Hakuba(tableView: self.tableView)
    
    let friendModels:[FriendCellModel]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        
//        let cellModels = ["タケダ","クボ","ハラダ","コモリ"].map { (title) -> CellModel in
//            let cellmodel = FriendCellModel(title: title, selectionHandler: { cell in
//            })
//            cellmodel.height = 120
//            return cellmodel
//        }
        let friend = FriendCellModel(
            name: "タケダ",
            imageUrl: "http://example.com",
            ienow:  0,
            selectionHandler: { cell in
        })
        friend.height = 120
        self.hakuba.reset(Section().reset(friend).bump())
        retrieveUsers()
    }
    
    func retrieveUsers(){
        Router.USERS.request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                let friendModels = json.map({ (key,json) -> FriendCellModel in
                    let friend = FriendCellModel(
                        name: json["name"].string ?? "タケダ",
                        imageUrl: json["image_url"].string ?? "http://example.com",
                        ienow: json["ienow"].int ?? 0,
                        selectionHandler: { cell in
                    })
                    friend.height = 120
                    return friend
                })
                self.hakuba.sections[0].reset(friendModels).bump()
            case .Failure(let error):
                break
            }
        }
    }


}

