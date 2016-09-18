//
//  UIColor+MyColor.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func hexStr (hexStr : NSString, alpha : CGFloat) -> UIColor {
        let hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
    
    class func myBlack() -> UIColor{
        return UIColor.hexStr("2b2b2b", alpha: 1.0)
    }
    class func myRed() -> UIColor{
        return UIColor.hexStr("c20114", alpha: 1.0)
    }
    class func myGreen() -> UIColor{
        return UIColor.hexStr("82ae46", alpha: 1.0)
    }
    class func myWhite() -> UIColor{
        return UIColor.hexStr("f2f2ea", alpha: 1.0)
    }
    class func myLightGreen() -> UIColor{
        return UIColor.hexStr("a6c47c", alpha: 1.0)
    }
    class func myGray() -> UIColor{
        return UIColor(red: 0.39, green: 0.43, blue: 0.35, alpha: 1.0)
    }
}
