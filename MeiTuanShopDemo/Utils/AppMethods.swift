//
//  AppMethods.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/4/28.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

class AppMethods: NSObject {
    
    class func printJsonData(jsonData:Data){
        if let str = String.init(data: jsonData, encoding: String.Encoding.utf8){
            debugPrint("json Str: %@", separator: str, terminator: "\n")
        }
    }
    
    @objc class func createImage(_ color:UIColor)->UIImage?{
        UIGraphicsBeginImageContext(CGSize.init(width: 20, height: 20))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: 20, height: 20))
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), resizingMode: UIImage.ResizingMode.stretch) ?? nil
    }
    
    @objc class func createImage(_ color:UIColor,_ size:CGSize) -> UIImage?{
        UIGraphicsBeginImageContext(CGSize.init(width: size.width, height: size.height))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), resizingMode: UIImage.ResizingMode.stretch)
    }
    
    @objc class func createImageColor22(_ color:UIColor)->UIImage?{
        UIGraphicsBeginImageContext(CGSize.init(width: 20, height: 30))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: 20, height: 30))
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5), resizingMode: UIImage.ResizingMode.stretch)
    }
    
    
    //MARK: mark - 颜色相关
    @objc class func colorWithHexString(color:String,_ alpha:CGFloat) -> UIColor{
        
        var cString : NSString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        // String should be 6 or 8 characters
        
        if cString.length < 6 {return UIColor.clear}
        
        //strip 0X if it appears
        if cString.hasPrefix("0X") {
            cString = cString.substring(from: 2) as NSString
        }
        if cString.hasPrefix("#") {
            cString = cString.substring(from: 1) as NSString
        }
        if cString.length != 6 {
            return UIColor.clear
        }
        
        //Separate into r,g,b substrings
        var range = NSRange.init();range.location = 0;range.length = 2;
        
        //r
        let rString = cString.substring(with: range)
        //g
        range.location = 2;
        let gString = cString.substring(with: range)
        //b
        range.location = 4
        let bString = cString.substring(with: range)
        
        //Scan values
        var r: CUnsignedInt = 0
        var g: CUnsignedInt = 0
        var b: CUnsignedInt = 0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    class func colorWithHexString(_ color:String)->UIColor{
        return AppMethods.colorWithHexString(color: color, 1.0)
    }
    
    //MARK: 计算字符串宽高
    class func sizeWithFont(_ font:UIFont,Str str:String,MaxWidth maxWidth:CGFloat)->CGSize{
        let attribute = [NSAttributedString.Key.font:font]
        let strSize = (str as NSString).boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: attribute, context: nil).size
        return strSize
    }
    
    class func sizeAttributed(Font font:UIFont,Str str:NSMutableAttributedString,MaxWidth maxWidth:CGFloat) -> CGSize{
        let strSize = str.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
        return strSize
    }
    
    class func getImageDataBase64(image:UIImage)->String{
        var imageData:Data! = nil
        //图片要压缩的比例 此处100根据要求 自行设置
        var x = 100 / image.size.height
        if x > 1 {
            x = 1.0
        }
        imageData = image.jpegData(compressionQuality: x)
        let str = imageData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return "data:image/png;base64,".appendingFormat("%@", str)
    }
    
    
    //MARK:银行卡账号形式转换
    //正常号转银行卡号 - 增加4位间的空格
    class func normalNumToBankNum(normal:String?)->String{
        if let normalStr = normal,normalStr.count != 0{
            var tempStr = AppMethods.bankNumToNormalNum(bankNum: normalStr)
            let size = tempStr.count / 4;
            let tmpStrArr = NSMutableArray();
            
            for idx in 0..<size{
                tmpStrArr.add((tempStr as NSString).substring(with: NSMakeRange(idx*4, 4)));
            }
            tmpStrArr.add((tempStr as NSString).substring(with: NSMakeRange(size*4, (tempStr.count % 4))))
            
            tempStr = tmpStrArr.componentsJoined(by: " ");
            //去掉前后的空格
            if tempStr.hasPrefix(" ") || tempStr.hasSuffix(" ") == true{
                tempStr = tempStr.trimmingCharacters(in: CharacterSet.whitespaces)
            }
            return tempStr
        }
        return ""
    }
    
    //银行卡号转正常号 - 去除4位间的空格
    class func bankNumToNormalNum(bankNum:String) -> String {
        return bankNum.replacingOccurrences(of: " ", with: "")
    }
    
    class func bankNumToSecret(bankNum:String) -> String {
        if bankNum.count < 8{
            return bankNum
        }
        var star : String = ""
        for _ in 0 ..< (bankNum.count - 8) {
            star = star + "*"
        }
        let tmpStr = (bankNum as NSString).replacingCharacters(in: NSMakeRange(4, bankNum.count-8), with: star)
        return tmpStr;
    }
    
    //MARK: 通过 parentId 筛选  城市或区(县)
    class func filterAreaFromAreaArray(areaArray:[Any],parentId:Int)->[Any]{
        let pred = NSPredicate.init(format: "parentId == %@", parentId)
        let resultArray = (areaArray as NSArray).filtered(using: pred)
        return resultArray;
    }
    
    //MARK:通过parentNo 筛选 分类
    class func filterClassFromAreaArray(areaArray:NSArray,parentNo:String) -> NSArray{
        let pred = NSPredicate.init(format: "parentNo == %@", parentNo)
        let resultArray = areaArray.filtered(using: pred)
        return resultArray as NSArray
    }
    
    //MARK: 限制只能输入数字输入
    class func validateNumber(number:NSString)->Bool{
        var res:Bool = true
        let tempSet = NSCharacterSet.init(charactersIn: "0123456789")
        var i = 0;
        while i < number.length {
            let string:NSString = number.substring(with: NSMakeRange(i, 1)) as NSString
            let range = string.rangeOfCharacter(from: tempSet as CharacterSet)
            if range.length == 0 {
                res = false;break;
            }
            i+=1;
        }
        return res;
    }
    
    
    //MARK:压缩图片
    class func compressImage(image:UIImage)->UIImage?{
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let width:CGFloat = 640
        let height = image.size.height/(image.size.width/width);
        
        let widthScale = imageWidth/width;
        let heightScale = imageHeight/height;
        
        //创建一个bitmap的context
        //并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        
        if widthScale > heightScale {
            image.draw(in: CGRect.init(x: 0, y: 0, width: imageWidth/heightScale, height: height))
        }else{
            image.draw(in: CGRect.init(x: 0, y: 0, width: width, height: imageHeight/widthScale))
        }
        
        //从当前context中创建一个改变大小后的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        //使用当前的context出堆栈
        UIGraphicsEndImageContext()
        return newImage;
    }
    
    //MARK:除去emoji表情的方法
    class func disable_EmojiString(text:NSString)->String{
        //去除表情规则
        let expression = try! NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive);
        let result = expression.stringByReplacingMatches(in: text as String, options: [NSRegularExpression.MatchingOptions.init(rawValue: 0)], range: NSMakeRange(0, text.length), withTemplate: "")
        return result;
    }
    
    //MARK: 去除非中文的方法
    class func disable_Non_CineseString(text:String)->String{
        let expression = try! NSRegularExpression.init(pattern: "[^\\u4e00-\\u9fa5]", options: NSRegularExpression.Options.caseInsensitive);
        let result = expression.stringByReplacingMatches(in: text, options:NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, text.count), withTemplate: "")
        return result;
    }
    
    //MARK: 判断沙盒文件是否存在
    class func fileExistingWithFileName(fileName:String)->Bool{
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsPath = path[0]
        let plistPath = documentsPath.appending(fileName)
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: plistPath)
    }
    
    //MARK:正则匹配用户密码6-18位数字和字母组合
    class func checkPassword(password:String) -> Bool{
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: password)
        return isMatch
    }
    
    //MARK: 正则只能输入数字和字母
    class func checkTeshuZifuNumber(CheJiaNumber:String) -> Bool{
        let bankNum  = "^[A-Za-z0-9]+$"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", bankNum)
        let isMatch = pred.evaluate(with: CheJiaNumber)
        return isMatch
    }
    
    class func nullDefaultString(fromString:String,nullStr:String) -> String{
        if fromString == "" || fromString == "(null)" || fromString == "<null>" || fromString == "null" || fromString == nil {
            return nullStr;
        }else{
            return fromString;
        }
    }
    
    //判断字符串为空或只为空格
    class func isBlankString(str:String)->Bool{
        if str is String == false || str is NSString == false || str == nil{
            return true
        }
        if str.count == 0 {
            return true
        }
        if str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return true
        }
        if str.lowercased() == "(null)" || str.lowercased() == "null" || str.lowercased() == "<null>" {
            return true
        }
        return false
    }
    
    class func getMoneyStringWithMoneyNumber(money:Double)->String?{
        let numberFormatter = NumberFormatter.init()
        //设置格式
        numberFormatter.positiveFormat = "###,##0.00;"
        let formattedNumberString = numberFormatter.string(from: NSNumber.init(value: money))
        return formattedNumberString
    }
    
    class func connectedTogether(string:String)->String{
        var str = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) //去除掉首尾的空白字符和换行字符
        str = (str as NSString).replacingOccurrences(of: "\r", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        return str
    }
    
}
