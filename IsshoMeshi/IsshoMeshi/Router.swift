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
    case USERS_COUNTER_UPDATE(Int,[String:AnyObject]?)
    case USERS_NEW([String:AnyObject]?)
    case USERS_UPDATE(Int,[String:AnyObject]?)
    
    case GROUPS_NEW([String:AnyObject]?)
    
    case USERGROUPS
    case USERGROUPS_NEW([String:AnyObject]?)
    case USERGROUPS_DELETE(Int,([String:AnyObject]?))
    
    case COOKS(Int)
    case COOKS_NEW([String:AnyObject]?)
    case COOKS_UPDATE(Int,[String:AnyObject]?)
    
    var request: Request {
        
        let (method, path, parameters) : (Method, String, [String: AnyObject]?) = {
            
            switch self {
            case .USERS:
                return (.GET, "/users.json", nil)
            case .USERS_COUNTER_UPDATE(let id,let params):
                return (.PUT, "/users/\(id).json", params)
            case .USERS_NEW(let params):
                return (.POST, "/users.json", params)
            case .USERS_UPDATE(let id,let params):
                return (.GET, "/users/\(id).json", params)
                
            case .GROUPS_NEW(let params):
                return (.POST, "/groups.json",params)
                
            case .COOKS(let groupId):
                return (.GET, "/cooks.json?group_id=\(groupId)", nil)
            case .COOKS_NEW(let params):
                return (.POST, "/groups.json", params)
            default:
                return (.GET, "/users/", nil)
            }
        }()
        
        return Alamofire.request(method, Router.baseURLString + path, parameters: parameters,encoding: .JSON)
    }
}