//
//  UILabel+ChangeLineAndWordSpace.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/8.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation
import UIKit



extension UILabel{
    
    
    private struct AssociatedKeys {
        static var characterSpace = "characterSpace"
        static var lineSpace = "lineSpace"
        static var keywords = "keywords"
        static var keywordsFont = "keywordsFont"
        static var keywordsColor = "keywordsColor"
        static var underlineStr = "underlineStr"
        static var underlineColor = "underlineColor"
    }
    
    var characterSpace:CGFloat{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.characterSpace) as! CGFloat
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.characterSpace, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    var lineSpace:CGFloat{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.lineSpace, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.lineSpace) as! CGFloat
        }
    }
   
    var keywords:String{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.keywords, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.keywords) as! String
        }
    }
    
    var keywordsFont:UIFont{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.keywordsFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.keywordsFont) as! UIFont
        }
    }
    
    
    var keywordsColor:UIColor{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.keywordsColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.keywordsColor) as! UIColor
        }
    }
    
    
    var underlineStr:String{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.underlineStr, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.underlineStr) as! String
        }
    }
    
    
    var underlineColor:UIColor{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.underlineColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.underlineColor) as! UIColor
        }
    }
    
    
    func getLabelRectMaxWidth(maxWidth:CGFloat) -> CGSize{
        if self.text != nil {
            var attributedStr = NSMutableAttributedString.init(string: self.text!)
            attributedStr.addAttribute(NSAttributedString.Key.font, value: self.font!, range: NSMakeRange(0,self.text!.count))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineBreakMode = self.lineBreakMode
            //行间距
            if (self.lineSpace > 0) {
                paragraphStyle.lineSpacing = self.lineSpace
                attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.text!.count))
            }
            
            //字间距
            if self.characterSpace > 0 {
                var number = self.characterSpace
                let num = CFNumberCreate( kCFAllocatorDefault, CFNumberType.sInt8Type, &number)
                attributedStr.addAttribute(kCTKernAttributeName as NSAttributedString.Key, value: num!, range: NSMakeRange(0, attributedStr.length))
            }
            
            //关键字
            if self.keywords.count == 0 {
                let itemRange = (self.text! as NSString).range(of: self.keywords)
                if let font = self.keywordsFont as? UIFont{
                    attributedStr.addAttribute(NSAttributedString.Key.font, value: font, range: itemRange)
                }
                if let color = self.keywordsColor as UIColor? {
                    attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: itemRange)
                }
            }
            
            //下划线
            if self.underlineStr.count == 0 {
                let itemRange : NSRange = (self.text! as NSString).range(of: self.underlineStr)
                attributedStr.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single, range: itemRange)
                if self.underlineColor != nil {
                    attributedStr.addAttribute(NSAttributedString.Key.underlineColor, value: self.underlineColor, range: itemRange)
                }
            }
            
            
            self.attributedText = attributedStr
            //计算方法二
            let maximumLabelSize = CGSize.init(width: maxWidth, height: CGFloat.greatestFiniteMagnitude) //labelsize的最大值
            let expectSize = self.sizeThatFits(maximumLabelSize)
            return expectSize
        }
        return CGSize.init(width: 0, height: 0)
    }
    
    
    
    
    
    
    
    
    
    
    
}










