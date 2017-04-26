//
//  AuthAddCell.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/4/25.
//  Copyright © 2016年 DoubleTap Mobile. All rights reserved.
//

import UIKit

class AuthAddCell: UICollectionViewCell {

    @IBOutlet weak var cancelImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String,memberType:AuthMemberType) {
        
        self.userName.text = name
        self.userImg.image = UIImage(named:memberType.getImg())
        self.userName.font = UIFont.systemFontOfSize(memberType.getAddCellFontSize())
    }
    
    func setNameSize(size:Int) {
        
        self.userName.font = UIFont.systemFontOfSize(12)
    }

}
