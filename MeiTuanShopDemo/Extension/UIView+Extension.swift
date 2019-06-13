//
//  UIView+Extension.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/10.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation
import UIKit


@objc extension UIView{
    
    @objc var x:CGFloat{
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    @objc var y:CGFloat{
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    
    @objc var top:CGFloat{
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.y
        }
    }
    
    @objc var bottom:CGFloat{
        @objc set{
            var frame = self.frame
            frame.origin.y = newValue-frame.size.height
            self.frame = frame
        }
        @objc get{
            return self.frame.maxY
        }
    }
    
    
    @objc var centerX:CGFloat{
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get{
            return self.center.x
        }
    }
    
    @objc var centerY:CGFloat{
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get{
            return self.center.y
        }
    }
    
    
    @objc var changeWidth:CGFloat{
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get{
            return self.frame.size.width
        }
    }
    
    
    @objc var changeHeight:CGFloat{
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get{
            return frame.size.height
        }
    }
    
    
    @objc var left:CGFloat{
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin.x
        }
    }
    
    
    @objc var right:CGFloat{
        set{
            var frame = self.frame
            frame.origin.x = newValue-frame.size.width
            self.frame = frame
        }
        get{
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    
    @objc var size:CGSize{
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get{
            return self.frame.size
        }
    }
    
    @objc var origin:CGPoint{
        set{
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get{
            return self.frame.origin
        }
    }
    
    
    @objc static func viewInstance() -> Any?{
        let clazz = NSStringFromClass(self)
        let path = Bundle.main.path(forResource: clazz, ofType: "nib")
        if path != nil {
            let tmp = Bundle.main.loadNibNamed(clazz, owner: nil, options: nil)
            let view = tmp?.last
            return view ?? nil
        }
        let viewType = (NSClassFromString(clazz)) as! UIView.Type
        return viewType.init()
    }
    
    @objc func setShadow(Color color:UIColor,size:CGSize,borderColor:UIColor) -> UIView{
        self.layer.borderWidth = 0.1
        self.layer.shadowColor = color.cgColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = 0.6
        return self
    }
    
    @objc func setBorderColor(borderColor:UIColor,borderWidth:CGFloat) -> UIView{
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        return self
    }
    
    @objc func setCornerRadius(cornerRadius:CGFloat) -> UIView{
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        return self
    }
    
    @objc func rotate(angle:Float)->UIView{
        if self.responds(to: #selector(getter: layer)){
            print("This view(\(self)) do not have layer property. Can not rotate")
            return self
        }
        self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.2) {
            self.transform = self.transform.rotated(by: CGFloat((Double(angle)*Double.pi)/(180.0)))
        }
        return self
    }
    
    //MARK:删除当前视图的所有子视图
    @objc func removeAllSubviews(){
        while (self.subviews.count != 0){
            let child = self.subviews.last
            child?.removeFromSuperview()
        }
    }
    
    //MARK: 获取当前视图的控制器
    @objc func viewController()->UIViewController?{
        let next = self.superview
        if next != nil {
            let nextResponder = next?.next
            if nextResponder is UIViewController{
                return nextResponder as? UIViewController
            }else{
                let _ = viewController()
            }
        }else{
            let nextResponder = next?.next
            if nextResponder is UIViewController{
                return nextResponder as? UIViewController
            }
        }
        return nil
    }
    
    
    
    
}






