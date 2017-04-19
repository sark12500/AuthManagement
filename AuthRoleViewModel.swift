//
//  AuthRoleViewModel.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/18.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

public class AuthRoleViewModel
{
    // Singelton
    //static let instance = ShiftApiManager()
    class var instance : AuthRoleViewModel {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance  : AuthRoleViewModel? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AuthRoleViewModel()
        }
        return Static.instance!
    }
    
    // MARK:角色列表
    private var roleList:Array<AuthRole> = []
    
    
    public var RoleList:( Array<AuthRole> )
    {
        get{ return roleList }
        set (newVal)
        {
            roleList = newVal
        }
    }
    
    public func Clear()
    {
        roleList.removeAll()
    }
    
    // 取得角色
    public func getRoleListRow(rowIndex:Int) -> AuthRole
    {
        return roleList[rowIndex]
    }
    
    public func getRoleListRow(id:String) -> AuthRole
    {
        for role in roleList where role.id == id {
            return role
        }
        
        return AuthRole()
    }
    
    public func getThisRoleListRow() -> AuthRole
    {
        let id = RoleId
        for role in roleList where role.id == id {
            return role
        }
        
        return AuthRole()
    }
    
    // 取得角色使用者
    public func getRoleUserList(rowIndex:Int) -> Array<AuthRoleUser>
    {
        return roleList[rowIndex].users
    }
    
    public func getRoleUserList(id:String) -> Array<AuthRoleUser>
    {
        for role in roleList where role.id == id {
            return role.users
            
        }
        
        return Array<AuthRoleUser>()
    }
    
    // 取得角色使用者數量
    public func getRoleUserListCount(rowIndex:Int) -> Int
    {
        return getRoleUserList(rowIndex).count
    }
    public func getRoleUserListCount(id:String) -> Int
    {
        return getRoleUserList(id).count
    }
    // 取得角色使用者
    public func getRoleUserListRow(rowIndex:Int,userIndex:Int) -> AuthRoleUser
    {
        return getRoleUserList(rowIndex)[userIndex]
    }
    
    public func getRoleUserListRow(id:String,userIndex:Int) -> AuthRoleUser
    {
        return getRoleUserList(id)[userIndex]
    }
    
    //選取role user count
    public func selectRoleUserCount(id:String) -> Int
    {
        let roleUserList = getRoleUserList(id)
        return roleUserList.filter{ $0.selected == true }.count
    }
    
    // refresh 角色使用者 selected
    public func refreshRoleUserSelected(rowIndex:Int)
    {
        for var user in getRoleUserList(rowIndex){
            user.selected = false
        }
    }
    
    public func refreshRoleUserSelected(id:String)
    {
        for var user in getRoleUserList(id){
            user.selected = true
        }
    }
    
    //選取role user
    public func selectRoleUser(rowIndex:Int,selectedIndex:Int)
    {
        let roleUser = getRoleUserListRow(rowIndex,userIndex: selectedIndex)
        roleUser.selected = true
    }
    
    public func selectRoleUser(id:String,selectedIndex:Int)
    {
        for role in roleList where role.id == id {
            role.users[selectedIndex].selected = true
            break
                //print(role.users[selectedIndex].name)
                //print(role.users[selectedIndex].selected)
            
        }
    }
    
    
    // MARK: 目前所選key
    private var roleId = ""
    private var roleName = ""
    private var description = ""
    private var mappingFunctions = ""
    private var isOwner = false
    
    public var RoleId:(String)
    {
        get{ return roleId }
        set (newVal)
        {
            roleId = newVal
            
            for role in roleList where role.id == roleId {
                roleName = role.name
                description = role.description
                mappingFunctions = role.mappingFunctions
                isOwner = role.isOwner
                break
            }
        }
    }
    
    public var RoleName:(String)
        {
        get{ return roleName }
    }
    
    public var RoleDescription:(String)
        {
        get{ return description }
    }
    
    public var RoleFunction:(String)
        {
        get{ return mappingFunctions }
    }
    public var RoleIsOwner:(Bool)
        {
        get{ return isOwner }
    }
    
    // 角色列表 - 過濾用
    private var filteredUserList:Array<AuthRoleUser> = []
    public var FilteredUserList:( Array<AuthRoleUser> )
    {
        get{ return filteredUserList }
        set (newVal)
        {
            filteredUserList = newVal
        }
    }
    // 取得角色 - 過濾用
    public func getFilteredRoleUserListRow(index:Int) -> AuthRoleUser
    {
        return filteredUserList[index]
    }
}
