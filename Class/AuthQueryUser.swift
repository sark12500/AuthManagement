//
//  AuthQueryUser.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import Foundation

public class AuthQueryUser
{
    public var id = ""
    public var name = ""
    public var memberType = AuthMemberType.User
    public var selected = false
    public var email = ""
    
    init(){}
    
    init(json:JSON){
        set(json)
    }
    
    public func set(json:JSON){
        if let id = json["Id"].string {
            self.id = id
        }
        if let name = json["Name"].string {
            self.name = name
        }
        if let selected = json["IsSelected"].bool {
            self.selected = selected
        }
        if let email = json["Email"].string {
            self.email = email
        }
        
        if let setting = json["TypeIndex"].int {
            switch setting {
            case 1:
                memberType = AuthMemberType.Dept
                break
            case 2:
                memberType = AuthMemberType.Company
                break
            default:
                memberType = AuthMemberType.User
                break
                
            }
        }
        
        
    }
}
