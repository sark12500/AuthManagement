//
//  AuthSelectedCell.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/4/19.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import UIKit

class AuthSelectedCell: UITableViewCell {

    var selectIndex = 0
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var next: UIImageView!
    
    //若只要變圖tableview 沒有reload的寫法
    @IBAction func checkBtnClick(sender: AnyObject) {
//        btnSelectd = !btnSelectd
//        var img = ""
//        img = btnSelectd ? "a_img_checkbox_checked" :"a_img_checkbox_default"
//        
//        self.checkBtn.setImage(UIImage(named:img), forState: .Normal)
    }
    
    @IBOutlet weak var memberImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String,subTitle: String,memberType:AuthMemberType,btnSelectd:Bool) {
        
        self.title.text = title
        self.subTitle.text = subTitle
        self.memberImg.image = UIImage(named:memberType.getImg())
        
        var img = ""
        img = btnSelectd ? "a_img_checkbox_checked" :"a_img_checkbox_default"
        
        self.checkBtn.setImage(UIImage(named:img), forState: .Normal)
    }
    
}
