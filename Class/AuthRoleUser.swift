//
//  AuthRoleUser.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import Foundation

public class AuthRoleUser
{
    public var id = ""
    public var name = ""
    public var roleId = ""
    public var solutionName = ""
    public var memberType = AuthMemberType.User
    public var selected = false
    public var mappingId = ""
    public var email = ""
    
    init(){}
    
    init(json:JSON){
        set(json)
    }
    
    public func set(json:JSON){
        if let id = json["UserId"].string {
            self.id = id
        }
        if let name = json["UserInfo"].string {
            self.name = name
        }
        if let mappingId = json["MappingId"].int {
            self.mappingId = "\(mappingId)"
        }
        if let email = json["Email"].string {
            self.email = email
        }

        if let setting = json["Setting"].string {
            switch setting {
            case "DeptId":
                memberType = AuthMemberType.Dept
                break
            case "CompanyId":
                memberType = AuthMemberType.Company
                break
            default:
                memberType = AuthMemberType.User
                break

            }
        }
        
        
    }
}
