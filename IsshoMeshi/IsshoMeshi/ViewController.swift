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
//
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private lazy var hakuba: Hakuba = Hakuba(tableView: self.tableView)
    
    let friendModels:[FriendCellModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addfriend"), style: .Done, target: self, action: #selector(addUserTapped(_:)))
        self.hakuba.reset(Section().reset([]).bump())
        retrieveUsers()
        GroupManager.sharedInstance.viewController = self
        GroupManager.sharedInstance.addGroupView()
    }
    
    func addUserTapped (sendor :UIButton){
        
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
                        id : json["id"].int ?? 0,
                        name: json["name"].string ?? "タケダ",
                        imageUrl: json["image_url"].string ?? "http://example.com",
                        ienow: json["ienow"].int ?? 0,
                        selectionHandler: { cell in
                            if let indexPath = self.tableView.indexPathForCell(cell) {
                                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                            }
                            guard let model = (cell as? FriendCell)?.cellmodel else{
                                return
                            }
                            GroupManager.sharedInstance.addMemberWithName(model.name,id:model.id, imageUrl: model.imageUrl, ienow: model.ienow)
                        }
                    )
                    friend.height = 60

                    return friend
                })
                self.hakuba.sections[0].reset(friendModels).bump()
            case .Failure(let error):
                break
            }
        }
    }
    
    func sendIenow() {
        guard let model = self.hakuba.sections[0].cellmodels[0] as? FriendCellModel else {
            return
        }
//        guard let GroupManager.sharedInstance.myId
        Router.USERS_COUNTER_UPDATE(GroupManager.sharedInstance.myId,["ienow":model.ienow]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
            case .Failure(let error):
                break
            }
        }
    }
    
    func sendMembers() {

    }
    
    func nextTapped(sender:UIButton){
        let manager = GroupManager.sharedInstance
        let models = manager.sapporo.sections[0].cellmodels
        let params = ["name":manager.myId,"date":"2011-01-01","location":"どこか",
                      "user_ids":models.map({ (model) -> Int in
                        return (model as! MemberCellModel).id
                      })]
        Router.GROUPS_NEW(params as! [String : AnyObject]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                manager.myGroupId = json["id"].int
                manager.hideNextButton()
                self.performSegueWithIdentifier("showCookSelect", sender: sender)
            case .Failure(let error):
                break
            }
        }    }

}

