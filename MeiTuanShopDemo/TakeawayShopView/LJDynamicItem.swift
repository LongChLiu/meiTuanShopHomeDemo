//
//  LJDynamicItem.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/24.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

class LJDynamicItem: NSObject,UIDynamicItem {
    
    var bounds: CGRect
    var transform: CGAffineTransform
    var center: CGPoint
    
    override init() {
        self.bounds = CGRect.zero
        self.transform = CGAffineTransform.init()
        self.center = CGPoint.init()
        super.init()
        bounds = CGRect.init(x: 0, y: 0, width: 1, height: 1)
    }
    
}
