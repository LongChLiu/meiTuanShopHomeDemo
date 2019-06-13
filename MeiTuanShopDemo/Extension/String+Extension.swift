//
//  String+Extension.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/13.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation
import UIKit



extension String{
    
    static func price(sign:CGFloat) -> String{
        return String.init(format: "￥%.2f", sign)
    }
    
    static func priceWithoutSign(_ value:CGFloat)->String{
        return String.init(format: "￥%.2f", value)
    }
    
    
    static func jsonUtils(strValue:Any) -> String{
        var string : String? = "\(strValue)"
        if string == "<null>" {
            string = ""
        }
        if string == nil {
            string = ""
        }
        if string == "(null)" {
            string =  ""
        }
        if string == "<null>" {
            string = ""
        }
        if string == "" {
            string = ""
        }
        if string?.count == 0 {
            string = ""
        }
        return string!
    }
    
    static func jsonUtils22(str:Any) -> String{
        var string:String? = "\(str)"
        if string == "<null>" {
            string = "0"
        }
        if string == nil {
            string = "0"
        }
        if string == "(null)" {
            string = "0"
        }
        if string == "" {
            string = "0"
        }
        if string?.count == 0 {
            string = "0"
        }
        return string!
    }
    
    
    static func stringUtils(strValue:Any)->String{
        var string:String? = "\(strValue)"
        
        if string == "<null>" {
            string = ""
        }
        if string == nil {
            string = ""
        }
        if string == "(null)" {
            string = ""
        }
        if string?.count == 0 {
            string = ""
        }
        return string!
    }
    
    //判断字符串是否为空
    func isBlank()->Bool{
        if self == nil || self.count == 0 {
            return true
        }
        let trimedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimedString.count == 0 {
            return true
        }else{
            return false
        }
    }
    
    //判断字符串是否为空
    func isEmpty()->Bool{
        return self is NSNull || self.count == 0 || self == nil || self == "(null)" || self == "<null>"
    }
    
    
    static func isEmpty(strValue:Any)->Bool{
        if let str : String = strValue as? String{
            if str == "" || str == "<null>" || str == "(null)" || str.trimmingCharacters(in: CharacterSet.whitespaces) == "" {
                return false
            }
        }
        return false
    }
    
    func isNULL()->Bool{
        return self is NSNull
    }
    
    //把手机号第4-7位变成星号
    static func photoNumToAsterisk(phoneNum:String)->String{
        if phoneNum.count >= 7 {
            return (phoneNum as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****")
        }
        return phoneNum
    }
    
    //把邮箱@前面变成星号
    static func emailToAsterisk(email:String)->String{
        let arr = email.components(separatedBy: "@")
        let str = arr[0]
        return (email as NSString).replacingCharacters(in: NSMakeRange(str.count, email.count - str.count), with: "****")
    }
    
    //把身份证号第11-14位变成星号
    static func idCardToAsterisk(idCardNum:String) -> String{
        return (idCardNum as NSString).replacingCharacters(in: NSMakeRange(10, 4), with: "****")
    }
    
    //邮箱验证
    static func validateEmail(email:String)->Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate.init(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    //判断字符串是否含有表情  系统键盘有问题
    static func stringContainsEmoji(_ str: String?) -> Bool {
        var returnValue = false
        if let string = str {
            
            (string as NSString).enumerateSubstrings(in: NSRange(location: 0, length: string.count), options: .byComposedCharacterSequences, using: { substring, substringRange, enclosingRange, stop in
                
                let hs = unichar((substring! as NSString).character(at: 0))
                if 0xd800 <= hs && hs <= 0xdbff {
                    if substring!.count > 1 {
                        let ls = unichar((substring! as NSString).character(at: 0))
                        let uc = (Int((hs - 0xd800)) * 0x400) + Int((ls - 0xdc00)) + 0x10000
                        if 0x1d000 <= uc && uc <= 0x1f77f {
                            returnValue = true
                        }
                    }
                } else if (substring?.count ?? 0) > 1 {
                    let ls = unichar((substring! as NSString).character(at: 1))
                    if ls == 0x20e3 {
                        returnValue = true
                    }
                } else {
                    if 0x2100 <= hs && hs <= 0x27ff {
                        returnValue = true
                    } else if 0x2b05 <= hs && hs <= 0x2b07 {
                        returnValue = true
                    } else if 0x2934 <= hs && hs <= 0x2935 {
                        returnValue = true
                    } else if 0x3297 <= hs && hs <= 0x3299 {
                        returnValue = true
                    } else if hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 {
                        returnValue = true
                    }
                }
                
            })
        }
        return returnValue
    }
    
    
    //Vindor标识符 （IDFV-identifierForVentor）
    static func returnIdfy()->String{
        let idfv:String = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return idfv
    }
    
    //手机号验证
    static func validateMobile(mobile:String) -> Bool{
        //手机号以13，15，18开头， 八个 \d 数字开头
        let phoneRegex = "^((13[0-9])|(14[0-9])|(15[^4,\\D])|(16[0-9])|(17[0-9])|(18[0,0-9]|(19[0-9])))\\d{8}$"
        let phoneTest = NSPredicate.init(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: mobile)
    }
    
    //固话验证
    static func validateAreaTel(areaTel:String) -> Bool{
        let phoneRegex = "^((0\\d{2,3})-)(\\d{7,8})(-(\\d{3,}))?$"
        let phoneTest = NSPredicate.init(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: areaTel)
    }
    
    //获取拼音首字母(传入汉字字符串，返回大写拼音首字母)
    static func firstCharactor(aString:String) -> String{
        //转成了可变字符串
        let str = NSMutableString.init(string: aString)
        //先转换为带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        //再转换为不带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        //转化为大写拼音
        let pinYin = str.capitalized
        //获取并返回首字母
        return (pinYin as NSString).substring(to: 1)
    }
    
    
    /*
     功能： 获取指定范围的字符串
     参数： 字符串的开始下标
     参数： 字符串的结束下标
     */
    static func getString(str:String,value1:Int,value2:Int)->String{
        return (str as NSString).substring(with: NSMakeRange(value1, value2))
    }
    
    /*
     功能：判断是否在地区码内
     参数： 地区码
     */
    static func areaCode(codeStr:String) -> Bool{
        
        let dic = NSMutableDictionary.init()
        dic["11"] = "北京"
        dic["12"] = "天津"
        dic["13"] = "河北"
        dic["14"] = "山西"
        dic["15"] = "内蒙古"
        dic["21"] = "辽宁"
        dic["22"] = "吉林"
        dic["23"] = "黑龙江"
        dic["31"] = "上海"
        dic["32"] = "江苏"
        dic["33"] = "浙江"
        dic["34"] = "安徽"
        dic["35"] = "福建"
        dic["36"] = "江西"
        dic["37"] = "山东"
        dic["41"] = "河南"
        dic["42"] = "湖北"
        dic["43"] = "湖南"
        dic["44"] = "广东"
        dic["45"] = "广西"
        dic["46"] = "海南"
        dic["50"] = "重庆"
        dic["51"] = "四川"
        dic["52"] = "贵州"
        dic["53"] = "云南"
        dic["54"] = "西藏"
        dic["61"] = "陕西"
        dic["62"] = "甘肃"
        dic["63"] = "青海"
        dic["64"] = "宁夏"
        dic["65"] = "新疆"
        dic["71"] = "台湾"
        dic["81"] = "香港"
        dic["82"] = "澳门"
        dic["91"] = "国外"
        
        if dic.object(forKey: codeStr) == nil {
            return false
        }
        
        return true
    }
    
    
    /*
     功能：验证身份证是否合法
     参数: 输入的身份证号
     */
    static func validateCard(idCard:String)->Bool{
        //判断位数
        if idCard.count < 15 || idCard.count > 18{
            return false
        }
        
        var carid = idCard
        var lSumQT : CLong = 0
        //加权因子
        var R = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]
        //校验码
        var sChecker = ["1","0","X", "9", "8", "7", "6", "5", "4", "3", "2"];
        
        //将15位身份证号转换成18位
        let mString = NSMutableString.init(string: idCard)
        if idCard.count == 15 {
            mString.insert("19", at: 6)
            
            var p:CLong = 0
            let pid = mString.utf8String
            for idx in 0...16{
                p += Int((pid![idx]-48)) * Int(R[idx])
            }
            
            let o = p % 11
            let string_content = "\(sChecker[o])"
            mString.insert(string_content, at: mString.length)
            carid = mString as String
        }
        //判断地区
        let sProvince:String = (carid as NSString).substring(to: 2)
        
        if String.areaCode(codeStr: sProvince) == false {
            return false
        }
        
        //判断年月日是否有效
        //年份、月份、日
        let strYear = Int(self.getString(str: carid, value1: 6, value2: 4))!
        let strMonth = Int(self.getString(str: carid, value1: 10, value2: 2))!
        let strDay = Int(self.getString(str: carid, value1: 12, value2: 2))!
        
        let localZone = NSTimeZone.local
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = localZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date:Date? = dateFormatter.date(from: "\(strYear)-\(strMonth)-\(strDay)")
        
        if date == nil {return false}
        
        let paperId = carid.utf8CString
        //检验长度
        if (18 != paperId.count) {
            return false;
        }
        //校验数字
        for i in 0..<18 {
            if isdigit(Int32(paperId[i])) == 0  && !(( CChar("X") == CChar(paperId[i]) || CChar("x") == CChar(paperId[i])) && 17 == i)  {
                return false
            }
        }
        //验证最末的校验码
        for idx in 0...16{
            lSumQT += CLong((paperId[idx] - 48) * Int8(R[idx]))
        }
        if ( Int(sChecker[lSumQT%11])! != paperId[17]) {
            return false
        }
        
        return true
    }
    
    
    
    //通过文本宽度计算高度
    func calculateSize(font:UIFont,width:CGFloat)->CGSize{
        let size = CGSize.init(width: width, height: 1000)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle]
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
        return CGSize.init(width: rect.size.width, height: rect.size.height)
    }
    
    //重写containsString方法，兼容8.0以下版本
    func containsString(aString:String) -> Bool{
        if aString.isBlank() {
            return false
        }
        if((self as NSString).range(of: aString).location != NSNotFound  ){
            return true
        }
        return false
    }
    
    //json数组转换成字符串
    static func jsonString(array:NSArray)->String{
        let reString = NSMutableString()
        reString.append("[")
        var values = NSMutableArray()
        for(idx,obj) in array.enumerated(){
            var value = String.jsonString(object: obj)
            if value != nil{
                values.add("\(value)")
            }
        }
        reString.appendFormat("%@", values.componentsJoined(by: ","))
        reString.append("]")
        return reString as String
    }
    
    //json对象转换成字符串
    static func jsonString(object:Any) -> String{
        var value : NSString? = nil
        if object == nil {
            return value! as String;
        }
        if object is String{
            value = self.jsonString(string: object as! String) as NSString
        }else if object is Dictionary<String, Any> || object is NSDictionary{
            value = self.jsonString(dic: object as! NSDictionary) as NSString
        }else if object is NSArray || object is [String]{
            value = String.jsonString(array: object as! NSArray) as NSString
        }
        return value! as String
    }
    
    //字典转成字符串
    static func jsonString(dic:NSDictionary)->String{
        var jsonString : String = ""
        var error:NSError! = nil
        let data:Data! = try! JSONSerialization.data(withJSONObject: dic, options:JSONSerialization.WritingOptions.prettyPrinted)
        if data == nil {
            
        }else{
            jsonString = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        }
        return jsonString
    }
    
    static func jsonString(string:String)->String{
        let str = string.replacingOccurrences(of: "\n", with: "\\n").replacingOccurrences(of: "\"", with: "\\\"")
        return String.init(format: "\"%@\"", str)
    }
    

    //MARK:字符串转成字典
    static func dicWithString(str:String?)->Dictionary<String, Any>?{
        if str == nil {return nil}
        let jsonData = str?.data(using: String.Encoding.utf8)
        do{
            let dic = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers)
            return dic as? Dictionary<String, Any>
        }catch{
            print("json解析失败")
        }
        return nil
    }
    
    
    static func urlEncodedString(_ urlString: String?) -> String? {
        let encodedString = urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "!$&'()*+,-./:;=?@_~%#[]"))
        
        //let encodedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, urlString as CFString?, "!$&'()*+,-./:;=?@_~%#[]" as CFString?, nil, CFStringBuiltInEncodings.UTF8.rawValue) as String?
        return encodedString
    }
    
    
    //自己下载速度这种 可以直接在接受数据的地方加统计
    //获取全局的数据 可以监控网卡的进出流量
    //获取网络流量信息
    
    
    
    static func disable_emoji(text:String) ->String{
        let regex = try! NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options:NSRegularExpression.Options.caseInsensitive)
        let modifiedString = regex.replaceMatches(in: text as! NSMutableString, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, text.count), withTemplate: "")
        return "\(modifiedString)"
    }
    
    
    //计算缓存大小
    static func getCacheSize()->String{
        //定义变量存储总的缓存大小
        var sumSize:CGFloat = 0
        
        //获取当前图片缓存路径
        let cacheFilePath = NSHomeDirectory().appending("Library/Caches")
        //创建文件管理对象
        let fileManager = FileManager.default
        //获取当前缓存路径下的所有子路径
        let subPaths = try! fileManager.subpathsOfDirectory(atPath: cacheFilePath)
        
        //遍历所有子文件
        for (_,obj) in subPaths.enumerated(){
            //拼接完整路径
            let filePath = cacheFilePath.appendingFormat("/%@", obj)
            //计算文件的大小
            let fileSize = try! fileManager.attributesOfItem(atPath:filePath)[FileAttributeKey.size]
            //加载到文件的大小
            sumSize += fileSize as! CGFloat
        }
        
        let size_m = sumSize / (1024*1024)
        //SDWebImage框架自身计算缓存的实现
        return String.init(format: "%.2fM", size_m)
    }
    
    
    //根据正则 过滤特殊字符
    static func filterCharacter(str:String,regexStr:String) -> String{
        let searchText : String = str
        let regex = try! NSRegularExpression.init(pattern: regexStr, options:NSRegularExpression.Options.caseInsensitive)
        let result = regex.stringByReplacingMatches(in: searchText, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, searchText.count), withTemplate: "")
        return result
    }
    
    
    //有效数字
    func yw_isValidateDecimalsNum()->Bool{
        var isValid : Bool = true
        let len : Int = self.count
        if len > 0 {
            let numberRegex = "^[-+]?[0-9]*\\.?[0-9]*$"
            let numberPredicate = NSPredicate.init(format: "SELF MATCHES %@", numberRegex)
            isValid = numberPredicate.evaluate(with: self)
        }
        return isValid
    }
    
    //判断全字母
    func inputShouldLetter(inputStr:String) -> Bool{
        if inputStr.count == 0 {
            return false
        }
        let regex = "[a-zA-Z]*"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: inputStr)
    }
    
    //判断仅仅输入字母或数字
    func inputShouldLetterOrNum(inputStr:String)->Bool{
        if inputStr.count == 0 {
            return false
        }
        let regex = "[a-zA-Z0-9]"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: inputStr)
    }
    
    func sizeWithFont(font:UIFont,maxSize:CGSize) -> CGSize{
        let attribute = [NSAttributedString.Key.font:font]
        return (self as NSString).boundingRect(with: maxSize, options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attribute, context: nil).size
    }
    
    
    static func setLabelSpace(label:UILabel,textStr:String,font:UIFont,lineSpacing:Int){
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        paraStyle.alignment = NSTextAlignment.left
        paraStyle.lineSpacing = CGFloat(lineSpacing) //设置行间距
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0
        paraStyle.tailIndent = 0
        let dic = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paraStyle,NSAttributedString.Key.kern:0.0] as [NSAttributedString.Key : Any]
        
        let attributeStr = NSAttributedString.init(string: textStr, attributes: dic)
        label.attributedText = attributeStr
    }
    
    
    
    static func getSpaceLabelHeight(textStr:String,font:UIFont,width:CGFloat,lineSpacing:Int) -> CGFloat{        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        style.alignment = NSTextAlignment.left
        
        if lineSpacing != 0 {
            style.lineSpacing = CGFloat(lineSpacing)
        }else{
            style.lineSpacing = 0
        }
        
        
        let string = NSAttributedString.init(string: textStr, attributes:[NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:style])
        let size = string.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
        let height = ceil(size.height) + 1
        return height
    }
    
    
}



