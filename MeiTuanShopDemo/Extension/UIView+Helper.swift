//
//  UIView+Helper.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/21.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation

extension UIView{
    
    @objc func minY()->CGFloat{
        return self.frame.minY
    }
    
    @objc func midY() -> CGFloat {
        return self.frame.midY
    }
    
    @objc func maxY() -> CGFloat {
        return self.frame.maxY
    }
    
    @objc func minX() -> CGFloat {
        return self.frame.minX
    }
    
    @objc func midX() -> CGFloat {
        return self.frame.midX
    }
    
    @objc func maxX() -> CGFloat {
        return self.frame.maxX
    }
    
    @objc func width() -> CGFloat {
        return self.frame.width
    }
    
    @objc func height() -> CGFloat {
        return self.frame.height
    }
    
}




