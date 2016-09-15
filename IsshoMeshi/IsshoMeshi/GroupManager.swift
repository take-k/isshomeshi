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
    private lazy var sapporo: Sapporo = Sapporo(collectionView: self.collectionView)
    
    private init() {
        let layout = SAFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(50, 50)
        let width = UIApplication.sharedApplication().keyWindow?.frame.width ?? 100
        collectionView = UICollectionView(frame: CGRectMake(0, 65, width, 80),collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.blackColor()
        sapporo.registerCellByNib(MemberCell)
        sapporo.setLayout(layout)
        
        let member = MemberCellModel(name: "タケダ", imageUrl: "",ienow: 0) { (cell) in
        }
        
        let section = SASection()
        section.reset([member,member,member,member,member]).bump()
        sapporo.reset(section).bump()
        
        
    }
    
    var memberModels:[MemberCellModel] = []
    let collectionView :UICollectionView

    func addGroupView() {
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        window.addSubview(collectionView)
    }
    
    func addMemberWithName(name:String, imageUrl:String, ienow:Int) {
        let member = MemberCellModel(name: name, imageUrl: imageUrl,ienow: ienow, selectionHandler: { cell in })
        sapporo.sections[0].append(member).bump()
        //memberModels.append(member)
        
    }
}
