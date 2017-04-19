//
//  AuthBlockUI.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/28.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

import Foundation

protocol AuthBlockUI {
    
    func unBLockAll()
    func bLockAll()
    func unBLockClick()
    func blockClick()
}

extension AuthBlockUI
{
    func unBLockAll(){}
    func bLockAll(){}
    func unBLockClick(){}
    func blockClick(){}
    
}