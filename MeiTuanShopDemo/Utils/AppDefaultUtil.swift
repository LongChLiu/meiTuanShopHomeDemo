//
//  AppDefaultUtil.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/4/30.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

let sharedClient = AppDefaultUtil()

class AppDefaultUtil: NSObject {
    
    static func sharedInstance()->AppDefaultUtil{
        return sharedClient
    }
    
    
    //图文混排  插入图片
    class func addAttribute(name:String,Img:UIImage,bounds:CGRect,index:Int) -> NSMutableAttributedString{
        //先创建富文本
        let attriStr = NSMutableAttributedString.init(string: name)
        //设置富文本中不同文字的样式
        let attchImage = NSTextAttachment()
        //表情图片
        attchImage.image = Img
        //设置图片大小
        attchImage.bounds = bounds
        let strImage = NSAttributedString.init(attachment: attchImage)
        attriStr.insert(strImage, at: index)
        return attriStr
    }
    
    
    class func returnLineSpacing(Str labelText:String,lineCount:CGFloat,alignment:NSTextAlignment) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString.init(string: labelText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineCount
        paragraphStyle.alignment = alignment
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, labelText.count))
        return attributedString
    }
    
    
    class func returnLineSpacingWithStr22(labelText:NSMutableAttributedString,lineCount:CGFloat,alignment:NSTextAlignment) -> NSMutableAttributedString{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineCount //调整行间距
        paragraphStyle.alignment = alignment
        labelText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, labelText.length))
        return labelText
    }
        
    class func returnStringColor(string:String,range:NSRange,color:UIColor) -> NSMutableAttributedString{
        let str = NSMutableAttributedString.init(string: string)
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return str
    }
    
    class func returnString(string:String,range:NSRange,size:CGFloat) -> NSMutableAttributedString{
        let str = NSMutableAttributedString.init(string: string)
        str.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: size), range: range)
        return str
    }
    

}
