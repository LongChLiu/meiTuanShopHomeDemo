//
//  CommonMacro.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/16.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation




func kFontNameSize(fontNameSize:CGFloat)->UIFont{
    return UIFont.init(name: "PingFang-SC-Medium", size: fontNameSize) ?? UIFont.systemFont(ofSize: 15)
}

func kImage_Name(_ name:String) -> UIImage?{
    return UIImage.init(named: name)
}

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

let takeawayLeft_W = kScreenWidth * (75.0/375)
let takeawayRight_W = kScreenWidth * (300.0/375)

//字体
func kFont(_ fontSize:CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: fontSize)
}

//适配 等比放大控件
func Size(_ x:CGFloat) -> CGFloat {
    return x * kScreenWidth * 1.0 / 375.0
}

//默认导航栏、标签栏高度
func kDefaultNavBarHeight()->CGFloat{
    return kIsiPhoneX() ? 88.0 : (kSystemVersion() < 7.0 ? 44.0 : 64.0)
}

//系统版本
func kSystemVersion()->Float{
    let verstr = Float(UIDevice.current.systemVersion)!
    return verstr
}

//判断是否为iPhoneX
func kIsiPhoneX() -> Bool {
    return kScreenWidth == 375.0 && kScreenHeight == 812.0
}

//判断是否为iPhone 6P/6SP/7Plus/8P
func kIsiPhone678P() -> Bool {
    return kScreenWidth == 414.0 && kScreenHeight == 736.0
}

//判断是否是6、7、8
func kIsiPhone() -> Bool {
    return kScreenWidth == 375.0 && kScreenHeight == 667.0
}

//是否iPhone机型是否 5、5S、5C、SE
func kIsiPhone5SorSE() -> Bool {
    return kScreenWidth == 320 && kScreenHeight == 568.0
}

//判断是否为iPhone 3、3GS、4、4S
func kIsiPhone4() -> Bool {
    return kScreenWidth == 320 && kScreenHeight == 480
}



//高清屏检测
func kIsRetina()->Bool{
    return UIScreen.main.scale > 1
}

func Single_Line_Width() -> CGFloat{
    return 1.0 / UIScreen.main.scale
}

func Single_Line_Adjust_Offset() -> CGFloat{
    return (1.0 / UIScreen.main.scale) / 2.0
}

//最大尺寸
func kMaxCGSize()->CGSize{
    return CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
}

//国际化文本读取
func THLoc(__table__:String)->String{
    return NSLocalizedString(__table__, comment: "")
}


//模拟器与真机区别
struct Platform {
    static let isSimulator:Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

func kIsSimulator()->Bool{
    if Platform.isSimulator {
        print(NSLocalizedString("模拟器平台", comment: ""))
        return true
    }else{
        print(NSLocalizedString("真机平台", comment: ""))
        return false
    }
}



//数据验证
func StrValid(f:Any?) -> Bool{
    return (f != nil) && (f is String || f is NSString) && ((f as! String) != "")
}

func SafeStr(f:Any?) -> String{
    return StrValid(f: f) ? (f as! String) : ""
}

func HasString(str:String,key:String)->Bool{
    return (str as NSString).range(of: key).location != NSNotFound
}

func ValidStr(f:String)->Bool{
    return StrValid(f: f)
}

func validDict(f:Any?)->Bool{
    if let _ : NSDictionary = f as? NSDictionary {
        return true
    }
    return false
}

func validArray(f:Any?)->Bool{
    if let fArr : NSArray = f as? NSArray,fArr.count > 0 {
        return true
    }
    return false
}

func ValidNum(f:Any?)->Bool{
    if let _ = f as? NSNumber {
        return true
    }
    return false
}


func MyDefaults() -> UserDefaults{
    return UserDefaults.standard
}

func MyFileManager() -> FileManager{
    return FileManager.default
}

//Path
func DocumentsPath() -> String{
    return NSHomeDirectory().appending("Documents")
}


let kDefaultNavBar_SubView_MinY : CGFloat = kIsiPhoneX() ? 34 : 0


























