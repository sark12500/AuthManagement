//
//  AuthSelectedComCell.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/4/19.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import UIKit

class AuthSelectedComCell: UITableViewCell {
    
    var btnSelectd = false
    var selectIndex = 0
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var next: UIImageView!
    @IBAction func checkBtnClick(sender: AnyObject) {
//        btnSelectd = !btnSelectd
//        var img = ""
//        img = btnSelectd ? "a_img_checkbox_checked" :"a_img_checkbox_default"
//        
//        self.checkBtn.setImage(UIImage(named:img), forState: .Normal)
//        print(" AuthSelectedComCell click")
    }
    
    @IBOutlet weak var memberImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String,memberType:AuthMemberType,btnSelectd:Bool) {
        
        self.title.text = title
        self.memberImg.image = UIImage(named:memberType.getImg())
        
        var img = ""
        img = btnSelectd ? "a_img_checkbox_checked" :"a_img_checkbox_default"
        
        self.checkBtn.setImage(UIImage(named:img), forState: .Normal)
    }
    
}
