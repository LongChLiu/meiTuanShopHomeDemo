//
//  UITool.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/4/28.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit


typealias NaviBarSubViews = (_ iv:UIImageView,_ leftButton:UIButton,_ rightBtn:UIButton)->Void

enum ButtonTag:Int {
    case ButtonTagLeft
    case ButtonTagRight
}

typealias HttpRequest = ()->Void //刷新请求


typealias LeftButtonAction = (_ button:UIButton)->Void
typealias RightButtonAction = (_ button:UIButton)->Void



@objc class UITool: NSObject {
    
    var headRequest:HttpRequest! = nil
    
    
    @objc class func createTextField(_ frame:CGRect,_ backgroundCOlor:UIColor,_ placeholder:String? = nil,_ tag:Int)->UITextField{
        let textField = UITextField();
        textField.tag = tag;
        textField.frame = frame;
        textField.placeholder = placeholder
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = backgroundCOlor
        textField.clearsOnBeginEditing = false
        return textField
    }
    
    
    @objc class func createLabel(_ frame:CGRect,_ backgroundColor:UIColor,_ textColor:UIColor)->UILabel{
        let label = UILabel()
        label.frame = frame
        label.textColor = textColor
        label.isHighlighted = true
        label.backgroundColor = backgroundColor
        label.textAlignment = NSTextAlignment.left
        return label
    }
    
    @objc class func createLabel(_ frame:CGRect,_ backgroundColor:UIColor,_ textColor:UIColor,_ size:CGFloat,_ alignment:NSTextAlignment,lines:Int)->UILabel{
        let label = UITool.createLabel(frame, backgroundColor, textColor)
        //开启字体大小自动缩放
        //label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: size)
        label.textAlignment = alignment
        label.numberOfLines = lines
        return label
    }
    
    @objc class func createLabel(textColor color:UIColor,_ size:CGFloat,_ alignment:NSTextAlignment)->UILabel{
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)
        label.textAlignment = alignment
        return label
    }
    
    @objc class func lineLab(_ frame:CGRect)->UILabel{
        let label = UILabel.init(frame: frame)
        label.backgroundColor = kColor_borderColor
        return label
    }
    
    @objc class func createImageView(Frame frame:CGRect,Image img:String,cornerRadius:CGFloat)->UIImageView{
        let imgView = UIImageView.init(image: UIImage.init(named: img))
        imgView.frame = frame;
        //图片切成圆角
        imgView.layer.cornerRadius = cornerRadius
        //遮罩后面的图片
        imgView.layer.masksToBounds = true
        //加入视图里面
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        return imgView
    }
    
    @objc class func createButton(Frame frame:CGRect,Title title:String,BgColor bgcolor:UIColor,TitleColor titColor:UIColor,Target target:Any,Sel selector:Selector,Tag tag:Int) ->UIButton{
        let btn = UIButton(type: .custom)
        btn.tag = tag;btn.frame = frame;
        btn.setBackgroundImage(AppMethods.createImage(bgcolor), for: UIControl.State.normal)
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = 0
        btn.layer.masksToBounds = true
        
        btn.setTitle(title, for: UIControl.State.normal)
        btn.setTitleColor(titColor, for: .normal)
        btn.addTarget(target, action: selector, for: .touchUpInside)
        return btn
    }
        
    @objc class func createScrollView(Frame frame:CGRect,ContentSize conSize:CGSize,bounces:Bool) -> UIScrollView{
        let scrollView = UIScrollView()
        scrollView.frame = frame
        scrollView.bounces = bounces //是否可以拖到边缘
        scrollView.contentSize = conSize
        scrollView.showsHorizontalScrollIndicator = false //是否隐藏进度条
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }
    
    @objc class func createTextField(Frame frame:CGRect,BgColor bgColor:UIColor,Placeholder placeholder:String,tag:Int,TextColor color:UIColor,LeftImage image:UIImage)->UITextField{
        let textField = UITextField()
        textField.leftViewMode = .always
        textField.tag = tag
        textField.frame = frame
        textField.placeholder = placeholder
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = bgColor
        textField.clearsOnBeginEditing = false
        textField.textColor = color
        
        let bkView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: frame.size.height))
        let iv = UIImageView.init(frame: CGRect.init(x: 5, y: 5, width: 39, height: 39))
        iv.image = image
        bkView.addSubview(iv)
        textField.leftView = bkView
        return textField
    }
    
    
    
    
    

}
