//
//  HeaderReusableView.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/22.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
 
    
    var titleLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let line = UITool.lineLab(CGRect(x: 10, y: 10, width: 1, height: 14))
        line.backgroundColor = UIColorFromRGB(0xFF5A49)
        self.addSubview(line)
        
        titleLab = UITool.createLabel(CGRect(x: line.maxX()+7, y: 0, width: 200, height: 34), UIColor.clear, kColor_GrayColor, 12, .left, lines: 1)
        self.addSubview(titleLab)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
