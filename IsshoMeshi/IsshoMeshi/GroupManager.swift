//
//  GroupManager.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Sapporo

class GroupManager {
    static let sharedInstance = GroupManager()
    lazy var sapporo: Sapporo = Sapporo(collectionView: self.collectionView)
    
    let collectionView :UICollectionView
    let nextButton: UIButton
    let label: UILabel
    
    static let defaults = NSUserDefaults.standardUserDefaults()

    static var userId:Int {
        get {
            defaults.registerDefaults(["userId":0])
            return defaults.integerForKey("userId")
        }
        set {
            defaults.setInteger(newValue, forKey: "userId")
            defaults.synchronize()
        }
    }
    
    static var userName:String {
        get {
            defaults.registerDefaults(["userName":""])
            return defaults.stringForKey("userName") ?? ""
        }
        set {
            defaults.setObject(newValue, forKey: "userName")
            defaults.synchronize()
        }
    }
    
    var _myGroupId:Int? = nil
    var myGroupId:Int? {
        get {
            return 1
        }
        set {
            _myGroupId = newValue
        }
    }
    
    var viewController:ViewController? = nil
    
    private init() {
        let layout = SAFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(50, 50)
        let width = UIApplication.sharedApplication().keyWindow?.frame.width ?? 100
        let frame = CGRectMake(0, 64, width, 80)
        
        collectionView = UICollectionView(frame: frame,collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.myLightGreen()

        nextButton = UIButton(type: .System)
        nextButton.frame = CGRectMake(frame.width - 90 , 64, 90, 80)
        nextButton.backgroundColor = UIColor.myLightGreen().colorWithAlphaComponent(0.8)
        //nextButton.setImage(UIImage(named: "navi"), forState: .Normal)
        nextButton.tintColor = UIColor.myDeepGreen()
        
        label = UILabel(frame: CGRectMake(10,frame.minY,frame.width-20,frame.height))
        label.text = "今日のメンバー"
        label.textColor = UIColor.myGray()
        label.font = UIFont.boldSystemFontOfSize(20)
        
        sapporo.registerCellByNib(MemberCell)
        sapporo.setLayout(layout)
        
        let section = SASection()
        section.reset([]).bump()
        sapporo.reset(section).bump()
        
        updateViews()
    }
    
    func addGroupView() {
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        window.addSubview(collectionView)
        window.addSubview(nextButton)
        window.addSubview(label)
        guard let viewController = viewController else {
            return
        }
        nextButton.addTarget(viewController, action: #selector(ViewController.notifTapped(_:)), forControlEvents: .TouchUpInside)

    }
    
    func addMemberWithName(name:String,id :Int, imageUrl:String, ienow:Int) {
        guard let section = sapporo.sections.first else {
            return
        }
        let index = section.cellmodels.indexOf { (model) -> Bool in
            guard let model = model as? MemberCellModel else {
                return false
            }
            return model.id == id
        }
        if index != nil {return}
        
        let member = MemberCellModel(name: name,id:id, imageUrl: imageUrl,ienow: ienow, selectionHandler: { cell in
            guard let model = (cell as? MemberCell)?.cellmodel else {
                return
            }
            section.remove(model).bump()
            self.updateViews()
        })
        section.append(member).bump()
        updateViews()
    }
    
    func updateViews (){
        guard let section = sapporo.sections.first else {
            label.hidden = false
            nextButton.hidden = true
            return
        }
        if section.itemsCount > 0 {
            label.hidden = true
            nextButton.hidden = false
        }else {
            label.hidden = false
            nextButton.hidden = true
        }
        enableButton()
    }
    
    func hideNextButton(){
        nextButton.hidden = true
    }
    func showNextButton(){
        nextButton.hidden = false
    }
    func enableButton(){
        nextButton.enabled = true
        nextButton.setTitle("通知を送る", forState: .Normal)
    }
    
    func disableButton() {
        nextButton.enabled = false
        nextButton.setTitle("送信済み", forState: .Normal)
    }
}
