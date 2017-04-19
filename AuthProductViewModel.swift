//
//  AuthProductViewModel.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/17.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

public class AuthProductViewModel
{
    
    // Singelton
    //static let instance = ShiftApiManager()
    class var instance : AuthProductViewModel {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance  : AuthProductViewModel? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AuthProductViewModel()
        }
        return Static.instance!
    }
    
    // MARK:產品列表
    private var filteredCandies:Array<AuthProduct> = []
    public var FilteredCandies:( Array<AuthProduct> )
    {
        get{ return filteredCandies }
        set (newVal)
        {
            filteredCandies = newVal
        }
    }
    
    public func getFilteredCandiesRow(index:Int) -> AuthProduct
    {
        return filteredCandies[index]
    }
    
    private var productList:Array<AuthProduct> = []

    public var ProductList:( Array<AuthProduct> )
    {
        get{ return productList }
        set (newVal)
        {
            productList = newVal
        }
    }
    
    public func Clear()
    {
        productList.removeAll()
    }
    
    public func getProductRow(index:Int) -> AuthProduct
    {
        return productList[index]
    }
    
    public func getProductRow(id:String) -> AuthProduct
    {
        for product in productList where product.solutionId == id {
            return product
            
        }
        
        return AuthProduct()
    }
    
    public func getProductBillingType(id:String) -> String
    {
        for product in productList where product.solutionId == id {
            return product.billingType.lowercaseString
        
        }
        
        return ""
    }
    
    public func getProductListCount() -> Int
    {
        return productList.count
    }
    
    public func getThisProductRow() -> AuthProduct
    {
        let id = self.SolutionId
        
        for product in productList where product.solutionId == id {
            return product
        }
        
        return AuthProduct()
    }
    
    public func getThisProductBillingType() -> String
    {
        let id = self.SolutionId
        for product in productList where product.solutionId == id {
            return product.billingType.lowercaseString
            
        }
        
        return ""
    }
    
    public func getThisProductCanQueryOtherCom() -> Bool
    {
        let id = self.SolutionId
        for product in productList where product.solutionId == id {
            return product.canQueryOtherCom
            
        }
        
        return false
    }
    
    // MARK: 目前所選key
    private var solutionId = ""
    private var solutionName = ""
    
    public var SolutionId:(String)
    {
        get{ return solutionId }
        set (newVal)
        {
            solutionId = newVal
            
            for product in productList where product.solutionId == solutionId {
                solutionName = product.solutionName
                break
            }
        }
    }
    
    public var SolutionName:(String)
    {
        get{ return solutionName }
    }

}