//
//  TakeawayProductCollectionCell.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/20.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

class TakeawayProductCollectionCell: UICollectionViewCell {
    
    //产品图
    var productImgView:UIImageView!
    //产品标题
    var productNameLabel:UILabel!
    //月售
    var monthlySaleLabel:UILabel!
    //赞
    var fabulousCountLabel:UILabel!
    //价格
    var priceLabel:UILabel!
    //辣度背景
    var spicyBgView:UIView!
    //原价
    var originalPriceLabel:UILabel!
    //折扣
    var discountLabel:UILabel!
    
    
    //网友最爱，新品等产品类型标签
    var classLabel:UILabel!
    var lineView:UIView!
    
    
    //添加按钮
    var addBT:UIButton!
    //数量
    var countLab:UILabel!
    //减少按钮
    var reduceBT:UIButton!
    //选规格
    var specificationBT:UIButton!
    //售罄 or 非可售时间
    var sellOutLab:UILabel!
    //图标
    var warningIcon:UIImageView!
    //增加减少订单数量 需不需要动画效果
    var plusBlock:((_ count:Int,_ animated:Bool)->Void)!
    
    var count:Int! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    func setupViews(){
        count = 0
        productImgView = UIImageView()
        contentView.addSubview(productImgView)
        productImgView.image = UIImage.init(named: "food")
        productImgView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(productImgView.snp.width)
        }
        
        
        //标记
        classLabel = UILabel()
        classLabel.text = "老板推荐"
        classLabel.textColor = UIColor.white
        classLabel.font = kFont(12)
        classLabel.textAlignment = NSTextAlignment.center
        classLabel.backgroundColor = RGB(253, 143, 51)
        contentView.addSubview(classLabel)
        classLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView)
            make.top.equalTo(productImgView)
            make.height.equalTo(18)
        }
        
        
        let str = AppDefaultUtil.returnLineSpacing(Str: "这里是标题20字以内，最多两行，这里标题20字以内，最多两行", lineCount: 4, alignment: .left)
        let size = AppMethods.sizeAttributed(Font: kFont(14), Str: str, MaxWidth: takeawayRight_W-20)
        var height:CGFloat = 20
        if size.height > 20 {
            height = 40
        }
        
        productNameLabel = UILabel()
        productNameLabel.attributedText = str
        productNameLabel.textColor = RGBA(51, 51, 51, 1)
        productNameLabel.font = kFont(14)
        productNameLabel.numberOfLines = 2
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.top.equalTo(productImgView.snp.bottom).offset(7)
            make.right.equalTo(0)
            make.height.equalTo(height)
        }
        
        
        monthlySaleLabel = UILabel()
        monthlySaleLabel.text = "月售121"
        monthlySaleLabel.font = kFontNameSize(fontNameSize: 10)
        monthlySaleLabel.textColor = RGB(102, 102, 102)
        contentView.addSubview(monthlySaleLabel)
        monthlySaleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom)
            make.height.equalTo(10)
        }
        
        
        let lineView = UIView()
        lineView.backgroundColor = RGB(226, 226, 226)
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(monthlySaleLabel.snp.right).offset(6)
            make.centerY.equalTo(monthlySaleLabel)
            make.width.equalTo(1)
            make.height.equalTo(6)
        }
        
        
        fabulousCountLabel = UILabel()
        fabulousCountLabel.text = "赞12"
        fabulousCountLabel.font = kFontNameSize(fontNameSize: 10)
        fabulousCountLabel.textColor = RGB(102, 102, 102)
        contentView.addSubview(fabulousCountLabel)
        fabulousCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(8)
            make.centerY.equalTo(lineView)
        }
        
        spicyBgView = UIView()
        spicyBgView.backgroundColor = UIColor.clear
        contentView.addSubview(spicyBgView)
        spicyBgView.snp.makeConstraints { (make) in
            make.left.equalTo(fabulousCountLabel.snp.right)
            make.centerY.equalTo(fabulousCountLabel)
            make.height.equalTo(10)
            make.width.equalTo(4+2+4+2+4)
        }
        
        
        for idx in 0..<3 {
            let starImgView = UIImageView.init(frame: CGRect.init(x: idx*6, y: 0, width: 4, height: 10))
            starImgView.image = UIImage.init(named: "icon_chili")
            spicyBgView.addSubview(starImgView)
        }
        
        
        //优惠后的价格
        let priceLabel = UILabel()
        priceLabel.text = "￥28"
        priceLabel.font = kFontNameSize(fontNameSize: 14)
        priceLabel.textColor = RGB(246, 90, 66)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(productImgView.snp.bottom).offset(73)
            make.height.equalTo(14)
        }
        
        //优惠活动视图
        let activityView = UIView()
        activityView.backgroundColor = RGB(244, 90, 66)
        contentView.addSubview(activityView)
        activityView.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView)
            make.width.equalTo(productImgView)
            make.bottom.equalTo(productImgView)
            make.height.equalTo(24)
        }
        
        
        originalPriceLabel = UILabel()
        originalPriceLabel.font = kFontNameSize(fontNameSize: 12)
        originalPriceLabel.textColor = UIColor.white
        let oldPrice = "￥12"
        let attri = originalPriceLabel.addDeletingLineWithText(text: oldPrice, DeletingLineColor: UIColor.white)
        originalPriceLabel.attributedText = attri
        activityView.addSubview(originalPriceLabel)
        originalPriceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(activityView)
            make.height.equalTo(14)
            make.right.equalTo(-10)
        }
        
        
        var discountImgView = UIImageView()
        discountImgView.image = UIImage.init(named: "icon_dit_white")
        activityView.addSubview(discountImgView)
        discountImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(activityView)
            make.width.height.equalTo(8)
        }
        
        
        discountLabel = UILabel()
        discountLabel.text = "9折"
        discountLabel.font = kFontNameSize(fontNameSize: 11)
        discountLabel.textColor = UIColor.white
        activityView.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(discountImgView.snp.right).offset(2)
            make.centerY.equalTo(discountImgView)
        }
        
        
        //添加按钮
        addBT = UIButton.init(type: .custom)
        addBT.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        addBT.setImage(kImage_Name("but_add_yellow"), for: .normal)
        addBT.setImage(kImage_Name("but_add_yellow"), for: .highlighted)
        addBT.backgroundColor = UIColor.red
        contentView.addSubview(addBT)
        addBT.tag = 100+1;
        addBT.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.height.equalTo(22)
            make.top.equalTo(productImgView.snp.bottom).offset(68)
        }
        
        //数量
        countLab = UILabel()
        countLab.font = kFontNameSize(fontNameSize: 14)
        countLab.textColor = RGBA(51, 51, 51, 1)
        countLab.text = "11"
        countLab.textAlignment = .center
        countLab.adjustsFontSizeToFitWidth = true
        contentView.addSubview(countLab)
        contentView.snp.makeConstraints { (make) in
            make.centerY.equalTo(addBT)
            make.right.equalTo(addBT.snp.left).offset(0)
            make.width.equalTo(26)
        }
        
        
        //减少按钮
        reduceBT = UIButton.init(type: .custom)
        reduceBT.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        reduceBT.setImage(kImage_Name(""), for: .normal)
        reduceBT.setImage(kImage_Name(""), for: .highlighted)
        reduceBT.backgroundColor = UIColor.red
        contentView.addSubview(reduceBT)
        reduceBT.tag = 100+2
        reduceBT.snp.makeConstraints { (make) in
            make.centerY.equalTo(addBT)
            make.right.equalTo(countLab.snp.left).offset(0)
            make.width.height.equalTo(22)
        }
        
        //选规格
        specificationBT = UIButton.init(type: .custom)
        specificationBT.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        specificationBT.setBackgroundImage(kImage_Name("but_spn_yellow"), for: .normal)
        specificationBT.setBackgroundImage(kImage_Name("but_spn_yellow"), for: .highlighted)
        specificationBT.backgroundColor = UIColor.red
        specificationBT.setTitle("选规格", for: .normal)
        specificationBT.setTitleColor(UIColor.white, for: .normal)
        specificationBT.titleLabel?.font = kFontNameSize(fontNameSize: 12)
        contentView.addSubview(specificationBT)
        specificationBT.tag = 100+3
        specificationBT.snp.makeConstraints { (make) in
            make.top.equalTo(productImgView.snp.bottom).offset(68)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(22)
            make.width.equalTo(48)
        }
        
        //售罄
        sellOutLab = UILabel()
        sellOutLab.font = kFontNameSize(fontNameSize: 12)
        sellOutLab.textColor = kColor_GrayColor
        sellOutLab.text = "非可售时间"
        sellOutLab.textAlignment = .left
        contentView.addSubview(sellOutLab)
        sellOutLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel)
            make.right.equalTo(contentView).offset(-10)
        }
        
        
        
        //非可售时间
        warningIcon = UIImageView()
        warningIcon.image = kImage_Name("")
        contentView.addSubview(warningIcon)
        warningIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel)
            make.width.height.equalTo(16)
            make.right.equalTo(sellOutLab.snp.left).offset(-2)
        }
        
        
        countLab.isHidden = true
        reduceBT.isHidden = true
        specificationBT.isHidden = true
        sellOutLab.isHidden = true
        warningIcon.isHidden = true
    }
    
    
    @objc func btnClick(btn:UIButton){
        switch btn.tag {
        case 1:
            count += 1;
            if count >= 1{
                countLab.isHidden = false
                reduceBT.isHidden = false
            }
            countLab.text = "\(String(describing: count))"
            if self.plusBlock != nil{
                self.plusBlock(count,true)
            }
        case 2:
            count -= 1;
            if count <= 0{
                countLab.isHidden = true
                reduceBT.isHidden = true
            }
            countLab.text = "\(String(describing: count))"
            if self.plusBlock != nil{
                self.plusBlock(count,false)
            }
        case 3:
            //选规格
            print("选规格---------")
        default:
            break
        }
    }
    
    
    func setMaintableCell(model:ShoppingCartOrderListInfo){
        productNameLabel.text = "\(String(describing: model.name))"
        priceLabel.text =   String.init(format: "￥%.2f", Float(model.min_price)!)
        countLab.text = "\(String(describing: model.orderCount))"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
