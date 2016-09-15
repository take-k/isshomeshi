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
        self.title = "一緒メシを誘おう！"
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
    
    @IBAction func ienowTapped(sender: AnyObject) {
        guard let model = self.hakuba.sections[0].cellmodels[0] as? FriendCellModel else {
            return
        }
        model.ienow += 1
        model.bump()
        sendIenow()
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
                            guard let model = (cell as? FriendCell)?.cellmodel else{
                                return
                            }
                            GroupManager.sharedInstance.addMemberWithName(model.name, imageUrl: model.imageUrl, ienow: model.ienow)
                        }
                    )
                    friend.height = 120

                    return friend
                })
                self.hakuba.sections[0].reset(friendModels).bump()
                GroupManager.sharedInstance.addGroupView()
            case .Failure(let error):
                break
            }
        }
    }
    
    func sendIenow() {
        guard let model = self.hakuba.sections[0].cellmodels[0] as? FriendCellModel else {
            return
        }
        
        Router.USERS_COUNTER_UPDATE(["ienow":model.ienow]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
            case .Failure(let error):
                break
            }
        }
    }
}

