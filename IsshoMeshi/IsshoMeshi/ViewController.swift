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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkLogin()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navi"), style: .Done, target: self, action: #selector(pushCookTapped(_:)))
        self.hakuba.reset(Section().reset([]).bump())
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
        retrieveUsers()
        retrieveNotifications()
    }
    
    func update(sender:NSTimer){
        retrieveUsers()
        retrieveNotifications()
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
                    GroupManager.userName = json["name"].string ?? ""
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
    
    func retrieveNotifications(){
        Router.NOTIFICATIONS(GroupManager.userId).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                json.forEach({ (key,json) in
                    let alert = UIAlertController.alert(
                        json["title"].string ?? "一緒メシの誘いが来ました",
                        message: json["message"].string ?? "一緒メシの誘いが来ました",
                        cancel: nil, ok: "OK", handler: { (action) in
                            guard let notifId = json["id"].int else {
                                return
                            }
                            Router.NOTIFICATIONS_DELETE(notifId).request.responseJSON(completionHandler: { (response) in
                                debugPrint(response)
                                switch response.result {
                                case .Success(let value):
                                    break
                                case .Failure(_):
                                    break
                                }
                            })
                    })
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                break
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
    
 
    func pushCookTapped(sender:UIButton) {
        self.performSegueWithIdentifier("showCookSelect", sender: sender)
    }
    
    func notifTapped(sender:UIButton){
        let alert = UIAlertController.alert("一緒メシに誘う", message: "選択したメンバーを一緒メシに誘いますか？メンバーに通知が送られます。", cancel: "いいえ", ok: "はい") { (action) in
            let manager = GroupManager.sharedInstance
            let models = manager.sapporo.sections[0].cellmodels

            manager.disableButton()

            models.forEach({ (model) in
                guard let receiverModel = model as? MemberCellModel else {
                    return
                }
                let params:[String:AnyObject] = [
                    "title":"一緒メシの誘いが来ました",
                    "message":"\(GroupManager.userName)から一緒メシの誘いが来ました。",
                    "sender_id":GroupManager.userId,
                    "receiver_id":receiverModel.id,
                    "sender_name":GroupManager.userName,
                    "receiver_name":receiverModel.name
                ]
                
                Router.NOTIFICATIONS_NEW(params).request.responseJSON(completionHandler: { (response) in
                    debugPrint(response)
                    switch response.result {
                    case .Success(let value):
                        let ok = UIAlertController.alert("送信完了", message: "一緒メシの誘いました。メンバーがアプリ起動時に通知が表示されます。", cancel: nil, ok: "OK",handler: nil)
                        self.presentViewController(ok, animated: true, completion: nil)
                        break
                    case .Failure(_):
                        break
                    }
                })
                
            })
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    var isSendingGroup = false
    func nextTapped(sender:UIButton){
        if isSendingGroup {
            return
        }
        let manager = GroupManager.sharedInstance
        let models = manager.sapporo.sections[0].cellmodels
        let params = ["name":GroupManager.userId,"date":"2011-01-01","location":"どこか",
                      "user_ids":models.map({ (model) -> Int in
                        return (model as! MemberCellModel).id
                      })]
        isSendingGroup = true
        Router.GROUPS_NEW(params as? [String : AnyObject]).request.responseJSON { (response) in
            debugPrint(response)
            self.isSendingGroup = false
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

