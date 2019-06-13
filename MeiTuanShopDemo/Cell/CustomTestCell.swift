//
//  CustomTestCell.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/31.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

class CustomTestCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    lazy var iconImageView:UIImageView = {
       let imgView = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 14, height: 14))
        imgView.image = UIImage.init(named: "")
       return imgView
    }()
    
    lazy var redLab:UILabel = {
        let label = UILabel.init()
        label.text = "消息中心"
        label.frame = CGRect.init(x: 80, y: 9, width: 4, height: 4)
        return label
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel.init()
        label.frame = CGRect.init(x: 29, y: 6, width: 110, height: 21)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.redLab.layer.cornerRadius = 2
        self.redLab.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
