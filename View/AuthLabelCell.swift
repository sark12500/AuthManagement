//
//  AuthProduct.swift
//  QuantaCMP
//
//  Created by ccasd_saas01 on 2016/4/19.
//  Copyright (c) 2016年 Quanta Inc. All rights reserved.
//

import UIKit

class AuthLabelCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String) {

        self.title.text = title

    }

}
