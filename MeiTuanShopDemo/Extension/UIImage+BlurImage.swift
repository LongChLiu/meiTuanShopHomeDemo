//
//  UIImage+BlurImage.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/10.
//  Copyright © 2019 艺教星. All rights reserved.
//

import Foundation
import UIKit
import Accelerate


extension UIImage{
    
    
    /*
     产生模糊图片
     @param radius 模糊半径
     @param iterations 迭代次数
     @param tintColor 前景色
     
     @return 图片
     */
    func blurredImage(Radius radius:CGFloat,iterations:UInt,tintColor:UIColor)->UIImage{
        //image must be nonzero size
        if floor(Float(self.size.width)) * floorf(Float(self.size.height)) <= 0.0 {
            return self
        }
        
        //boxsize must be an odd integer
        var boxSize:UInt32 = UInt32(radius * self.scale)
        if boxSize % 2 == 0 {boxSize += 1;}
        
        //create image buffers
        var imageRef = self.cgImage
        var buffer1:vImage_Buffer!
        var buffer2:vImage_Buffer!
        
        var buffer1WH = vImage_Buffer.init();
        buffer1WH.width = vImagePixelCount(imageRef!.width)
        buffer1WH.height = vImagePixelCount(imageRef!.height)
        
        buffer1.width = buffer1WH.width;buffer2.width = buffer1WH.width;
        buffer1.height = buffer1WH.height;buffer2.height = buffer1WH.height;
        
        buffer1.rowBytes  = imageRef!.bytesPerRow
        buffer2.rowBytes = imageRef!.bytesPerRow
        
        let bytes = buffer1.rowBytes * Int(buffer1.height)
        buffer1.data = malloc(bytes)
        buffer2.data = malloc(bytes)
        
        //create temp buffer
        let tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, nil, 0, 0, boxSize, boxSize,
                                                           nil, vImage_Flags(kvImageEdgeExtend + kvImageGetTempBufferSize)));
        //copy image data
        let dataSource = imageRef?.dataProvider?.data
        memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
        for _ in 0..<iterations {
            //perform blur
            vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, nil, vImage_Flags(kvImageEdgeExtend))
            //swap buffers
            let temp = buffer1.data
            buffer1.data = buffer2.data
            buffer2.data = temp
        }
        
        //create image context from buffer
        let ctx =  CGContext(data: buffer1.data, width: Int(buffer1!.width), height: Int(buffer1!.height),
                             bitsPerComponent: 8, bytesPerRow: buffer1.rowBytes, space: imageRef!.colorSpace!,
                             bitmapInfo: (imageRef?.bitmapInfo)!.rawValue);
        
        //apply tint
        if tintColor != nil && tintColor.cgColor.alpha > 0.0 {
            ctx!.setFillColor(tintColor.withAlphaComponent(0.25).cgColor);
            ctx?.setBlendMode(CGBlendMode.plusLighter)
            ctx?.fill(CGRect.init(x: 0, y: 0, width: imageRef!.width, height: imageRef!.height))
        }
        
        //create image from context
        imageRef = ctx!.makeImage();
        let image = UIImage.init(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    
    //改变图片的透明度
    func imageByApplying(alpha:CGFloat,image:UIImage) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.setBlendMode(.multiply)
        ctx?.setAlpha(alpha)
        ctx!.draw(image.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    
    //MARK: 根据颜色生成图片
    class func image(Color color:UIColor,aFrame:CGRect)->UIImage!{
        let aFrame0 = CGRect.init(x: 0, y: 0, width: aFrame.size.width, height: aFrame.size.height)
        
        UIGraphicsBeginImageContext(aFrame0.size);
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(aFrame0)
        
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
    //MARK:修改图片的大小
    class func changeSizeByOrigin(image:UIImage,scaleToSize size:CGSize) -> UIImage!{
        UIGraphicsBeginImageContext(size) //size CGSize结构体类型 值类型  所需要的图片尺寸
        image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage! //返回的就是已经改变的图片
    }
    
    
    //MARK: 保存图片在沙盒  仅仅支持PNG、JPG、JPEG
    /*
     @Param image 传入的图片
     @param imgName 图片的命名
     @param imgType 图片格式
     @param directoryPath 图片存放的路径
     */
    func saveImg(image:UIImage,imgName:String,imgType:String,directoryPath:String){
        if imgType.lowercased() == "png" {
            let path = directoryPath.appending("\(imgName).\(imgType)")
            //返回一个PNG图片
            (image.pngData()! as NSData).write(toFile: path, atomically: true)
        }else if imgType.lowercased() == "jpg" || imgType.lowercased() == "jpeg" {
            let path = directoryPath.appending("\(imgName).\(imgType)")
            //第二个参数压缩质量 0最大的压缩  1最小的压缩质量
            (image.jpegData(compressionQuality: 1.0)! as NSData).write(toFile: path, atomically: true)
        }else{
            //不支持该图片格式
            print("不支持该图片格式")
        }
    }
    
    /*
     获取图片上指定点上的颜色
     @param point 图片上的一点
     @return 颜色
     */
    func getImageColorOnPoint(point:CGPoint)->UIColor{
        let bitmapData = self.cgImage!.dataProvider!.data
        let data = CFDataGetBytePtr(bitmapData)!;
        //图片的宽度乘以点的y值所到所在行的位置 再加上点x值即可得到该点的颜色
        //两者都乘以4的原因是每一个像素点都占据四个字节的长度 依次分别是RGBA 即红色、绿色、蓝色值和透明值
        let index:Int = Int(4*self.size.width*point.y+4*point.x)
        
        let color = UIColor.init(red: CGFloat(data[index])/255.0, green: CGFloat(data[index+1])/255.0, blue: CGFloat(data[index+2])/255.0, alpha: CGFloat(data[index+3])/255.0)
        for i in 0..<4 {
            print("\(data[index+i])")
        }
        return color
    }
    
    
    /*
     绘制一张图片 图片是由一个圆环包着的
     @param color 圆环的颜色
     @param imgSize 图片的size
     @return 图片
     */
    func drawCirclularIcon(color:UIColor,sizeOfImg imgSize:CGSize)->UIImage{
        let lineWidth:CGFloat = 4
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 1.0)
        let currentContext = UIGraphicsGetCurrentContext()
        //绘制颜色 和 圆形
        currentContext?.addArc(center: CGPoint.init(x: imgSize.width*0.5, y: imgSize.height*0.5), radius: imgSize.width*0.5-lineWidth, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        color.set()
        currentContext?.setLineWidth(lineWidth)
        currentContext?.strokePath()
        //将图片绘制进去
        let imageW = imgSize.width
        let imageH = imgSize.height
        let imageX = (imgSize.width*0.5 - imageW*0.5)
        //从中心点出发计算其坐标
        let imageY = (imgSize.height*0.5 - imageH*0.5)
        self.draw(in: CGRect.init(x: imageX, y: imageY, width: imageW, height: imageH))
        
        let returnImg = UIGraphicsGetImageFromCurrentImageContext()
        //从上下文
        UIGraphicsEndImageContext()
        return returnImg!
    }
    
    
    /*
     绘制带有圆弧的图片
     */
    func drawCircularIcon(imgSize:CGSize,radius:CGFloat) -> UIImage{
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(imgSize, false, 0.0)
        //获取绘制圆的半径 宽 高的一个区域
        let width = imgSize.width
        let height = width
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        //使用UIBerierPath路径裁切 注意：先设置裁切路径，再绘制图像
        let berzierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: radius)
        //添加到裁切路径
        berzierPath.addClip()
        //将图片绘制到裁切好的区域内
        self.draw(in: rect)
        //从上下文获取当前 绘制成圆形的图片
        let resImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        return resImage!
    }
    
    
    
    
    func getMostColor() -> UIColor? {
        //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
        let thumbSize = CGSize(width: 50, height: 50)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: nil, width: Int(thumbSize.width), height: Int(thumbSize.height), bitsPerComponent: 8, bytesPerRow: Int(thumbSize.width * 4), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        let drawRect = CGRect(x: 0, y: 0, width: thumbSize.width, height: thumbSize.height)
        
        context?.draw(cgImage!, in: drawRect)
        //第二步 取每个点的像素值
        let data : UnsafeMutablePointer<CUnsignedChar>? = context?.data as? UnsafeMutablePointer<CUnsignedChar>? ?? nil
        if data == nil {
            return nil
        }
        
        let cls: NSCountedSet? = Set<AnyHashable>() as? NSCountedSet
        
        for x in 0 ..< Int(thumbSize.width) {
            for y in 0 ..< Int(thumbSize.height) {
                let offset: Int = 4 * (x * y)
                let red = Int(data![offset])
                let green = Int(data![offset + 1])
                let blue = Int(data![offset + 2])
                let alpha = Int(data![offset + 3])
                
                let clr = [NSNumber(value: red), NSNumber(value: green), NSNumber(value: blue), NSNumber(value: alpha)]
                //将透明度小于0.1的过滤掉
                if alpha < 20 {
                    continue
                }
                //过滤白色
                if red > 230 && green > 230 && blue > 230 {
                    continue
                }
                //过滤黑色
                if red < 30 && green < 30 && blue < 30 {
                    continue
                }
                cls?.add(clr)
            }
        }
        
        //第三步 找到出现次数最多的那个颜色
        let enumerator: NSEnumerator? = cls?.objectEnumerator()
        var curColor: [Any]? = nil
        var MaxColor: [Any]? = nil
        var MaxCount: Int = 0
        while (curColor = enumerator?.nextObject() as? [Any]) != nil {
            var tmpCount: Int? = nil
            if let curColor = curColor {
                tmpCount = cls?.count(for: curColor)
            }
            if (tmpCount ?? 0) < MaxCount {
                continue
            }
            MaxCount = tmpCount ?? 0
            MaxColor = curColor
        }
        return UIColor(red: CGFloat(Double((MaxColor![0] as? NSNumber)!.intValue) / 255.0), green: CGFloat(Double((MaxColor?[1] as? NSNumber)!.intValue) / 255.0), blue: CGFloat(Double((MaxColor?[2] as? NSNumber)!.intValue) / 255.0), alpha: CGFloat(Double((MaxColor?[3] as? NSNumber)!.intValue) / 255.0))
    }
    
    
    
    /*
     根据图片绘制一张带圆环的图片
     param size 绘制之后图片的大小
     Return 图片
     */
    func headerWithTorusBySize(size:CGSize)->UIImage?{
        //头像圆环的宽度
        let lineWidth:CGFloat = 5
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let currentCG = UIGraphicsGetCurrentContext()
        //画出裁剪范围  为圆形
        currentCG?.setLineWidth(lineWidth)
        currentCG?.addArc(center: CGPoint.init(x: size.width*0.5, y: size.width*0.5), radius: size.width*0.5-lineWidth, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: false)
        currentCG?.clip()
        
        //绘入图片
        let thisImg = UIImage.changeSizeByOrigin(image: self, scaleToSize: size)
        thisImg?.drawAsPattern(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        //绘入圆环
        UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7).set()
        currentCG?.addArc(center: CGPoint.init(x: size.width*0.5, y: size.height*0.5), radius: size.width*0.5-lineWidth, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: false)
        currentCG?.strokePath()
        //保存图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    
    
    
    
    
    
    
}

