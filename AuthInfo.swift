//
//  AuthRole.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/16.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import Foundation

public class AuthInfo
{
    public var title = ""
    public var subTitle = ""
    public var img = ""
    
    init(){
        
    }
    
    init(title:String,subTitle:String,img:String){
        self.title = title
        self.subTitle = subTitle
        self.img = img
    }
    
}