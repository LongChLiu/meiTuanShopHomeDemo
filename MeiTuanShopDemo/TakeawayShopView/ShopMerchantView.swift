//
//  ShopMerchantView.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/22.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit
import Kingfisher

class ShopMerchantView: UIView {

    @objc var tableView:UITableView! = nil
    //店铺ID
    @objc var groupId:String! = ""
    
    
    @objc var _shopModel:NewShopModel! = nil
    @objc var shopModel:NewShopModel{//数据模型
        set{
            _shopModel = newValue
            self.createView()
        }
        get{
            return _shopModel
        }
    }
    
    //全局变量
    var _scrollView:UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    func createView(){
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: self.height()), style: UITableView.Style.plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.isScrollEnabled = false
        self.tableView.backgroundColor = kColor_LightGrayColor
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorColor = kColor_bgHeaderViewColor
        self.tableView.showsVerticalScrollIndicator = false
        self.addSubview(self.tableView)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension ShopMerchantView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if(section == 1){
            return 1
        }else{
            if (shopModel.openHour == nil || shopModel.openHour?.count == 0) {
                //如果没有营业时间
                return 3
            }
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let cnt = shopModel.shopIntroduce,cnt.count == 0 {
                return 0
            }
            let size = AppMethods.sizeWithFont(kFont(12), Str: shopModel.shopIntroduce ?? "", MaxWidth: self.width())
            return size.height + 30
        }else if(indexPath.section == 1){
            if shopModel.shopPicList != nil && shopModel.shopPicList.count == 0{
                return 0
            }
            return 100
        }else{
            if (indexPath.row == 1){
                let text = shopModel.shopNotice
                let size = AppMethods.sizeWithFont(kFont(12), Str: text ?? "", MaxWidth: self.width()-43)
                let height:CGFloat = size.height + 26
                if height > 44{
                    return size.height + 26
                }
                return 44
            }
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            if shopModel.shopIntroduce != nil && shopModel.shopIntroduce.count == 0{
                return 0.001
            }
        }else if (section == 1){
            if let cnt = shopModel.shopPicList,cnt.count == 0{
                return 0.001
            }
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = kColor_LightGrayColor
        return bgView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID = "cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseID)
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseID)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
            cell?.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            if indexPath.section == 0{
                //店铺介绍
                let introduceLab = UITool.createLabel(textColor: kColor_GrayColor, 12, .left)
                introduceLab.numberOfLines = 0
                let size:CGSize = AppMethods.sizeWithFont(kFont(12), Str: shopModel.shopIntroduce ?? "", MaxWidth: self.width())
                introduceLab.text = shopModel.shopIntroduce
                introduceLab.frame = CGRect.init(x: 10, y: 10, width: self.width()-20, height: size.height+10)
                cell?.contentView.addSubview(introduceLab)
            }else if (indexPath.section == 1){
                //相册集
                _scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: 100))
                _scrollView.showsHorizontalScrollIndicator = false
                cell?.contentView.addSubview(_scrollView)
                var maxW:CGFloat = 0
                let shopPicList:NSArray = shopModel.shopPicList ?? []
                for idx in 0..<shopPicList.count{
                    let dic:NSDictionary = shopPicList[idx] as! NSDictionary
                    var imgView:UIImageView = UIImageView.init(frame: CGRect.init(x: 10+(80+20)*idx, y: 10, width: 80, height: 80))
                    _scrollView.addSubview(imgView)
                    
                    if let str:String = dic["picUrl"] as? String {
                        imgView.kf.setImage(with: URL.init(string: str),placeholder: kImage_Name("thumb"))
                    }
                    imgView.tag = 10010+idx
                    maxW = imgView.maxX()
                    imgView.isUserInteractionEnabled = true
                    imgView.clipsToBounds = true
                    imgView.contentMode = .scaleAspectFill
                    let tap = UITapGestureRecognizer.init(target: self, action: #selector(checkPhotoClick(tap:)))
                    imgView.addGestureRecognizer(tap)
                }
                _scrollView.contentSize = CGSize.init(width: maxW+10, height: 80)
                if maxW + 10 < self.width(){
                    _scrollView.contentSize = CGSize.init(width: self.width(), height: 80)
                }
            }else if (indexPath.section == 2){
                //icon图标
                let icon_loc = UIImageView()
                icon_loc.backgroundColor = UIColor.red
                icon_loc.frame = CGRect.init(x: 10, y: 13, width: 18, height: 18)
                cell?.contentView.addSubview(icon_loc)
                
                //                
                let textLab = UITool.createLabel(textColor: kColor_TitleColor, 14, .left)
                textLab.frame = CGRect.init(x: 33, y: 13, width: self.width()-120, height: 18)
                cell?.contentView.addSubview(textLab)
                
                
                if(indexPath.row == 0){
                    icon_loc.image = kImage_Name("icon-address")
                    textLab.text = shopModel.shopAddress
                    
                    let line = UILabel()
                    line.backgroundColor = kColor_LightGrayColor
                    line.frame = CGRect.init(x: self.width()-75, y: 12, width: 1, height: 20)
                    cell?.contentView.addSubview(line)
                    //电话
                    let icon_phone = UIImageView()
                    icon_phone.image = kImage_Name("icon-telephone")
                    icon_phone.frame = CGRect.init(x: line.maxX()+28, y: 13, width: 18, height: 18)
                    icon_phone.contentMode = .scaleAspectFit
                    icon_phone.backgroundColor = .red
                    icon_phone.isUserInteractionEnabled = true
                    cell?.contentView.addSubview(icon_phone)
                    
                    let phoneView = UIView.init(frame: CGRect.init(x: self.width()-75, y: 0, width: 75, height: 44))
                    cell?.contentView.addSubview(phoneView)
                    
                    let tap = UITapGestureRecognizer.init(target: self, action: #selector(callPhoneClick(tap:)))
                    phoneView.addGestureRecognizer(tap)
                    
                }else if(indexPath.row == 1){
                    
                    icon_loc.image = kImage_Name("icon-announcement")
                    var text = shopModel.shopNotice
                    if text?.count == 0 || text != nil{
                        text = "暂无公告"
                    }
                    
                    textLab.text = text
                    textLab.font = kFont(12)
                    textLab.numberOfLines = 0
                    textLab.mj_w = self.width() - 43
                    let size = AppMethods.sizeWithFont(kFont(12), Str: text ?? "", MaxWidth: textLab.mj_w)
                    textLab.mj_h = size.height
                    if size.height < 18{
                        textLab.mj_h = 18
                    }
                    
                }else if(indexPath.row == 2){
                    if shopModel.openHour == nil || shopModel.openHour?.count == 0{
                        //如果没有营业时间  2区间
                        icon_loc.image = kImage_Name("icon-idcard")
                        textLab.text = "营业资质"
                        cell?.accessoryView = UIImageView.init(image: kImage_Name("icon_next"))
                    }else{
                        icon_loc.image = kImage_Name("icon-footprint")
                        textLab.text = "营业时间: \(String(describing: shopModel.openHour))"
                    }
                }else{
                    //2区间
                    icon_loc.image = kImage_Name("icon-idcard")
                    textLab.text = "营业资质"
                    cell?.accessoryView = UIImageView.init(image: kImage_Name( "icon_next"))
                }
            }
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            _ = self.viewController()
            if indexPath.row == 0{
                //位置、经纬度、百度地图
            }else if(indexPath.row == 3){
                //营业资质
                
            }else if(indexPath.row == 2){
                
            }
        }
    }
    
    
    @objc func checkPhotoClick(tap:UITapGestureRecognizer){
        let imgView:UIImageView = tap.view as! UIImageView
        //展示图片浏览器 （Cell 模式）
        let browser:SDPhotoBrowser = SDPhotoBrowser()
        let shopPicList = shopModel.shopPicList
        browser.sourceImagesContainerView = _scrollView
        browser.imageCount = shopPicList!.count
        browser.currentImageIndex = imgView.tag - 10010
        browser.delegate = self
        browser.show()
    }
    
}



//MARK: SDPhotoBrowserDelegate 图片浏览器
extension ShopMerchantView:SDPhotoBrowserDelegate{
    
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {//图片的高清图片地址
        let shopPicList = shopModel.shopPicList
        let dic:NSDictionary = shopPicList?[index] as! NSDictionary
        if let picUrl : String = dic["picUrl"] as? String {
            let url = URL.init(string: picUrl)
            return url
        }
        return nil
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {//返回占位图
        let shopPicList = shopModel.shopPicList
        let dic:NSDictionary = shopPicList?[index] as! NSDictionary
        if let picURL : String = dic["picUrl"] as? String {
            return KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: picURL)
        }
        return nil
    }
    
    
    @objc func callPhoneClick(tap:UITapGestureRecognizer){
        if let telNum:String = "tel://\(String(describing: shopModel.telnumber))",let telUrl:URL = URL.init(string: telNum){
            UIApplication.shared.open(telUrl, options:[:], completionHandler: nil)
        }
    }
    
}


