//
//  TakeawayShopView.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/15.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

/*
 外卖店铺主页
 */

let Titles = ["我的购物车","消息中心"]
let Icons = ["icon-shoppingcart","icon-messagecenter"]
let NavBar_Change_Point = 50



class TakeawayShopView: UIView {
   
    //店铺ID
    var groupId:String! = ""
    
    
    private var _isStopAnimation:Bool = false //是否禁止动画执行
    private var _alpha:CGFloat = 0 //导航条透明度
    private var _styleColor:UIColor! //导航条主题色
    private var _backBT:UIButton! //返回按钮
    private var _searchView:UIView! //搜索视图
    private var _searchLab:UILabel! //搜索文本
    private var _shopModel:NewShopModel! //数据模型
    private var _maxOffset_Y:CGFloat! //从初识位置滑动到顶部与导航条无缝对接，需要的最大距离
    private var _startChange_Y:CGFloat! //开始改变的偏移量
    private var _isCollect:Bool = false //是否已经收藏
    private var _IMG_HEIGHT:Int! //封面的高度
    
    
    private var headerView:UIView! //顶部头视图
    private var shopImgView:UIImageView! //店铺图片视图
    private var infoView:UIView! //店铺信息视图
    private var activityView:UIView! //活动满减视图
    
    
    private var _bottomView:UIView!
    private var bottomView:UIView!{
        set{
            let bottomView = UIView.init(frame: CGRect.init(x: 0, y: 25, width: self.width(), height: 63))
            shopScrollView.addSubview(bottomView)
            bottomView.alpha = 0.0
            _bottomView = bottomView
            //店铺名称
            let shopNameLab =  UITool.createLabel(textColor: kColor_darkBlackColor, kScreenWidth<375 ? Size(18):18, .center)
            shopNameLab.text = _shopModel.shopName
            bottomView.addSubview(shopNameLab)
            shopNameLab.snp.makeConstraints { (make) in
                make.centerX.equalTo(bottomView)
                make.height.equalTo(26)
                make.top.equalTo(0)
            }
            
            //店铺图标
            let shopIcon = UIImageView()
            shopIcon.image = kImage_Name("icon_brd_big")
            bottomView.addSubview(shopIcon)
            shopIcon.snp.makeConstraints { (make) in
                make.right.equalTo(shopNameLab.snp.left).offset(-6)
                make.height.equalTo(16)
                make.centerY.equalTo(shopNameLab)
            }
            
            //店铺认证
            let cerView = self.setShopGradeAndCerView(type: "2")
            bottomView.addSubview(cerView)
            cerView.snp.makeConstraints { (make) in
                make.top.equalTo(shopNameLab.snp.bottom).offset(6)
                make.centerX.equalTo(bottomView)
                make.height.equalTo(18)
                make.width.equalTo(cerView.width())
            }
        }
        get{
            return _bottomView
        }
    }
    
    
    private var shopScrollView:UIScrollView! //最底层的视图 显示满减活动 营业时间等
    
    
    lazy private var productListView:ShopScrollView! = {
        //var productListView = ShopScrollView.init(frame: CGRect.init(x: 0, y: kDefaultNavBarHeight(), width: self.width(), height: self.height()-kDefaultNavBarHeight()), with: self._shopModel, withGroupID: self.groupId, currentVC: self.viewController())
        
        var productListView = ShopScrollView.init(frame: CGRect.init(x: 0, y: kDefaultNavBarHeight(), width: self.width(), height: self.height()-kDefaultNavBarHeight()), shopModel: self._shopModel, groupId: self.groupId, currentVc: self.viewController())
//        productListView?.showsVerticalScrollIndicator = false
//        productListView?.scrollDelegate = self
        
        productListView.showsVerticalScrollIndicator = false
        productListView.scrollDelegate = self
        
        return productListView
    }()
     //商品列表
    
    
    private var navBarView:UIView!
    
    
    init(frame:CGRect,GroupId groupId:String){
       super.init(frame: frame)
        //隐藏状态栏
        _IMG_HEIGHT = Int(Size(150))
        UIApplication.shared.statusBarStyle = .lightContent
        self.backgroundColor = UIColor.white
        self.setupViews()
        self.requestGetProductGroupInfo_new()
        //刷新优惠券
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNewShop), name: NSNotification.Name.init("refreshNewShop"), object: nil)
    }
    
    @objc func refreshNewShop(){//刷新优惠券
        
    }
    
    deinit {//移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: 控制事件
    func moveUpClick(btn:UIButton!){
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            //满减活动的透明度
            weakSelf!.activityView.alpha = 1.0
            //店铺信息的透明度
            weakSelf!.infoView.alpha = 1.0
            //店铺名称和认证的透明度
            weakSelf!.bottomView.alpha = 0.0
            //店铺照片的平移动画
            weakSelf!.shopImgView.mj_x = 10
            weakSelf!._isStopAnimation = false
            weakSelf!.productListView.transform = CGAffineTransform.init(translationX: 0, y: 0) //恢复原位置
        }) { (finish:Bool) in
            //满减活动的透明度
            weakSelf?.activityView.alpha = 1.0
        }
    }
    
    func backAction() -> Void {
        let superVC = self.viewController()
        if bottomView.alpha != 0 {
            self.moveUpClick(btn: nil);return;
        }
        superVC?.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func searchClick(tap:UITapGestureRecognizer){
        //搜索
    }
    
    @objc func btnClick(btn:UIButton){
        var superVc = self.viewController()
        switch btn.tag {
        case 101:
            //搜索
            print("搜索")
        case 102:
            print("必须先登录\n收藏")
        case 103:
            YBPopupMenu.showRely(on: btn, titles: Titles, icons: Icons, menuWidth: 100) { (popupMenu:YBPopupMenu?) in
                popupMenu?.cornerRadius = 2
                popupMenu?.fontSize = 12
                popupMenu?.textColor = kColor_GrayColor
                popupMenu?.arrowWidth = 10
                popupMenu?.arrowHeight = 7
                popupMenu?.itemHeight = 34
                popupMenu?.delegate = self
                popupMenu?.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            }
        default:
            break
        }
    }
    
    
    @objc func getCouponClick(tap:UITapGestureRecognizer){
        //先判断是否登录、必须先登录
    }
    
    @objc func swipeClick(swipe:UISwipeGestureRecognizer){
        self.moveUpClick(btn: nil)
    }
    
    @objc func moveUpTap(tap:UITapGestureRecognizer){
        self.moveUpClick(btn: nil)
    }
    
    //跳转到优惠活动页
    @objc func activityTap(tap:UITapGestureRecognizer){
        
    }
    
    
    //MARK: 顶部视图
    func setHeaderView(){
        //顶部视图
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: CGFloat(_IMG_HEIGHT)))
        headerView.backgroundColor = UIColor.white
        headerView.isUserInteractionEnabled = true
        self.addSubview(headerView);self.headerView = headerView;
        
        //背景封面
        var faceImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: CGFloat(_IMG_HEIGHT)))
        faceImgView.backgroundColor = kColor_ButtonCornerColor
        headerView.addSubview(faceImgView)
        if let picUrl = _shopModel.picUrl{
            faceImgView.kf.setImage(with: URL.init(string: picUrl),placeholder: nil) //店铺背景图片
        }
        
        //模糊效果
        let bvView = FXBlurView.init(frame: faceImgView.bounds)
        bvView.tintColor = UIColor.white //前景颜色
        bvView.isBlurEnabled = true //是否允许模糊、默认YES
        bvView.blurRadius = 10.0 //模糊半径
        bvView.isDynamic = true //动态改变模糊效果
        faceImgView.addSubview(bvView)
        
        //渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.6).cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 1.5)
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: self.width(), height: CGFloat(_IMG_HEIGHT))
        faceImgView.layer.addSublayer(gradientLayer)
        
        //店铺图片
        var shopImgView : UIImageView = UIImageView.init(frame: CGRect.init(x: 10, y: CGFloat(_IMG_HEIGHT)-78, width: 90, height: 90))
        shopImgView.backgroundColor = UIColor.red
        shopImgView.layer.cornerRadius = 4
        shopImgView.layer.shadowColor = kColor_darkGrayColor.cgColor
        shopImgView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        
        shopImgView.layer.shadowOpacity = 0.4 //阴影透明度 默认0
        shopImgView.layer.shadowRadius = 3  //阴影半径 默认3
        
        self.addSubview(shopImgView);self.shopImgView = shopImgView;
        
        if let shopIcon = _shopModel.shopIcon{
            shopImgView.kf.setImage(with: URL.init(string: shopIcon), placeholder: kImage_Name("thumb"), options: nil, progressBlock: nil) { (result) in
                switch result {
                case .success(let value):
                    print("")
                    shopImgView.image = value.image.drawCircularIcon(imgSize: CGSize.init(width: 90, height: 90), radius: 4)
                case .failure(_):
                    print("")
                }
            }
        }
        
    }
    
    
    //MARK:店铺信息视图
    func setShopInfoView(){
        let infoView = UIView.init()
        infoView.frame = CGRect.init(x: shopImgView.maxX()+10, y: shopImgView.minY(), width: self.width()-(shopImgView.maxX()+20), height: 78)
        headerView.addSubview(infoView)
        //店铺图标
        let shopIcon = UIImageView()
        shopIcon.image = kImage_Name("icon_brd_big")
        infoView.addSubview(shopIcon)
        shopIcon.frame = CGRect.init(x: 0, y: 2, width: shopIcon.image!.size.width, height: 16)
        //店铺名称
        let shopNameLab = UITool.createLabel(textColor: UIColor.white, kScreenWidth < 375 ? Size(18) : 18, .left)
        shopNameLab.frame = CGRect.init(x: shopIcon.maxX()+5, y: 0, width: infoView.width()-(shopIcon.maxX()+15), height: 20)
        shopNameLab.text = _shopModel.shopName // 店铺名称
        infoView.addSubview(shopNameLab)
        
        //公告
        let noticeLabel = UITool.createLabel(textColor: UIColor.white, 12, .left)
        noticeLabel.frame = CGRect.init(x: 0, y: shopNameLab.maxY()+8, width: infoView.width(), height: 12)
        
        if let notice = _shopModel.shopNotice,notice.count != 0 {
            noticeLabel.text = String.init(format: "公告:%@",notice)
        }
        
        if let notice = _shopModel.shopNotice,notice.count == 0 {
            noticeLabel.text = String.init(format: "公告:%@", "暂无公告")
        }
        infoView.addSubview(noticeLabel)
        self.infoView = infoView
        
        //认证
        let cerView = self.setShopGradeAndCerView(type: "1")
        cerView.frame = CGRect.init(x: 0, y: infoView.height()-28, width: cerView.width(), height: 18)
        infoView.addSubview(cerView)
        self.bringSubviewToFront(shopImgView)
    }
    
    //MARK: 店铺照片下面的满减活动视图
    func setActivityView(){
        var activityList = _shopModel.activityList
        let activityView = UIView.init(frame: CGRect.init(x: 0, y: _IMG_HEIGHT+12, width: Int(self.width()), height: 36))
        headerView.addSubview(activityView)
        self.activityView = activityView
        if activityList != nil && activityList!.count > 0 {
            let couponListModel : CouponListModel = activityList![0]
            self.activityView = activityView
            
            let iconView = UIImageView.init(frame: CGRect.init(x: 10, y: 11, width: 14, height: 14))
            //1限时折扣、满减、优惠券
            if couponListModel.activeType == "1"{
                iconView.image = kImage_Name("icon-discounts")
            }else if(couponListModel.activeType == "2"){
                iconView.image = kImage_Name("icon-sale")
            }else if(couponListModel.activeType == "3"){
                iconView.image = kImage_Name("icon-coupons")
            }
            activityView.addSubview(iconView)
            //活动名称
            let activityLab = UITool.createLabel(textColor: kColor_TitleColor, 12, .left)
            activityLab.text = couponListModel.activeTitle
            activityLab.frame = CGRect.init(x: iconView.maxX()+10, y: 9, width: self.width()-(iconView.maxX()+10+60), height: 18)
            activityView.addSubview(activityLab)
            
            let nextImgView = UIImageView.init(frame: CGRect.init(x: self.width()-20, y: 13, width: 10, height: 10))
            nextImgView.image = kImage_Name("icon-folding")
            activityView.addSubview(nextImgView)
            //优惠活动数量
            let numLab = UITool.createLabel(textColor: kColor_GrayColor, 10, .right)
            numLab.text = String.init(format: "%ld个优惠", activityList!.count)
            numLab.frame = CGRect.init(x: nextImgView.minX()-45, y: 9, width: 40, height: 18)
            activityView.addSubview(numLab)
        }else{
            //没有活动
            activityView.mj_h = 0
        }
    }
    
    
    //MARK:店铺照片下面的底部视图
    func createDetailInfoView(){
        var max_Y : CGFloat = 0
        shopScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: CGFloat(_IMG_HEIGHT), width: self.width(), height: self.height() - CGFloat(_IMG_HEIGHT)))
        shopScrollView.contentSize = CGSize.init(width: self.width(), height: 1000)
        shopScrollView.showsVerticalScrollIndicator = false
        shopScrollView.bounces = true
        self.addSubview(shopScrollView)
        self.bringSubviewToFront(shopImgView)
        
        //间隔
        let lineLab = UITool.lineLab(CGRect.init(x: 0, y: 88, width: self.width(), height: 10))
        lineLab.backgroundColor = kColor_LightGrayColor
        shopScrollView.addSubview(lineLab)
        
        max_Y = lineLab.maxY()
        
        /*
         优惠券活动
         */
        var couponList = _shopModel.couponList
        if let cnt = couponList?.count,cnt > 0 {
            let couponScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: lineLab.maxY(), width: self.width(), height: 100))
            couponScrollView.showsHorizontalScrollIndicator = false
            shopScrollView.addSubview(couponScrollView)
            
            for idx in 0..<cnt {
                let couponModel : CouponListModel = couponList![idx]
                let couponView = UIView.init(frame: CGRect.init(x: 10+(210+20)*idx, y: 10, width: 210, height: 80))
                couponScrollView.addSubview(couponView)
                //优惠券图片
                let couponImgView = UIImageView()
                couponImgView.frame = couponView.bounds
                couponImgView.tag = 50
                couponImgView.image = kImage_Name("bg_coupon_red")
                if let ori = couponModel.couponNumber,let cnt = Int(ori),cnt <= 0 {
                    couponImgView.image = kImage_Name("bg_coupon_yellow")
                }else{
                    couponImgView.image = nil
                }
                
                couponView.addSubview(couponImgView)
                
                //优惠券价格
                let priceLab = UITool.createLabel(CGRect.init(x: 14, y: 9, width: 100, height: 20), UIColor.clear, UIColorFromRGB(0xFE5A2B), Size(20), .left, lines: 1)
                priceLab.text = String.init(format: "￥%@", couponModel.couponPrice)
                couponView.addSubview(priceLab)
                
                //满多少钱可用
                let moreThanLab = UITool.createLabel(CGRect.init(x: 14, y: 40, width: 100, height: 14), UIColor.clear, UIColorFromRGB(0xFD8F33), 14, .left, lines: 1)
                moreThanLab.text = String.init(format: "满%@可用", couponModel.couponCondition)
                couponView.addSubview(moreThanLab)
                
                //时间
                let timeLab = UITool.createLabel(CGRect.init(x: 14, y: 59, width: 140, height: 10), UIColor.clear, UIColorFromRGB(0xFD8F33), 10, .left, lines: 1)
                let time = ToolManager.returnTime(time: couponModel.couponTime, format: "yyyy.MM.dd HH:mm")
                timeLab.text = String.init(format: "%@前使用", time!)
                couponView.addSubview(timeLab)
                
                //领取
                let getLab = UITool.createLabel(CGRect.init(x: couponView.width()-4-60, y: 0, width: 60, height: 80), UIColor.clear, UIColor.white, 16, .center, lines: 2)
                getLab.text = "立即\n领取"
                if let ori = couponModel.couponNumber,let cnt = Int(ori),cnt <= 0{
                    getLab.text = "已使用"
                }
                getLab.tag = 51;couponView.addSubview(getLab)
                couponScrollView.contentSize = CGSize.init(width: couponView.maxX()+20, height: 100)
                
                let couponTap = UITapGestureRecognizer.init(target: self, action: #selector(getCouponClick(tap:)))
                couponView.tag = idx+100
                couponView.addGestureRecognizer(couponTap)
            }
            
            let lineLab2 = UITool.lineLab(CGRect.init(x: 0, y: couponScrollView.maxY(), width: self.width(), height: 10))
            lineLab2.backgroundColor = kColor_LightGrayColor
            shopScrollView.addSubview(lineLab2)
            
            max_Y = lineLab2.maxY()
        }
        
        
        /*满减活动*/
        var activityList = _shopModel.activityList
        if let cnt = activityList?.count,cnt > 0 {
            //满减活动
            let activityView2 = UIView.init(frame: CGRect.init(x: 0, y: max_Y, width: self.width(), height: 36))
            shopScrollView.addSubview(activityView2)
            for idx in 0..<cnt{
                let couponListModel : CouponListModel = activityList![idx]
                let iconView = UIImageView.init(frame: CGRect.init(x: 10, y: 13+(14+11)*idx, width: 14, height: 14))
                //1.限时折扣  2.满减   3.优惠券
                if couponListModel.activeType == "1"{
                    iconView.image = kImage_Name("icon-discounts")
                }else if couponListModel.activeType == "2"{
                    iconView.image = kImage_Name("icon-sale")
                }else if couponListModel.activeType == "3"{
                    iconView.image = kImage_Name("icon_coupons")
                }
                activityView2.addSubview(iconView)
                
                //活动名称
                let activityLab = UITool.createLabel(textColor: kColor_TitleColor, 12, .left)
                activityLab.text = couponListModel.activeTitle
                activityLab.frame = CGRect.init(x: iconView.maxX()+CGFloat(10), y: CGFloat(15+(12+11)*idx), width: self.width()-(iconView.maxX()+10+60), height: 12)
                activityView2.addSubview(activityLab)
                activityView2.mj_h = activityLab.maxY() + 11
            }
            
            let nextImgView = UIImageView.init(frame: CGRect.init(x: self.width()-20, y: 13, width: 10, height: 10))
            nextImgView.image = kImage_Name("icon_up_black")
            activityView2.addSubview(nextImgView)
            
            let foldingBT = UIControl.init()
            foldingBT.addTarget(self, action: Selector(("moveUpClick:")), for: .touchUpInside)
            foldingBT.frame = CGRect.init(x: activityView2.maxX()-50, y: 0, width: 50, height: activityView2.height())
            activityView2.addSubview(foldingBT)
            
            let lineLab3 = UITool.lineLab(CGRect.init(x: 0, y: activityView2.maxY(), width: self.width(), height: 0.5))
            lineLab3.backgroundColor = kColor_bgHeaderViewColor
            shopScrollView.addSubview(lineLab3)
            
            let activityTap = UITapGestureRecognizer.init(target: self, action: #selector(activityTap(tap:)))
            activityView2.addGestureRecognizer(activityTap)
            max_Y = lineLab3.maxY()
        }
        
        
        //营业时间
        if _shopModel!.openHour == nil || _shopModel.openHour?.count == 0{
            //如果营业时间不存在
        }else{
            let textLab = UITool.createLabel(textColor: kColor_TitleColor, 14, .left)
            textLab.frame = CGRect.init(x: 10, y: max_Y+10, width: self.width(), height: 14)
            shopScrollView.addSubview(textLab)
            textLab.text = "营业时间"
            
            let timeLab = UITool.createLabel(textColor: kColor_GrayColor, 12, .left)
            timeLab.frame = CGRect.init(x: 10, y: textLab.maxY()+10, width: self.width(), height: 12)
            timeLab.text = _shopModel.openHour
            self.shopScrollView.addSubview(timeLab)
            
            max_Y = timeLab.maxY()
        }
        
        //公告
        let noticeLab = UITool.createLabel(textColor: kColor_TitleColor, 14, .left)
        noticeLab.frame = CGRect.init(x: 10, y: max_Y+15, width: 42, height: 14)
        noticeLab.text = "公告:"
        shopScrollView.addSubview(noticeLab)
        
        let contentLab = UITool.createLabel(textColor: kColor_GrayColor, 12, .left)
        contentLab.frame = CGRect.init(x: 10, y: noticeLab.maxY()+10, width: self.width()-20, height: 12)
        shopScrollView.addSubview(contentLab)
        var text = _shopModel.shopNotice
        if text == nil || text?.count == 0{
            text = "暂无公告"
        }
        
        contentLab.text = text
        contentLab.font = kFont(12)
        contentLab.numberOfLines = 0
        contentLab.mj_w = self.width() - (noticeLab.maxX()+20)
        let size = AppMethods.sizeWithFont(kFont(12), Str: text!, MaxWidth: contentLab.mj_w)
        contentLab.mj_h = size.height
        if size.height < 18 {
            contentLab.mj_h = 12
        }
        shopScrollView.contentSize = CGSize.init(width: self.width(), height: contentLab.maxY()+10)
    }
    
    
    func setBottomView(){
        let bottomView = UIView.init(frame: CGRect.init(x: 0, y: 25, width: self.width(), height: 63))
        shopScrollView.addSubview(bottomView)
        bottomView.alpha = 0.0
        _bottomView = bottomView
        //店铺名称
        let shopNameLab = UITool.createLabel(textColor: kColor_darkBlackColor, kScreenWidth<375 ? Size(18):18, .center)
        shopNameLab.text = _shopModel.shopName
        bottomView.addSubview(shopNameLab)
        shopNameLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomView)
            make.height.equalTo(26)
            make.top.equalTo(0)
        }
        
        //店铺图标
        let shopIcon = UIImageView()
        shopIcon.image = kImage_Name("icon_brd_big")
        bottomView.addSubview(shopIcon)
        shopIcon.snp.makeConstraints { (make) in
            make.right.equalTo(shopNameLab.snp.left).offset(-6)
            make.height.equalTo(16)
            make.centerY.equalTo(shopNameLab)
        }
        
        //店铺认证
        let cerView = self.setShopGradeAndCerView(type: "2")
        bottomView.addSubview(cerView)
        cerView.snp.makeConstraints { (make) in
            make.top.equalTo(shopNameLab.snp.bottom).offset(6)
            make.centerX.equalTo(bottomView)
            make.height.equalTo(18)
            make.width.equalTo(cerView.width())
        }
    }
    
    
    //MARK:店铺评分视图
    func setShopGradeAndCerView(type:String) -> UIView {
        let max_X:CGFloat = 0
        let cerView = UIView()
        //店铺评价 分数
        let gradeLab = UITool.createLabel(textColor: UIColorFromRGB(0xFFCD20), kScreenWidth<375 ? Size(18):18,.left)
        let grade = String.init(format: "%@分", "4.9")
        let str = AppDefaultUtil.returnString(string: grade, range: NSMakeRange(grade.count-1, 1), size: 12)
        gradeLab.attributedText = str
        gradeLab.adjustsFontSizeToFitWidth = true
        let gradeSize = AppMethods.sizeWithFont(kFont(12), Str: grade, MaxWidth: 100)
        gradeLab.frame = CGRect(x: max_X, y: 0, width: gradeSize.width+2, height: 18)
        cerView.addSubview(gradeLab)
        //超出预期
        let yuQiLab = UITool.createLabel(textColor: UIColorFromRGB(0xFFCD20), 12, .left)
        yuQiLab.text = ToolManager.returnYuQiType("4.9")
        let yvQiSize = AppMethods.sizeWithFont(kFont(12), Str: yuQiLab.text ?? "", MaxWidth: 100)
        yuQiLab.frame = CGRect(x: gradeLab.maxX()+5, y: CGFloat(4), width: yvQiSize.width+5, height: 14)
        cerView.addSubview(yuQiLab)
        //月售
        let line = UITool.lineLab(CGRect.init(x: yuQiLab.maxX()+8, y: 1, width: 2, height: 16))
        line.backgroundColor = UIColorFromRGB(0xF4F4F4)
        cerView.addSubview(line)
        
        let sellCountLab = UITool.createLabel(textColor: kColor_ButtonCornerColor, 12, .left)
        sellCountLab.text = "月售1088"
        let sellSize = AppMethods.sizeWithFont(kFont(12), Str: sellCountLab.text ?? "", MaxWidth: 100)
        sellCountLab.frame = CGRect(x: line.maxX()+8, y: 2, width: sellSize.width, height: 16)
        cerView.addSubview(sellCountLab)
        cerView.mj_w = sellCountLab.maxX()
        return cerView
    }
    
    
    func moveUpClick(btn:UIButton){
        
        
        
    }
    
    func createMoveUpView(){
        //渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 1.5)
        gradientLayer.frame = CGRect.init(x: 0, y: self.height()-30, width: self.width(), height: 30)
        self.layer.addSublayer(gradientLayer)
        
        let imageView = UIImageView.init()
        imageView.frame = CGRect.init(x: (self.width()-20)/2, y: self.height()-27, width: 20, height: 20)
        imageView.isUserInteractionEnabled = true
        imageView.image = kImage_Name("icon-Slidingback")
        self.addSubview(imageView)
        
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: self.height()-90, width: self.width(), height: 90)
        self.addSubview(view)
        
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeClick(swipe:)))
        swipe.delegate = self
        swipe.direction = .up
        view.addGestureRecognizer(swipe)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(moveUpTap(tap:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func setUpNavBarView(){
        let navBarView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: kDefaultNavBarHeight()))
        navBarView.backgroundColor = UIColor.white.withAlphaComponent(0) //透明度
        self.addSubview(navBarView);self.navBarView = navBarView;
        //返回按钮
        let backBT = UIButton.init(type: .custom)
        backBT.frame = CGRect.init(x: 0, y: 20+kDefaultNavBar_SubView_MinY, width: 54, height: 44)
        backBT.setImage(UIImage.init(named: "icon_back_white"), for: .normal)
        backBT.setImage(UIImage.init(named: "icon_back_white"), for: .highlighted)
        backBT.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBT.setTitleColor(UIColor.white, for: .normal)
        backBT.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        backBT.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        backBT.addTarget(self, action: #selector(backAction(btn:)), for: .touchUpInside)
        navBarView.addSubview(backBT)
        self._backBT = backBT
        
        //搜索框
        let searchView = UIView.init(frame: CGRect.init(x: self.width()-37*4-10, y: CGFloat(20+kDefaultNavBar_SubView_MinY+5+5), width: 37, height: 24))
        searchView.backgroundColor = UIColorFromRGB(0xF4F4F4).withAlphaComponent(0.0)
        navBarView.addSubview(searchView)
        self._searchView = searchView
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(searchClick(tap:)))
        searchView.addGestureRecognizer(tap)
        
        _searchLab = UITool.createLabel(CGRect.init(x: 30, y: 2, width: 120, height: 20), UIColor.clear, kColor_GrayColor, Size(12), .left, lines: 1)
        _searchLab.text = "请输入商品名称"
        searchView.addSubview(_searchLab)
        _searchLab.textColor = kColor_GrayColor.withAlphaComponent(0)
        
        //搜索 信息  收藏  更多
        var imgArray = ["sousuo_white","collect_white","more_white"]
        for idx in 0..<3{
            let itemBT = UIButton.init(type: .custom)
            itemBT.frame = CGRect.init(x: self.width() - CGFloat(37*(3-idx)-5), y: CGFloat(20)+kDefaultNavBar_SubView_MinY+CGFloat(5), width: CGFloat(37), height: CGFloat(34))
            itemBT.setImage(kImage_Name(imgArray[idx]), for: .normal)
            itemBT.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            itemBT.tag = idx+1+1000;
            navBarView.addSubview(itemBT)
            if(idx == 2){
                if(_isCollect){
                    //已经收藏
                    itemBT.setImage(kImage_Name("Already collected"), for: .normal)
                }
            }
            if(idx == 3){
                
            }
        }
    }
    
    func shopCartBtn(){
        
    }
    
    func ybPopupMenuBeganDismiss() {
        
    }
    
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, cellForRowAt index: Int) -> UITableViewCell! {
        let identifierId : String = "customCell"
        var cell:CustomTestCell? = ybPopupMenu.tableView.dequeueReusableCell(withIdentifier: identifierId) as? CustomTestCell
        if cell == nil {
            cell = CustomTestCell.init(style: .default, reuseIdentifier: identifierId)
        }
        cell?.titleLabel.text = Titles[index]
        cell?.iconImageView.image = UIImage.init(named:Icons[index])
        switch index {
        case 0:
            cell?.redLab.isHidden = true
        case 1:
            cell?.redLab.isHidden = true
        default: break
        }
        return cell
    }
    
    @objc func backAction(btn:UIButton){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension TakeawayShopView:YBPopupMenuDelegate{
    
    func ybPopupMenu(_ ybPopupMenu: YBPopupMenu!, didSelectedAt index: Int) {
        //推荐回调
        if index == 0 {
            //购物车
            print("购物车")
        }else{
            //消息中心
            print("消息中心")
        }
    }
    
}



extension TakeawayShopView:ShopScrollViewDelegate{
    
    func listScrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if scrollView == productListView {
            if(offset <= 0 && !_isStopAnimation){
                //满减活动的透明度
                var rate : CGFloat = -offset/30
                if rate >= 1{rate = 1}
                if rate <= 0{rate = 0}
                
                activityView.alpha = 1.0 * (1.0-rate)
                //店铺信息的透明度
                let infoViewRate:CGFloat = -offset/50
                self.infoView.alpha = 1.0*(1.0-infoViewRate)
                //店铺名称和认证的透明度
                var nameRate:CGFloat = -offset/65
                if nameRate >= 1{
                    nameRate = 1
                }
                if(infoView.alpha < 0.5){
                    bottomView.alpha = 1.0*nameRate
                }else{
                    bottomView.alpha = 0
                }
                //店铺照片的平移动画
                let distance = self.width()/2 - 55
                var imgRate = -offset/65
                if imgRate >= 1.0{
                    imgRate = 1.0
                }
                shopImgView.mj_x = imgRate*distance + 10
            }else{
                //满减活动的透明度
                activityView.alpha = 1.0
                //店铺信息的透明度
                infoView.alpha = 1.0
                //店铺名称和认证的透明度
                bottomView.alpha = 0.0
                //店铺照片的平移动画
                shopImgView.mj_x = 10
                _isStopAnimation = false
            }
        }
        self.didScroll(scrollView: scrollView)
    }
    
    func listScrollViewDidEndDragging(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= -80 {
            //如果下滑偏移量小于-80，禁止动画执行
            _isStopAnimation = true
        }else{
            _isStopAnimation = false
        }
    }
    
    
    func listScrollViewDropDown(scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.transform = CGAffineTransform.init(translationX: 0, y: self.height())
            //满减活动的透明度
            self.activityView.alpha = 0.0
            //店铺信息的透明度
            self.infoView.alpha = 0.0
            //店铺照片的平移动画
            let distance:CGFloat = self.width()/2 - 55
            self.shopImgView.mj_x = distance + 10
            self._isStopAnimation = false
        }) { (fnished:Bool) in
            UIView.animate(withDuration: 0.1, animations: {
                //店铺名称和认证的透明度
                self.bottomView.alpha = 1.0
            })
            self.productListView.isStopAnimation = true
            self.productListView.contentOffset = CGPoint.zero
        }
        //导航条恢复原状
        self.navBarState()
    }
    
    //MARK: 导航栏渐变
    func didScroll(scrollView:UIScrollView){
        let offsetY:CGFloat = scrollView.contentOffset.y
        _alpha = offsetY /   CGFloat(_maxOffset_Y)
        if alpha > 1 {alpha = 1}
        if alpha < 0 {alpha = 0}
        
        var alpha2 : CGFloat = 0
        if _alpha >= 0.6 {
            alpha2 = (alpha-0.6)/0.4
        }
        
        if offsetY > CGFloat(NavBar_Change_Point) {
            self.navBarView.backgroundColor = _styleColor.withAlphaComponent(_alpha)
        }else{
            self.navBarView.backgroundColor = _styleColor.withAlphaComponent(0)
        }
        
        let sousuBT:UIButton = navBarView.viewWithTag(1001) as! UIButton
        let collectBT:UIButton = navBarView.viewWithTag(1002) as! UIButton
        let messageBT:UIButton = navBarView.viewWithTag(1003) as! UIButton
        
        let startLoc:CGFloat = self.width()-37*3-5
        let endLoc:CGFloat = _backBT.maxX()
        let distance:CGFloat = startLoc - endLoc
        if (offsetY <= CGFloat(_maxOffset_Y) && offsetY >= 0) {
            //18 x 18
            if(offsetY >= _startChange_Y){
                var imgRate:CGFloat = (offsetY - _startChange_Y)/( CGFloat(_maxOffset_Y)-_startChange_Y)
                if(imgRate >= 1){
                    imgRate = 1
                }
                sousuBT.frame = CGRect.init(x: startLoc-imgRate*distance, y: 20+kDefaultNavBar_SubView_MinY+5, width: 37, height: 34)
                var imgRate2 : CGFloat = imgRate*3.5
                if(imgRate2 >= 1){
                    imgRate2 = 1
                }
                
                if(imgRate2 >= 1){
                    sousuBT.setImage(kImage_Name("icon-search box"), for: .normal)
                }else{
                    sousuBT.setImage(kImage_Name("sousuo_white"), for: .normal)
                }
                
                sousuBT.imageEdgeInsets = UIEdgeInsets.init(top: 8*imgRate2, left: 8*imgRate2, bottom: 8*imgRate2, right: 8*imgRate2)
                _searchView.mj_x = sousuBT.mj_x
                _searchLab.mj_x = 30
                _searchView.backgroundColor = UIColorFromRGB(0xf4f4f4).withAlphaComponent(alpha2)
                if alpha >= 0.8{
                    _searchLab.textColor = kColor_GrayColor.withAlphaComponent(_alpha)
                }else{
                    _searchLab.textColor = kColor_GrayColor.withAlphaComponent(0)
                }
                var sousuoBgRate = (offsetY-_startChange_Y)/(CGFloat(_maxOffset_Y)-_startChange_Y)
                if(sousuoBgRate >= 1){
                    sousuoBgRate = 1
                }
                _searchView.mj_w = distance*sousuoBgRate+37
            }
        }else{
            sousuBT.frame = CGRect.init(x: startLoc, y: 20+kDefaultNavBar_SubView_MinY+5, width: 37, height: 34)
            sousuBT.setImage(kImage_Name("sousuo_white"), for: .normal)
            sousuBT.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            _searchView.backgroundColor = UIColorFromRGB(0xf4f4f4).withAlphaComponent(0)
            _searchView.mj_x = sousuBT.mj_x
            _searchView.mj_w = 37
            _searchLab.mj_x = 30
            _searchLab.textColor = kColor_GrayColor.withAlphaComponent(0)
        }
        
        if (_alpha >= 0.5) {
            _backBT.setImage(kImage_Name("back_grey"), for: .normal)
            messageBT.setImage(kImage_Name("more_grey"), for: .normal)
            collectBT.setImage(kImage_Name("collect_grey"), for: .normal)
        }else{
            _backBT.setImage(kImage_Name("icon_back_white"), for: .normal)
            messageBT.setImage(kImage_Name("more_white"), for: .normal)
            collectBT.setImage(kImage_Name("collect_white"), for: .normal)
        }
        
        if _isCollect {
            //已经收藏
            collectBT.setImage(kImage_Name("Already collected"), for: .normal)
        }
        if _alpha >= 0.8 {
            
        }else{
            
        }
    }
    
    //导航条颜色
    func setupViews(){
        _styleColor = UIColor.white
        if self.navBarView != nil{
            self.navBarView.backgroundColor = _styleColor.withAlphaComponent(0)
        }
    }
    
    func navBarState(){
        let sousuBT:UIButton = navBarView.viewWithTag(1001) as! UIButton
        let collectBT:UIButton = navBarView.viewWithTag(1002) as! UIButton
        let moreBT:UIButton = navBarView.viewWithTag(1003) as! UIButton
        let startLoc:CGFloat = self.width()-37*3-5
        UIView.animate(withDuration: 0.1) {
            self._searchLab.textColor = kColor_GrayColor.withAlphaComponent(0)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navBarView.backgroundColor = self._styleColor.withAlphaComponent(0)
            sousuBT.frame = CGRect.init(x: startLoc, y: 20+kDefaultNavBar_SubView_MinY+5, width: 37, height: 34)
            sousuBT.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            self._searchView.mj_x = sousuBT.mj_x
            self._searchLab.mj_x = 30
            self._searchView.backgroundColor = UIColorFromRGB(0xf4f4f4).withAlphaComponent(0)
            self._searchView.mj_w = 37
            sousuBT.setImage(kImage_Name("sousuo_white"), for: .normal)
            moreBT.setImage(kImage_Name("more_white"), for: .normal)
            collectBT.setImage(kImage_Name("collect_white"), for: .normal)
            if(self._isCollect){
                //已收藏
                collectBT.setImage(kImage_Name("Already collected"), for: .normal)
            }
        }) { (fnish) in
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    //MARK:  店铺详情
    func requestGetProductGroupInfo_new(){
        let dataDict = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "shop.json", ofType: nil)!)
        self.analysisData(dic: dataDict!)
    }
    
    func analysisData(dic:NSDictionary){
        _shopModel = NewShopModel.deserialize(from: dic)
        if let activityList = _shopModel.activityList,activityList.count > 0{
            _maxOffset_Y = ( Size(150) + CGFloat(48) - kDefaultNavBarHeight() )
            _startChange_Y = 21+28
        }else{
            _maxOffset_Y = ( Size(150) + CGFloat(48) - kDefaultNavBarHeight() - CGFloat(28))
            _startChange_Y = 21
        }
        
        
        if let shopModel = _shopModel,let cnt : Int = Int(shopModel.isCollection ?? ""),cnt >= 0{
            _isCollect = true
        }else{
            _isCollect = false
        }
        
        self.setHeaderView() //顶部视图
        self.setShopInfoView() //店铺信息视图
        self.createDetailInfoView() //优惠券、满减活动等信息视图
        self.setBottomView() //认证、店铺评分
        self.setActivityView() //店铺照片下面的满减活动视图
        self.createMoveUpView() //点击按钮弹出滚动视图
        self.setUpNavBarView() //创建导航栏
        //创建滚动视图
        self.addSubview(self.productListView)
    }
}


extension TakeawayShopView:UIGestureRecognizerDelegate{
    //手势 多个手势并存
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
