//
//  Router.swift
//  IsshoMeshi
//
//  Created by 竹田 光佑 on 2016/09/15.
//  Copyright © 2016年 teame. All rights reserved.
//
import Alamofire

enum Router {
    static let baseURLString = "http://localhost:3000"
    
    case USERS
    case USERS_COUNTER_UPDATE([String:AnyObject]?)
    case USERS_NEW([String:AnyObject]?)
    case USERS_UPDATE([String:AnyObject]?)
    
    
    var request: Request {
        
        let (method, path, parameters) : (Method, String, [String: AnyObject]?) = {
            
            switch self {
            case .USERS:
                return (.GET, "/users.json", nil)
            case .USERS_COUNTER_UPDATE(let params):
                return (.GET, "/users.json", params)
            case .USERS_NEW(let params):
                return (.GET, "/users.json", params)
            case .USERS_UPDATE(let params):
                return (.GET, "/users.json", params)
            }
        }()
        
        return Alamofire.request(method, Router.baseURLString + path, parameters: parameters)
    }
}