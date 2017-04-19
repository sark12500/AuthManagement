//
//  AuthExtension.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/3/28.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

import Foundation

protocol AuthExtension {
    
    func localization(key:String) -> String
    func alertHandler(title:String , message:String , delay:Double)
}

extension AuthExtension
{
    func localization(key:String) -> String {
        return NSLocalizedString(key,comment:"")
    }
    
    
    func alertHandler( title:String , message:String , delay:Double )
    {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.show()
        
        let delay = delay * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
}