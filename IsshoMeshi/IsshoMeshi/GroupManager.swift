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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(50, 50)
        collectionView = UICollectionView(frame: CGRectMake(0, 44, 350, 80) , collectionViewLayout:layout)
        let friend = FriendCellModel(name: "タケダ", imageUrl: "", ienow: 4) { (cell) in
            
        }
        let section = SASection()
    }
    
    var memberModels:[FriendCellModel] = []
    let collectionView :UICollectionView
    
    
}
