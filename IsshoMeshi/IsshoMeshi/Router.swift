//
//  Router.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    
    case USERS
    case USERS_COUNTER_UPDATE([String:AnyObject]?)
    case USERS_NEW([String:AnyObject]?)
    case USERS_UPDATE([String:AnyObject]?)
    
    
    var URLRequest: NSMutableURLRequest {
        
        let (method, path, parameters) : (String, String, [String: AnyObject]?) = {
            
            switch self {
            case .USERS:
                return ("POST", "/users.json", nil)
            case .USERS_COUNTER_UPDATE(let params):
                return ("GET", "/users.json", params)
            case .USERS_NEW(let params):
                return ("GET", "/users.json", params)
            case .USERS_UPDATE(let params):
                return ("GET", "/users.json", params)
            }
        }()
        
        let URL = NSURL(string: Router.baseURLString)
        let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}