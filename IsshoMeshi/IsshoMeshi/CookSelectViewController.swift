//
//  CookSelectViewController.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit
import Sapporo
import SwiftyJSON

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
        
        let section = SASection()
        section.inset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        section.minimumLineSpacing = 40
        section.headerViewModel = HeaderViewModel()
        section.footerViewModel = FooterViewModel()
        sapporo.reset(section).bump()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCooks()
    }
    
    func retrieveCooks(){
        guard let groupId = GroupManager.sharedInstance.myGroupId else {
            return
        }

        Router.COOKS(groupId).request.responseJSON { (response) in
            debugPrint(response)
            switch (response.result) {
            case .Success(let value):
                let json = JSON(value)
                let models = json.map({ (key,json) -> CookCellModel in
                    let id = json["id"].int ?? 0
                    return CookCellModel(name: json["name"].string ?? "鍋",
                        id: json["id"].int ?? 0,
                        linkUrl: "cell\(id % 4)",
                        good: json["good"].int ?? 0,
                        selectionHandler: { (cell) in
                            guard let model = (cell as? CookCell)?.cellmodel else {
                                return
                            }
                            model.good += 1
                            model.bump()
                            
                            self.updateButton()
                    })
                })
                self.sapporo.sections[0].reset(models).bump()
            case .Failure(let error):
                break
            }
        }
    }
    func updateButton() {
        let model = sapporo.sections[0].cellmodels.maxElement { (cella, cellb) -> Bool in
            guard let cella = cella as? CookCellModel ,cellb = cellb as? CookCellModel else {
                return false
            }
            return cella.good > cellb.good
        }
        guard let cmodel = model as? CookCellModel else {
            return
        }
        //cookButton.titleLabel?.text = cmodel.name + "を作る"
        
    }
    
    @IBAction func addCookTapped(sender: AnyObject) {
    }
    
    @IBAction func cookTapped(sender: AnyObject) {
        
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

    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var addCookButton: UIButton!
    override func configure() {
        super.configure()
        
        guard let viewmodel = viewmodel else {
            return
        }
    }
}

class FooterViewModel:SAFlowLayoutSupplementaryViewModel {
    init (){
        super.init(viewType: FooterView.self,size:CGSize(width: width, height: 90 ))
    }
}

class FooterView:SAFlowLayoutSupplementaryView,SAFlowLayoutSupplementaryViewType {
    typealias ViewModel = FooterViewModel
    
    @IBOutlet weak var cookButton: UIButton!
    override func configure() {
        super.configure()
        
        guard let viewmodel = viewmodel else {
            return
        }
    }
}
