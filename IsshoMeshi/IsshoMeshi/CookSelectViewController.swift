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
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(update(_:)), userInfo: nil, repeats: true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCooks()
    }
    
    func update(sender:NSTimer){
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
                            
                            Router.COOKS_UPDATE(model.id, ["good":model.good]).request.responseJSON(completionHandler: { (response) in
                                debugPrint(response)
                                switch (response.result) {
                                case .Success(_):
                                    break
                                case .Failure(_):
                                    break
                                }
                            })
                            
                            self.updateButton()
                    })
                })
                self.sapporo.sections[0].reset(models).bump()
            case .Failure(_):
                break
            }
        }
    }
    
    
    func updateButton() {
        let model = sapporo.sections[0].cellmodels.maxElement { (cella, cellb) -> Bool in
            guard let cella = cella as? CookCellModel ,cellb = cellb as? CookCellModel else {
                return false
            }
            return cella.good < cellb.good
        }
        guard let cmodel = model as? CookCellModel else {
            return
        }
        guard let footer = sapporo.sections[0].footerViewModel as? FooterViewModel else {
            return
        }
        footer.name = cmodel.name
        sapporo.sections[0].footerViewModel = footer
    }
    
    func createCook (name:String){
        guard let groupId = GroupManager.sharedInstance.myGroupId else {
            return
        }
        Router.COOKS_NEW(["name":name,"group_id":groupId]).request.responseJSON { (response) in
            debugPrint(response)
            switch response.result {
            case .Success(_):
                self.retrieveCooks()
                
            case .Failure(_):
                break
            }
        }
    }

    
    @IBAction func addCookTapped(sender: AnyObject) {
        let alert = UIAlertController.textAlert("メニューの追加", message: "作りたい料理を記入してね", placeholder: "メニュー", cancel: "キャンセル", ok: "追加") { (action,alertController) in
            guard let field = alertController.textFields?.first else {
                return
            }
            self.createCook(field.text!)
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func cookTapped(sender: AnyObject) {
        let model = sapporo.sections[0].cellmodels.maxElement { (cella, cellb) -> Bool in
            guard let cella = cella as? CookCellModel ,cellb = cellb as? CookCellModel else {
                return false
            }
            return cella.good < cellb.good
        }
        guard let cmodel = model as? CookCellModel else {
            return
        }
        
        let alert = UIAlertController.alert("今日の一緒メシは\n\"\(cmodel.name)\"\nに決定！", message: "レシピを選んで早速作ってみよう", cancel: "キャンセル", ok: "レシピを調べる") { (action) in
            guard let encodedBody = cmodel.name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) ,url = NSURL(string: "http://cookpad.com/search/\(encodedBody)") else {
                let alert = UIAlertController.alert("レシピを探せません。", message: "正しい料理名を入力してください", cancel: nil, ok: "OK", handler: nil)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            if UIApplication.sharedApplication().canOpenURL(url){
                UIApplication.sharedApplication().openURL(url)
            }
        }
        self.presentViewController(alert, animated: true, completion: nil)


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
    var name:String = "〜〜"
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
