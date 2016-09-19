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
        self.checkLogin()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addfriend"), style: .Done, target: self, action: #selector(addUserTapped(_:)))
        self.hakuba.reset(Section().reset([]).bump())
        retrieveUsers()
        GroupManager.sharedInstance.viewController = self
        GroupManager.sharedInstance.addGroupView()
        tableView.contentInset.top = -60
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(update(_:)), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let section = GroupManager.sharedInstance.sapporo.sections.first else {
            return
        }
        if section.itemsCount > 0 {
            GroupManager.sharedInstance.showNextButton()
        }
    }
    
    func update(sender:NSTimer){
        retrieveUsers()
    }
    
    func checkLogin (){
        if  GroupManager.userId == 0{
            let alert = UIAlertController.textAlert("ログイン・登録", message: "ユーザー名を入力してください", placeholder: "ユーザー名", cancel: nil, ok: "ログイン・登録") { (action,al) in
                let field = al.textFields![0] as UITextField
                self.createUser(field.text!)
            }
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func addUserTapped (sendor :UIButton){
        
        let alert = UIAlertController.textAlert("友だち追加", message: "友達の名前を入力してね", placeholder: "ユーザー名", cancel: "キャンセル", ok: "追加") { (action,al) in
            let field = al.textFields![0] as UITextField
            self.createUser(field.text!)
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createUser (name:String){

        Router.USERS_NEW(["name":name,"ienow":0]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                //manager.myGroupId = json["id"].int
                
                if GroupManager.userId == 0 {
                    GroupManager.userId = json["id"].int ?? 0
                }
                
                self.retrieveUsers()
                
            case .Failure(_):
                break
            }
        }
    }
    
    @IBAction func ienowTapped(sender: AnyObject) {
        self.hakuba.sections[0].cellmodels.forEach { (model) in
            guard let model = model as? FriendCellModel else {
                return
            }
            if model.id == GroupManager.userId {
                model.ienow += 1
                model.bump()
                sendIenow(model.ienow)
            }
        }
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
                        name: json["name"].string ?? "不明",
                        imageUrl: json["image_url"].string ?? "",
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
            case .Failure(_):
                break
            }
        }
    }
    
    func sendIenow(num:Int) {
        Router.USERS_COUNTER_UPDATE(GroupManager.userId,["ienow":num]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(_):
                break
            case .Failure(_):
                break
            }
        }
    }
    
    func sendMembers() {

    }
    
    func nextTapped(sender:UIButton){
        let manager = GroupManager.sharedInstance
        let models = manager.sapporo.sections[0].cellmodels
        let params = ["name":GroupManager.userId,"date":"2011-01-01","location":"どこか",
                      "user_ids":models.map({ (model) -> Int in
                        return (model as! MemberCellModel).id
                      })]
        Router.GROUPS_NEW(params as? [String : AnyObject]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                manager.myGroupId = json["id"].int
                manager.hideNextButton()
                self.performSegueWithIdentifier("showCookSelect", sender: sender)
            case .Failure(_):
                break
            }
        }
    }
}

