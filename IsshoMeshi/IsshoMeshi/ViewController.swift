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
        //self.checkLogin()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "addfriend"), style: .Done, target: self, action: #selector(addUserTapped(_:)))
        self.hakuba.reset(Section().reset([]).bump())
        retrieveUsers()
        GroupManager.sharedInstance.viewController = self
        GroupManager.sharedInstance.addGroupView()
        tableView.contentInset.top = -60
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(update(_:)), userInfo: nil, repeats: true)
        
    }
    
    func update(sender:NSTimer){
        retrieveUsers()
    }
    
    let myIdKey = "myId"
    func checkLogin (){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let myId = defaults.integerForKey(myIdKey)
        let manager = GroupManager.sharedInstance
        if  myId == 0 || manager.myId == 0{
            let alert = UIAlertController.textAlert("登録", message: "ユーザー名を入力してください", placeholder: "ユーザー名", cancel: nil, ok: "一緒メシに登録") { (action,al) in
                let field = al.textFields![0] as UITextField
                self.createUser(field.text!)
            }
            self.presentViewController(alert, animated: true, completion: nil)
        }
        manager.myId = myId
    }
    
    func addUserTapped (sendor :UIButton){
        
        let alert = UIAlertController.textAlert("友だち追加", message: "友達の名前を入力してね", placeholder: "ユーザー名", cancel: "キャンセル", ok: "追加") { (action,al) in
            let field = al.textFields![0] as UITextField
            self.createUser(field.text!)
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createUser (name:String){

        Router.USERS_NEW(["name":name]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                //manager.myGroupId = json["id"].int
                
                let defaults = NSUserDefaults.standardUserDefaults()
                if defaults.integerForKey(self.myIdKey) == 0 {
                    let id = json["id"].int ?? 0
                    defaults.setInteger(id , forKey: self.myIdKey)
                    defaults.synchronize()
                    GroupManager.sharedInstance.myId = id
                }
                
                self.retrieveUsers()
                
            case .Failure(let error):
                break
            }
        }
    }
    
    @IBAction func ienowTapped(sender: AnyObject) {
        guard let model = self.hakuba.sections[0].cellmodels[0] as? FriendCellModel else {
            return
        }
        self.hakuba.sections[0].cellmodels.forEach { (model) in
            if let model = model as? FriendCellModel {
                if model.id == GroupManager.sharedInstance.myId {
                    model.ienow += 1
                    model.bump()
                    sendIenow(model.ienow)
                }
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
    
    func sendIenow(num:Int) {
        Router.USERS_COUNTER_UPDATE(GroupManager.sharedInstance.myId,["ienow":num]).request.responseJSON { (response) in
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
        }
    }
}

