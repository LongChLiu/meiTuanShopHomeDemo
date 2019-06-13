//
//  ShoppingCartOrderListInfo.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/20.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit
import HandyJSON

class ShoppingCartOrderListInfo: HandyJSON {
    
    
    var orderid:String!
    var name:String!
    var min_price:String!
    var praise_num:String!
    var picture:String!
    var month_saled:String!
    var orderCount:String!
    
    
    //产品名称
    var productName:String!
    //原始价格
    var originalPrice:String!
    
    
    static func propertyIsOptional(propertyName:String)->Bool{
        return true
    }
    
    required init() {
        
    }
    
}
