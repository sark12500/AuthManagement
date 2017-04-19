//
//  AuthRole.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import Foundation

public class AuthRole
{
    public var id = ""
    public var name = ""
    public var description = ""
    public var mappingFunctions = ""
    public var isOwner = false
    public var hasMore = false
    public var nowCount = 0
    public var totalCount = 0
    public var users = [AuthRoleUser]()
    
    init(){}
    
    init(json:JSON){
        set(json)
    }
    
    public func set(json:JSON){
        if let id = json["RoleId"].string {
            self.id = id
        }
        if let name = json["RoleName"].string {
            self.name = name
        }
        if let description = json["RoleDescription"].string {
            self.description = description
        }
        if let mappingFunctions = json["MappingFunctions"].string {
            self.mappingFunctions = mappingFunctions
        }
        if let isOwner = json["IsOwner"].bool {
            self.isOwner = isOwner
        }
        if let hasMore = json["HasMore"].bool {
            self.hasMore = hasMore
        }
        if let nowCount = json["NowCount"].int {
            self.nowCount = nowCount
        }
        if let totalCount = json["TotalCount"].int {
            self.totalCount = totalCount
        }
        
        let users = json["Models"].arrayValue
        for subJson:JSON in users {
            self.users.append(AuthRoleUser(json: subJson))
        }
        
    }
}