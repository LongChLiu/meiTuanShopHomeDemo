//
//  EvaluateModel.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/23.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit
import HandyJSON



class EvaluateModel: HandyJSON {
    
    
    //cell的缓存高度
    var cellHeight:CGFloat!
    
    
    var content:String!
    var evaluateType:String!
    var healthScore:String!
    var locationScore:String!
    var memberHeadUrl:String!
    var memberId:String!
    var memberName:String!
    var performanceScore:String!
    var replyContent:String!
    var roomTypeName:String!
    var serviceScore:String!
    var totalScore:String!
    var picList:[NSDictionary] = [NSDictionary]()
    var commTime:String!
    var regular:String!
    var commContent:String!
    
    
    
    
    var name:String!
    var iD:String!
    var isSelected:Bool = false
    
    
    
    func calculateCellHeight(dic:NSDictionary){
        var height:CGFloat = 60
        //评论内容
        let commContent = dic["commContent"]
        let commContentSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 14), Str: commContent as! String, MaxWidth: kScreenWidth-20)
        height = height + commContentSize.height
        //是否有图片
        let picList:NSArray = dic["picList"] as! NSArray
        if picList.count > 0 {
            //图片宽和高
            let pgotoW :CGFloat = 80
            //有图片
            height = height + 6;//+6是文本和图片的间隔
            if picList.count <= 3{
                //小于等于三张
                height = height + pgotoW
            }else if (picList.count > 3 && picList.count <= 6){
                //小于等于6张大于3张
                height = height + pgotoW + pgotoW + 4;//+4是图片与图片之间的间隔
            }else{
                //大于6张，小于等于9张
                height = height + pgotoW + pgotoW + pgotoW + 4 + 4;//+4是图片与图片之间的间隔
            }
        }else{//没图片
        }
        
        //是否商家回复了
        if let replyContent : String = "酒店回复:\( String.jsonUtils(strValue: dic["replyContent"]!) )" {
            if replyContent.count > 5 {//有回复
                height = height + 20   //+20是上下文间的间隔
                let replyContentSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 14), Str: replyContent, MaxWidth: kScreenWidth-40)
                height = height + replyContentSize.height + 20 + 20
            }else{//无回复
                height = height + 20
            }
        }
        
        //缓存高度
        self.cellHeight = height
    }
    
    
    func calculateReserveCellHeight(){
        var height:CGFloat = 60
        //评论内容
        let commContent = self.commContent
        let commContentSize : CGSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 14), Str: commContent!, MaxWidth: kScreenWidth-54)
        height = height + commContentSize.height
        
        //是否有图片
        let picList:NSArray = self.picList as NSArray
        if picList.count > 0 {//图片宽和高
            let pgotoW:CGFloat = 80
            //有图片
            height = height + 6 //+6是文本和图片的间隔
            if picList.count <= 3{
                //小于等于三张
                height = height + pgotoW
            }else if(picList.count > 3 && picList.count <= 6){
                //小于等于6张大于三张
                height = height + pgotoW + pgotoW + 4//+4是图片和图片之间的间隔
            }else{
                //大于6张 小于等于9张
                height = height + pgotoW + pgotoW + pgotoW + 4 + 4;//+4是图片与图片之间的间隔
            }
        }else{//没图片
            
        }
        
        //是否商家回复了
        if let replyContent:String = String.init(format: "酒店回复:%@", self.replyContent) {
            if replyContent.count > 5{
                //有回复
                height = height + 20;//+20是上下之间的间隔
                let replyContentSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 14), Str: replyContent, MaxWidth: kScreenWidth-74)
                height = height + replyContentSize.height + 20 + 20
            }else{
                //无回复
                height = height + 20
            }
        }
        //缓存高度
        self.cellHeight = height
    }
    
    
    //MARK: 计算外卖店铺主页评价cell的高度
    func calculateTakeawayEvaludateCellHeight(){
        var height:CGFloat = 42
        //评论内容
        let commContent = self.commContent
        
        let commContentSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 12), Str: commContent!, MaxWidth: kScreenWidth-60)
        
        if commContent?.count == 0 {
            //评论为空
        }else{
            height = height + commContentSize.height + 10//+10是文本跟时间的间隔
        }
        
        //是否有图片
        let picList:[NSDictionary] = self.picList
        if picList.count > 0 {
            //图片宽和高
            let pgotoW:CGFloat = 80
            height = height + 10 //+10是图片和上面控件的间隔
            if picList.count <= 3{
                //小于等于三张
                height = height + pgotoW
            }else if(picList.count > 3 && picList.count <= 6){
                //小于等于6张大于3张
                height = height + pgotoW + pgotoW + 4;//+4是图片与图片之间的间隔
            }else{
                //大于6张，小于等于9张
                height = height + pgotoW + pgotoW + pgotoW + 4 + 4;//+4是图片与图片之间的间隔
            }
        }else{
            //没图片
        }
        
        //踩菜品 赞菜品视图
        height = height + 15 + 40
        //是否商家回复了
        if let replyContent :String = String.init(format: "酒店回复:%@", self.replyContent) {
            if replyContent.count > 5 {
                //有回复
                height = height + 10 //+20是上下之间的间隔
                var replyContentSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 12), Str: replyContent, MaxWidth: kScreenWidth-80)
                height = height + replyContentSize.height + 14 + 20
            }else{
                //无回复
                height = height + 20
            }
        }
        //缓存高度
        self.cellHeight = height
    }
    
    required init() {
        
    }
    
}
