//
//  AuthInfoViewModel.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/18.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

public class AuthInfoViewModel
{
    // Singelton
    //static let instance = ShiftApiManager()
    class var instance : AuthInfoViewModel {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance  : AuthInfoViewModel? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AuthInfoViewModel()
        }
        return Static.instance!
    }
    
    // MARK:角色列表
    private var infoList:Array<AuthInfo> = []
    
    
    public var InfoList:( Array<AuthInfo> )
        {
        get{ return infoList }
        set (newVal)
        {
            infoList = newVal
        }
    }
    
    public func Clear()
    {
        infoList.removeAll()
    }
    
    // 設定角色
    public func setInfo(count:String, duringTime:String )
    {
        infoList[0].subTitle = NSLocalizedString("AuthInfoLicenseCount",comment:"") + " : " + count
        infoList[1].subTitle = duringTime
    }
    
    // 取得角色
    public func getInfoListRow(rowIndex:Int) -> AuthInfo
    {
        return infoList[rowIndex]
    }
    
    public func getInfoListRow(title:String) -> AuthInfo
    {
        for info in infoList where info.title == title  {
            return info
        }
        
        return AuthInfo()
    }
    
}
