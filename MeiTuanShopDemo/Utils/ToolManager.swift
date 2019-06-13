//
//  ToolManager.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/4/30.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit



//直接传入精度丢失有问题的Double类型
func decimalNumberWithDouble(conversion:Double)->String{
    let doubleString = "\(conversion)"
    let decNumber = NSDecimalNumber.init(string: doubleString)
    return decNumber.stringValue
}




class ToolManager: NSObject {
    
    class func chineseWithInteger(interger:Int)->String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber.init(integerLiteral: interger));
        return string ?? nil
    }
    
    class func returnBreakfastType(breakfastType:String)->String{
        var string = ""
        switch Int(breakfastType) {
        case 0:
            string = "无早";break;
        case 1:
            string = "双早";break;
        case 2:
            string = "三早";break;
        case 3:
            string = "四早";break;
        case 4:
            string = "单早";break;
        default:
            break;
        }
        return string
    }
    
    func returnCancelType(cancel:String) -> String{
        var string = ""
        switch Int(cancel) {
        case 1:
            string = "不可取消";break;
        case 2:
            string = "限时取消";break;
        case 3:
            string = "免费取消";break;
        default:
            break
        }
        return string
    }
    
    func returnRoomType(roomType:String,timeString:String) -> String{
        var string = ""
        switch Int(roomType) {
        case 1:
            string = "\(timeString) | 公寓";
            break;
        case 2:
            string = "\(timeString) | 经济连锁";
            break;
        case 3:
            string = "\(timeString) | 其它";
            break;
        case 4:
            string = "\(timeString) | 舒适型";
            break;
        case 5:
            string = "\(timeString) | 高档型";
            break;
        case 6:
            string = "\(timeString) | 豪华型";
            break;
        default:
            break;
        }
        return string
    }
    
    class func returnYuQiType(_ YuQiType:String) -> String{
        var string:String = ""
        if ( Float(YuQiType)!  >= 4.8 ) {
            string = "超出预期"
        }else if ( Float(YuQiType)!  >= 4.5 &&  Float(YuQiType)!  <= 4.8 ) {
            string = "极好"
        }else if ( Float(YuQiType)!  >= 4.0 && Float(YuQiType)! < 4.5 ) {
            string = "不错"
        }else if ( Float(YuQiType)!  >= 3.0 && Float(YuQiType)! < 4.0 ) {
            string = "一般"
        }else if ( Float(YuQiType)!  >= 2.0 && Float(YuQiType)! < 3.0) {
            string = "较差"
        }else if ( Float(YuQiType)!  > 4.8 ) {
            string = "很差"
        }
        return string
    }
    
    class func URLDecodedString(str:String) -> String{
        let decodedStr = CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, str as CFString,"" as CFString?)
        return decodedStr! as String
    }
    
    class func returnTime(time:String,format:String)->String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: time)
        let timeString = date?.string(Format: format)
        return timeString
    }
    
    //MARK:返回APP图标
    func returnIconImage()->Data{
        var infoPlist:[String:Any]? = Bundle.main.infoDictionary
        let icon = (infoPlist!["CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] as! [Any]).last
        let image = UIImage.init(named: icon! as! String)
        let data = image?.pngData()
        return data!
    }
    
    
    func createNonInterpolatedUIImage(With text:String,Size size:CGFloat) -> UIImage{
        //1.实例化二维码滤镜
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        //2.恢复滤镜的默认属性
        filter?.setDefaults()
        //3.将字符串转换成Data
        let urlStr = text
        let data = urlStr.data(using: String.Encoding.utf8)
        //4.通过KVO设置滤镜inputMessage数据
        filter?.setValue(data, forKey: "inputMessage")
        //5.获得滤镜输出的图像
        let outputImage:CIImage? = filter?.outputImage
        //6.CIImage转换成UIImage,并放大显示.  此时获得的二维码比较模糊 所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码
        let codeImage = ToolManager.createNonInterpolatedUIImageFormCIImage(img: outputImage!, size: size)
        return codeImage
    }
    
    
    
    //MARK: 公用方法   通过字符串返回颜色
    class func getColor(colorValue:String,alphaValue:CGFloat) -> UIColor{
        
        var rf  : UInt32 = 0
        var gf  : UInt32 = 0
        var bf  : UInt32 = 0
        
        if colorValue.count == 6 {
            
            let cString:NSString = colorValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
            let subStr0:NSString = (cString as NSString).substring(with: NSMakeRange(0, 2)) as NSString
            let subStr1:NSString = (cString as NSString).substring(with: NSMakeRange(2, 2)) as NSString
            let subStr2:NSString = (cString as NSString).substring(with: NSMakeRange(4, 2)) as NSString
            
            _ = Scanner.init(string: subStr0 as String).scanHexInt32(&rf)
            _ = Scanner.init(string: subStr1 as String).scanHexInt32(&gf)
            _ = Scanner.init(string: subStr2 as String).scanHexInt32(&bf)
            
        }else if colorValue.count == 8{
            
            let cString = colorValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
            let subStr0 = (cString as NSString).substring(with: NSMakeRange(2, 2))
            let subStr1 = (cString as NSString).substring(with: NSMakeRange(4, 2))
            let subStr2 = (cString as NSString).substring(with: NSMakeRange(6, 2))
            
            Scanner.init(string: subStr0).scanHexInt32(&rf)
            Scanner.init(string: subStr1).scanHexInt32(&gf)
            Scanner.init(string: subStr2).scanHexInt32(&bf)
        }
        
        return UIColor.init(red: CGFloat(rf)/255.0, green: CGFloat(gf)/255.0, blue: CGFloat(bf)/255.0, alpha: alphaValue)
    }
    
    
    /*
     根据CIImage生成指定大小的UIImage
     @param image CIImage
     @param size 图片宽度
     */
    class func createNonInterpolatedUIImageFormCIImage(img:CIImage,size:CGFloat)->UIImage{
        let extent = img.extent.integral
        let scale =  Double.minimum(Double(size/extent.width), Double(size/extent.height))
        //1.创建bitmap
        let width = extent.width * CGFloat(scale)
        let height = extent.height * CGFloat(scale)
        let cs = CGColorSpaceCreateDeviceGray()
        
        let bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0);
        let context = CIContext.init(options: nil)
        let bitmapImage = context.createCGImage(img, from: extent)
        bitmapRef?.interpolationQuality = CGInterpolationQuality.none
        bitmapRef?.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
        bitmapRef?.draw(bitmapImage!, in: extent)
        //保存bitmap到图片
        let scaledImage = bitmapRef!.makeImage();
        return UIImage.init(cgImage: scaledImage!);
    }
    
    
    

}
