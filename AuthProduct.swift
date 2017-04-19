//
//  AuthProduct.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import Foundation

public class AuthProduct
{
    public var productId = ""
    public var solutionId = ""
    public var solutionName = ""
    public var startDate = ""
    public var endDate = ""
    public var totalLicenseCount = ""
    public var billingType = ""
    public var duringTime = ""
    public var canQueryOtherCom = false
    
//    init(id:String,name:String,startDate:String,endDate:String,totalLicenseCount:String,billingType:String){
//        self.id = id
//        self.name = name
//        self.startDate = startDate
//        self.endDate = endDate
//        self.totalLicenseCount = totalLicenseCount
//        self.billingType = billingType
//        self.duringTime = startDate + " ~ " + endDate
//    }
    init(){}
    
    init(json:JSON){
        set(json)
    }
    
    public func set(json:JSON){
        if let proId = json["ProductId"].string {
            self.productId = proId
        }
        if let solutionId = json["SolutionId"].string {
            self.solutionId = solutionId
        }
        if let solutionName = json["SolutionName"].string {
            self.solutionName = solutionName
        }
        if let startDate = json["StartDate"].string {
            self.startDate = startDate
        }
        if let endDate = json["EndDate"].string {
            self.endDate = endDate
        }
        if let totalLicenseCount = json["TotalLicenseCount"].string {
            self.totalLicenseCount = totalLicenseCount
        }
        if let billingType = json["BillingType"].string {
            self.billingType = billingType
        }
        if let canQueryOtherCom = json["CanQueryOtherCom"].bool {
            self.canQueryOtherCom = canQueryOtherCom
        }
//
//        "ProductId": "CloudOperation",
//        "SolutionId": "CloudOperation",
//        "SolutionName": "(CAMP) 營運管理",
//        "StartDate": "2012/11/19",
//        "EndDate": "2099/11/19",
//        "TotalLicenseCount": "999999",
//        "BillingType": null
        
        self.duringTime = startDate + " ~ " + endDate
//        
//        self.productId          = json["ProductId"].string
//        self.solutionId         = json["SolutionId"].string
//        self.solutionName       = json["SolutionName"].string
//        self.startDate          = json["StartDate"].string
//        self.totalLicenseCount  = json["TotalLicenseCount"].string
//        self.billingType        = json["BillingType"].string//?.lowercaseString
//        
//        guard let start = startDate else {
//            self.duringTime = ""
//            return
//        }
//        
//        guard let end = endDate else {
//            self.duringTime = ""
//            return
//        }
        
//        self.duringTime = startDate + " ~ " + endDate

    }
}