//
//  ColorMacro.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/4/30.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit


func kColor(_ hexStr:String)->UIColor{
    return AppMethods.colorWithHexString(hexStr)
}


let Title_Style = "PingFangSC-Regular"

let kColor_NavColor = kColor("#FD5151") //红色 主题颜色
let kColor_TitleColor = kColor("#666666") //标题颜色
let kColor_GrayColor = kColor("#999999")
let kColor_CircleColor = kColor("#F85F4F") //红色圆圈颜色
let kColor_darkGrayColor = kColor("#000000") //黑色背景
let kColor_borderColor = kColor("#EEEEEE") //边框
let kColor_bgHeaderViewColor = kColor("#E2E2E2")
let kColor_darkBlackColor = kColor("#333333") //黑色字体
let kColor_blueColor = kColor("#0076FF") //蓝色字体
let kColor_ButtonCornerColor = kColor("#D9D9D9")
let kColor_LightGrayColor = kColor("F0EFED") //灰色背景
let kColor_bgViewColor = kColor("F9F9F9")
let kColor_ReplyColor = kColor("#535353")//



func RGBA(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat)->UIColor{
  return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func RGB(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat)->UIColor{
    return RGBA(r, g, b, 1)
}

//rgb颜色转换 （16进制 -> 10进制）
func UIColorFromRGB(_ rgbValue:Int) -> UIColor{
    return UIColor.init(red: CGFloat((rgbValue&0xFF0000)>>16) / 255.0, green: CGFloat((rgbValue&0xFF00)>>8)/255.0, blue: CGFloat(rgbValue&0xFF)/255.0, alpha: 1.0)
}



let KColor_AlertViewBg = RGBA(0,0,0,0.4) //弹窗口背景灰色
