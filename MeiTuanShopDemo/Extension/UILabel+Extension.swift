//
//  UILabel+Extension.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/9.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation
import UIKit

/*
 UILabel某一段富文本点击
 */
@objc protocol YBAttributeTapActionDelegate {
    
    
    //@param string 点击的字符串
    //@param range 点击的字符串range
    //@param index 点击的字符在数组中的index
    @objc optional func yb_attributeTapReturnString(str:String,range:NSRange,index:Int)
    
    
}


class YBAttributeModel: NSObject {
    
    var str:String = ""
    var range:NSRange!
    
    
}


extension UILabel{
    
    
    //设置Label行首缩进 缩进长度 缩进文本 缩进完成字符串
    func addFirstLineHeadIndentWithIndentLength(length:CGFloat,indenText text:String)->NSAttributedString{
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = NSTextAlignment.left //对齐
        paraStyle.headIndent = 0.0 //行首缩进
        let emptylen:CGFloat = length
        paraStyle.firstLineHeadIndent = emptylen //首行缩进
        let attrText = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle:paraStyle])
        return attrText
    }
    
    
    //添加删除线 text 删除线文本 添加完成的文本
    func addDeletingLineWithText(text:String,DeletingLineColor color:UIColor) -> NSMutableAttributedString{
        let oldPrice:String = text
        let length = oldPrice.count
        let attri = NSMutableAttributedString.init(string: oldPrice)
        attri.addAttribute(NSAttributedString.Key.strikethroughStyle, value: [NSUnderlineStyle.patternDash,NSUnderlineStyle.single], range: NSMakeRange(0, length))
        attri.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: NSMakeRange(0, length))
        return attri
    }
    
    
    /*
     改变一个label其中几个字的大小跟颜色
     @param NeedChangeString 需要改变的字符串
     @param font 大小
     @param color 颜色
     @param range 改变范围
     @return 改变后的字符串
     */
    func addAttributedStringWithNeedChangeString(needChangeStr:String,Font font:UIFont,Color color:UIColor,Range range:NSRange)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString.init(string: needChangeStr)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor:color], range: range)
        return attributedString
    }
    
    
    class func getHeightBy(Width width:CGFloat,Title title:String,Font font:UIFont,LineSpace lineSpace:CGFloat) -> CGFloat{
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 0))
        label.text = title
        label.font = font
        label.numberOfLines = 0
        
        let attributedString = NSMutableAttributedString.init(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, title.count))
        label.attributedText = attributedString
        label.sizeToFit()
        let height = label.frame.size.height
        return height
    }
    
    class func getHeightBy(Width width:CGFloat,Title title:String,Font font:UIFont,LineSpace linespace:CGFloat,groupSpace:CGFloat) -> CGFloat{
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 0))
        label.text = title;label.font = font;label.numberOfLines = 0;
        
        let attributedString = NSMutableAttributedString.init(string: title)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = linespace
        paragraphStyle.paragraphSpacing = groupSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, title.count))
        label.attributedText = attributedString
        
        label.sizeToFit()
        let height = label.frame.size.height
        
        return height
    }
    
    class func getHeight(ByWidth width:CGFloat,Title title:String,Font font:UIFont) -> CGFloat{
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 0))
        label.text = title
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        let height = label.frame.size.height
        return height
    }
    
    class func getWidth(Title title:String,Font font:UIFont) -> CGFloat{
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 1000, height: 0))
        label.text = title
        label.font = font
        label.sizeToFit()
        return label.frame.size.width
    }
    
    /*
     给文本添加点击事件Block回调
     @param strings 需要添加的字符串数组
     @param tapClick 点击事件回调
     */
    
    //MARK: AssociatedObjects  关联对象
    static var attributeStrings_Key:String = "attributeStrings_Key"
    var attributeStrings:NSMutableArray{
        set{
            objc_setAssociatedObject(self, &UILabel.attributeStrings_Key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &UILabel.attributeStrings_Key) as! NSMutableArray
        }
    }
    
    
    static var tapBlock_Key:String = "tapBlock_Key"
    var tapClosure:((String,NSRange,Int)->Void){
        set{
            objc_setAssociatedObject(self, &UILabel.tapBlock_Key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &UILabel.tapBlock_Key) as! ((String,NSRange,Int)->Void)
        }
    }
    
    
    static var delegate_Key:String = "delegate_Key"
    var delegate:YBAttributeTapActionDelegate{
        set{
            objc_setAssociatedObject(self, &UILabel.delegate_Key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &UILabel.delegate_Key) as! YBAttributeTapActionDelegate
        }
    }
    
    
    //MARK: mainFunction
    func yb_addAttributeTapAction(strings:[String],tapClicked:((String,NSRange,Int)->Void)?){
        self.yb_getRanges(strings: strings)
        if tapClicked != nil {
            self.tapClosure = tapClicked!;
        }
    }
    
    func yb_addAttributeTapAction(strings:[String],delegate:YBAttributeTapActionDelegate ){
        self.yb_getRanges(strings: strings)
        self.delegate = delegate
    }
    
    
    //MARK: touchAction
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch : UITouch = (touches as NSSet).anyObject() as! UITouch
        var point = touch.location(in: self)
        
        weak var weakSelf = self
        
        
        
    }
    
    
    //MARK:  getTapFrame
    func yb_getTapFrame(TouchPoint point:CGPoint,result:((String,NSRange,Int)->Void))->Bool{
        
        let framesetter = CTFramesetterCreateWithAttributedString(self.attributedText!)
        
        let path = CGMutablePath();
        path.addRect(self.bounds)
        
        let frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), path, nil)
        
        let lines = CTFrameGetLines(frame)
        
        if lines == nil {
            return false
        }
        
        let count = CFArrayGetCount(lines)
        var origins:[CGPoint] = [CGPoint]()
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        let transform = self.yb_transformForCoreText()
        let verticalOffset = 0
        for idx in 0..<count {
            let linePoint : CGPoint = origins[idx]
            let line : CTLine = CFArrayGetValueAtIndex(lines, idx) as! CTLine
            let flippedRect = self.yb_getLineBounds(line: line, point: linePoint)
            var rect = flippedRect.applying(transform)
            rect = rect.insetBy(dx: 0, dy: 0)
            rect = rect.offsetBy(dx: 0, dy: CGFloat(verticalOffset))
            
            if rect.contains(point){
                let relativePoint = CGPoint.init(x: point.x - rect.minX, y: point.y - rect.minY)
                var index = CTLineGetStringIndexForPosition(line, relativePoint)
                var offset:CGFloat = 0
                CTLineGetOffsetForStringIndex(line, index, &offset)
                if offset > relativePoint.x{
                    index = index - 1
                }
                
                let link_count = self.attributeStrings.count
                for j in 0..<link_count{
                    let model:YBAttributeModel = self.attributeStrings[j] as! YBAttributeModel
                    let link_range:NSRange = model.range
                    if NSLocationInRange(index, link_range){
                        result(model.str,model.range,j)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    func yb_transformForCoreText()->CGAffineTransform{
        let x = CGAffineTransform.init(translationX: 0, y: self.bounds.size.height)
        return x.scaledBy(x: 1, y: 1)
    }
    
    func yb_getLineBounds(line:CTLine,point:CGPoint) -> CGRect{
        var ascent:CGFloat = 0.0
        var descent:CGFloat = 0.0
        var leading:CGFloat = 0.0
        let width:CGFloat = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, &leading))
        let height:CGFloat = ascent + descent
        return CGRect.init(x: point.x, y: point.y-descent, width: width, height: height)
    }
    
    //pragma mark - getRange
    func yb_getRanges(strings:[String]){
        let totalStr = self.attributedText?.string;
        self.attributeStrings = NSMutableArray()
        
        weak var weakSelf = self
        for(_,obj) in strings.enumerated(){
            let range = (totalStr! as NSString).range(of: obj)
            if range.length != 0 {
                let model = YBAttributeModel()
                model.range = range
                model.str = obj
                weakSelf?.attributeStrings.add(model)
                (totalStr! as NSString).replacingCharacters(in: range, with: weakSelf?.yb_getString(range: range) as! String)
            }
        }
    }
    
    func yb_getString(range:NSRange) -> NSMutableString{
        let str : NSMutableString = NSMutableString()
        for _ in 0..<range.length{
            str.append(" ")
        }
        return str
    }
    
    
    
}
