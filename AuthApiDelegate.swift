//
//  AuthApiDelegate.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//
import Foundation
import UIKit

//@objc: 使用方式將其轉為 ASCII 才能在 Objective-C 裡呼叫
@objc public protocol AuthApiDelegate {
    
    optional func getProductSuccess( data:AnyObject )
    optional func getProductFail( data:String )
    
    optional func getRoleSuccess( data:AnyObject )
    optional func getRoleFail( data:String )
    
    optional func getMemberSuccess( data:AnyObject )
    optional func getMemberFail( data:String )
    
    optional func addMemberSuccess( data:AnyObject )
    optional func addMemberFail( data:String )
    
    optional func deleteMemberSuccess( data:AnyObject )
    optional func deleteMemberFail( data:String )
    
    optional func getDepartmentNextLevelSuccess( data:AnyObject )
    optional func getDepartmentNextLevelFail( data:String )
    
    optional func getOneRoleOthersByIdSuccess( data:AnyObject )
    optional func getOneRoleOthersByIdFail( data:String )
}

//demo protocol extension
extension AuthApiDelegate {
    func ApiExtend() -> String {
        return "demo ApiExtend"
    }
}

