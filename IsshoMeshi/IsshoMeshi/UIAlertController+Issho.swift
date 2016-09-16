//
//  File.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/16.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func textAlert(title:String,message:String,placeholder:String,cancel:String?,ok:String,handler:((UIAlertAction,UIAlertController) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = placeholder
        }
        if let cancel = cancel {
            alert.addAction(UIAlertAction(title: cancel, style: .Cancel, handler: nil))
        }
        
        alert.addAction(UIAlertAction(title: ok, style: .Default, handler: {(action) in
            if let handler = handler {
                handler(action,alert)
            }
        }))
        return alert
    }
    
    class func alert(title:String,message:String,cancel:String,ok:String,handler:((UIAlertAction) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: cancel, style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: ok, style: .Default, handler: handler))
        return alert
    }
}