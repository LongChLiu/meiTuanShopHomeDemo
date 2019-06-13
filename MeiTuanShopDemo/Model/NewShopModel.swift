//
//  NewShopModel.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/15.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit
import HandyJSON


@objc class NewShopModel: NSObject, HandyJSON {
    
    //活动数量
    var activeCount:String?
    //评论数量
    var commCount:String?
    //评分
    var commScore:String?
    //
    var count:String?
    //是否收藏
    var isCollection:String?
    
    //营业时间
    var openHour:String?
    
    //店铺背景图
    var picUrl:String?
    //地址
    var shopAddress:String?
    //店铺图标
    var shopIcon:String?
    //店铺介绍
    var shopIntroduce:String!
    //经纬度
    var shopLocation:String?
    //店铺名称
    var shopName:String?
    //公告
    var shopNotice:String?
    //资质图片
    var shopPicList:NSArray!
    //店铺类型 1企业认证 2商家认证 3个体工商户 4不显示
    var sortInfo:NSMutableArray?
    
    
    var isStyle:String?
    //是否显示店铺信息 0-否，1-是
    var style_groupInfoShow:String?
    //导航位置类型 1横向导航 2竖向导航
    var style_tabPosition:String?
    //快速布局类型 1列表布局、2宫格布局 3卡片布局
    var sys_moduleType:String?
    var telnumber:String?
    /*优惠券*/
    var couponList:[CouponListModel]!
    //活动
    @objc var activityList:[CouponListModel]!
    
    //聊天客服JID
    var serviceJIDUserName:String?
    //客服名称
    var serviceUserNickName:String?
    //客服头像
    var serviceHeadFace:String?
    //聊天用户名
    var serviceName:String?
    //聊天用户id
    var serviceId:String?
    //是否开启客服聊天
    var serviceOpenState:String?
    
    
    required override init() {
        
    }
    
}




//MARK:优惠券
class CouponListModel:NSObject,HandyJSON {
    
    var activeId:String!
    var couponCondition:String!
    var couponEndTime:String!
    var couponId:String!
    var couponNumber:String!
    var couponPrice:String!
    var couponStartTime:String!
    var couponTime:String!
    var couponTitle:String!
    var isPlatForm:String!
    
    
    //活动名称
    var activeEndTime:String!
    var activeStartTime:String!
    var activeTitle:String!
    var activeType:String!
    var isPlantActive:String!
    
    
    static func propertyIsOptional(propertyName:String) -> Bool{
        return true
    }
    
//    override func copy(with zone: NSZone? = nil) -> Any {
//        let model = CouponListModel.init()
//        model.couponNumber = self.couponNumber
//        return model
//    }
    
    func mutableCopy(zone:NSZone) -> Any{
        let model = CouponListModel.init()
        model.couponNumber = self.couponNumber
        return model
    }
    
    
    required override init() {
        
    }
    
    
}



