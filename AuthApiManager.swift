//
//  AuthApiManager.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/5/3.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import UIKit

enum ApiType: Int {
    case Release,Test
}

protocol ApiCommand {
    func execute()
}

//MARK: Command pattern
public class AuthApiManager
{
    
    private var getProductCommand: ApiCommand?
    private var getRoleCommand: ApiCommand?
    private var getMemberCommand: ApiCommand?
    private var addMemberCommand: ApiCommand?
    private var deleteMemberCommand: ApiCommand?
    private var getDepartmentNextLevelCommand: ApiCommand?
    private var getOneRoleOthersByIdCommand: ApiCommand?
    
    init(param:AnyObject,delegate: AuthApiDelegate) {
        
        self.getProductCommand = GetProduct(param: param,delegate: delegate)
        self.getRoleCommand = GetRole(param: param,delegate:delegate)
        self.getMemberCommand = GetMember(param: param,delegate: delegate)
        self.addMemberCommand = AddMember(param: param,delegate: delegate)
        self.deleteMemberCommand = DeleteMember(param: param,delegate:delegate)
        self.getDepartmentNextLevelCommand = GetDepartmentNextLevel(param: param,delegate:delegate)
        self.getOneRoleOthersByIdCommand = GetOneRoleOthersById(param: param,delegate:delegate)
    }
//    
//    deinit {
//        self.getProductCommand = nil
//        self.getRoleCommand = nil
//        self.getMemberCommand = nil
//        self.addMemberCommand = nil
//        self.deleteMemberCommand = nil
//        self.getDeptGroupCommand = nil
//    }
    
    func getProduct() {
        if let command = getProductCommand {
            command.execute()
        }
    }
    
    func getRole() {
        if let command = getRoleCommand {
            command.execute()
        }
    }
    
    func getMember() {
        if let command = getMemberCommand {
            command.execute()
        }
    }
    
    func addMember() {
        if let command = addMemberCommand {
            command.execute()
        }
    }
    
    func deleteMember() {
        if let command = deleteMemberCommand {
            command.execute()
        }
    }
    
    func getDepartmentNextLevel() {
        if let command = getDepartmentNextLevelCommand {
            command.execute()
        }
    }
    
    func getOneRoleOthersById() {
        if let command = getOneRoleOthersByIdCommand {
            command.execute()
        }
    }
    
}
//MARK: GetProduct
class GetProduct: ApiBase,ApiCommand
{
    let param:AnyObject
    let delegate:AuthApiDelegate
    
    required init(param:AnyObject,delegate: AuthApiDelegate) {
        self.param = param
        self.delegate = delegate
    }
    
    func execute()
    {
        
        var path = ""
        switch apiType{
            //正式區API
        case .Release:
            path = "http://camp.quanta-camp.com/Solmgmt/api/SolMgmtApi/GetMySolutions"
            break
            //測試區API
        case .Test:
            path = "http://camp-test.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/GetMySolutions"
            break
        }
        
        POST(path , param: param ,completion:{(result:AnyObject,warning:String, success:Bool?) -> Void in
            
            if success == true {
                
                if let returnFunc = self.delegate.getProductSuccess {
                    returnFunc(result)
                }

            } else {
                
                if let returnFunc = self.delegate.getProductFail {
                    returnFunc(warning)
                }
                
            }
        })
        
        
    }
}
//MARK: GetRole
class GetRole: ApiBase,ApiCommand
{
    let param:AnyObject
    let delegate:AuthApiDelegate
    
    required init(param:AnyObject,delegate: AuthApiDelegate) {
        self.param = param
        self.delegate = delegate
    }
    
    func execute()
    {
        var path = ""
        switch apiType{
            //正式區API
        case .Release:
            path = "http://camp.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/GetRoleListById2"
            break
            //測試區API
        case .Test:
            path = "http://camp-test.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/GetRoleListById2"
            break
        }
        
        POST(path , param: param ,completion:{(result:AnyObject,warning:String, success:Bool?) -> Void in
            
            if success == true {
                
                if let returnFunc = self.delegate.getRoleSuccess {
                    returnFunc(result)
                }
                
            } else {
                
                if let returnFunc = self.delegate.getRoleFail {
                    returnFunc(warning)
                }
                
            }
        })
        
    }
}
//MARK: GetMember
class GetMember: ApiBase,ApiCommand
{
    let param:AnyObject
    let delegate:AuthApiDelegate
    
    required init(param:AnyObject,delegate: AuthApiDelegate) {
        self.param = param
        self.delegate = delegate
    }
    
    func execute()
    {
        var path = ""
        switch apiType{
            //正式區API
        case .Release:
            path = "http://camp.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/QueryMember"
            break
            //測試區API
        case .Test:
            path = "http://camp-test.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/QueryMember"
            break
        }
        
        POST(path , param: param ,completion:{(result:AnyObject,warning:String, success:Bool?) -> Void in
            
            if success == true {
                
                if let returnFunc = self.delegate.getMemberSuccess {
                    returnFunc(result)
                }
                
            } else {
                
                if let returnFunc = self.delegate.getMemberFail {
                    returnFunc(warning)
                }
                
            }
        })
        
    }
}
//MARK: AddMember
class AddMember: ApiBase,ApiCommand
{
    let param:AnyObject
    let delegate:AuthApiDelegate
    
    required init(param:AnyObject,delegate: AuthApiDelegate) {
        self.param = param
        self.delegate = delegate
    }
    
    func execute()
    {
        var path = ""
        switch apiType{
            //正式區API
        case .Release:
            path = "http://camp.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/AddRoleUsers"
            break
            //測試區API
        case .Test:
            path = "http://camp-test.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/AddRoleUsers"
            break
        }
        
        print("----")
        print(param)
        
        POST(path , param: param ,completion:{(result:AnyObject,warning:String, success:Bool?) -> Void in
            
            if success == true {
                
                if let returnFunc = self.delegate.addMemberSuccess {
                    returnFunc(result)
                }
                
            } else {
                
                if let returnFunc = self.delegate.addMemberFail {
                    returnFunc(warning)
                }
                
            }
        })
        
    }
}
//MARK: DeleteMember
class DeleteMember: ApiBase,ApiCommand
{
    let param:AnyObject
    let delegate:AuthApiDelegate
    
    required init(param:AnyObject,delegate: AuthApiDelegate) {
        self.param = param
        self.delegate = delegate
    }
    
    func execute()
    {
        var path = ""
        switch apiType{
            //正式區API
        case .Release:
            path = "http://camp.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/DeleteRoleUsers"
            break
            //測試區API
        case .Test:
            path = "http://camp-test.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/DeleteRoleUsers"
            break
        }
        
        POST(path , param: param ,completion:{(result:AnyObject,warning:String, success:Bool?) -> Void in
            
            if success == true {
                
                if let returnFunc = self.delegate.deleteMemberSuccess {
                    returnFunc(result)
                }
                
            } else {
                
                if let returnFunc = self.delegate.deleteMemberFail {
                    returnFunc(warning)
                }
                
            } 
        })
        
    }
}

//MARK: GetDepartmentNextLevel
class GetDepartmentNextLevel: ApiBase,ApiCommand
{
    let param:AnyObject
    let delegate:AuthApiDelegate
    
    required init(param:AnyObject,delegate: AuthApiDelegate) {
        self.param = param
        self.delegate = delegate
    }
    
    func execute()
    {
        var path = ""
        switch apiType{
            //正式區API
        case .Release:
            path = "http://camp.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/GetDepartmentNextLevel"
            break
            //測試區API
        case .Test:
            path = "http://camp-test.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/GetDepartmentNextLevel"
            break
        }
        
        POST(path , param: param ,completion:{(result:AnyObject,warning:String, success:Bool?) -> Void in
            
            if success == true {
                
                if let returnFunc = self.delegate.getDepartmentNextLevelSuccess {
                    returnFunc(result)
                }
                
            } else {
                
                if let returnFunc = self.delegate.getDepartmentNextLevelFail {
                    returnFunc(warning)
                }
                
            }
        })
        
    }
}

//MARK: GetDepartmentNextLevel
class GetOneRoleOthersById: ApiBase,ApiCommand
{
    let param:AnyObject
    let delegate:AuthApiDelegate
    
    required init(param:AnyObject,delegate: AuthApiDelegate) {
        self.param = param
        self.delegate = delegate
    }
    
    func execute()
    {
        var path = ""
        switch apiType{
        //正式區API
        case .Release:
            path = "http://camp.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/GetOneRoleOthersById"
            break
        //測試區API
        case .Test:
            path = "http://camp-test.quanta-camp.com/SolmgmtApi/api/SolmgmtApi/GetOneRoleOthersById"
            break
        }
        
        POST(path , param: param ,completion:{(result:AnyObject,warning:String, success:Bool?) -> Void in
            
            if success == true {
                
                if let returnFunc = self.delegate.getOneRoleOthersByIdSuccess {
                    returnFunc(result)
                }
                
            } else {
                
                if let returnFunc = self.delegate.getOneRoleOthersByIdFail {
                    returnFunc(warning)
                }
                
            }
        })
        
    }
}

public class ApiBase
{
    typealias onCompletion = (result:AnyObject,warning:String, success:Bool?) -> Void
    
    // MARK: 切換正式區或測試區
    var apiType = ApiType.Test
    
    // MARK: Restful API 使用Afnetworking
    func POST(path:String , param:AnyObject , completion:onCompletion){
        
        var result:AnyObject?
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer  = AFJSONRequestSerializer()

        // 呼叫https 無付費
//        var policy = AFSecurityPolicy.defaultPolicy()
//        policy.validatesDomainName = false
//        policy.allowInvalidCertificates = true
//        manager.securityPolicy = policy

        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")

        manager.POST( path,
        parameters: param,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!)  -> Void in

                result = responseObject //JSON(responseObject)
                //println("API SUCCESS : " + result )

                completion(result: result! , warning: "" , success: true)

            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                //println("API Error : " + error.localizedDescription)

                completion( result:"", warning: error.localizedDescription , success: false)


        })
    }
    
}