//
//  CookSelectViewController.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Sapporo

class CookSelectViewController: UIViewController ,SapporoDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var sapporo: Sapporo = Sapporo(collectionView: self.collectionView)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))

        let layout = SAFlowLayout()
        layout.scrollDirection = .Vertical
        layout.itemSize = CGSizeMake( 100, 70)
        sapporo.setLayout(layout)
        
        
        let models = (1...9).map { num in
            return CookCellModel(name: "餃子", linkUrl: "cell\(num % 4)", good: 1) { (cell) in
                guard let cook = (cell as? CookCell)?.cellmodel else {
                    return
                }
                cook.good += 1
                cook.bump()
            }
        }
        
        let section = SASection()
        section.inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        section.minimumLineSpacing = 40
        section.headerViewModel = HeaderViewModel()
        section.footerViewModel = FooterViewModel()
        
        section.reset(models)
        sapporo.reset(section).bump()
    }
}

let width = UIApplication.sharedApplication().keyWindow?.frame.width ?? 380

class HeaderViewModel:SAFlowLayoutSupplementaryViewModel {
    init (){
        super.init(viewType: HeaderView.self,size:CGSize(width: width, height: 160 ))
    }
}

class HeaderView:SAFlowLayoutSupplementaryView,SAFlowLayoutSupplementaryViewType {
    typealias ViewModel = HeaderViewModel

    override func configure() {
        super.configure()
        
        guard let viewmodel = viewmodel else {
            return
        }
    }
}

class FooterViewModel:SAFlowLayoutSupplementaryViewModel {
    init (){
        super.init(viewType: FooterView.self,size:CGSize(width: width, height: 160 ))
    }
}

class FooterView:SAFlowLayoutSupplementaryView,SAFlowLayoutSupplementaryViewType {
    typealias ViewModel = FooterViewModel
    
    override func configure() {
        super.configure()
        
        guard let viewmodel = viewmodel else {
            return
        }
    }
}
