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
    
    var memberModels:[MemberCellModel] = []
    let collectionView :UICollectionView
    let nextButton: UIButton
    let label: UILabel
    
    var myId:Int = 1
    var myGroupId:Int?
    
    var viewController:ViewController? = nil
    
    private init() {
        let layout = SAFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(50, 50)
        let width = UIApplication.sharedApplication().keyWindow?.frame.width ?? 100
        let frame = CGRectMake(0, 64, width, 80)
        
        collectionView = UICollectionView(frame: frame,collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.myLightGreen()

        nextButton = UIButton(type: .Custom)
        nextButton.frame = CGRectMake(frame.width - 90 , 64, 90, 80)
        nextButton.backgroundColor = UIColor.myLightGreen()
        nextButton.setImage(UIImage(named: "navi"), forState: .Normal)
        nextButton.hidden = true
        
        label = UILabel(frame: CGRectMake(10,frame.minY,frame.width-20,frame.height))
        label.text = "今日のメンバー"
        label.textColor = UIColor.myGray()
        label.font = UIFont.boldSystemFontOfSize(20)
        
        sapporo.registerCellByNib(MemberCell)
        sapporo.setLayout(layout)
        
        let section = SASection()
        section.reset([]).bump()
        sapporo.reset(section).bump()
        
    }
    
    func addGroupView() {
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        window.addSubview(collectionView)
        window.addSubview(nextButton)
        window.addSubview(label)
        nextButton.addTarget(viewController, action: #selector(ViewController.nextTapped(_:)), forControlEvents: .TouchUpInside)

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
        
        let member = MemberCellModel(name: name,id:id, imageUrl: imageUrl,ienow: ienow, selectionHandler: { cell in })
        
        section.append(member).bump()
        
        if section.itemsCount > 0 {
            label.hidden = true
            nextButton.hidden = false
        }
    }
    
    func hideNextButton(){
        nextButton.hidden = true
    }
}
