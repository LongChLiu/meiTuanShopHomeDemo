//
//  TakeawayProductListCell.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/16.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit
import SnapKit


class TakeawayProductListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

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
    //网友最爱 新品等产品类型
    var classImgView:UIImageView!
    //辣度背景
    var spicypBgView:UIView!
    //原价
    var originalPriceLabel:UILabel!
    //折扣
    var discountLabel:UILabel!
    
    var lineView:UIView!
    
    //添加按钮
    var addBT:UIButton!
    //数量
    var countLab:UILabel!
    //减少按钮
    var reduceBT:UIButton!
    //选规格
    var specificationBT:UIButton!
    //售罄
    var sellOutLab:UILabel!
    //图标
    var warningIcon:UIImageView!
    
    
    var _count:Int = 0//数据
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    
    func setupViews(){
        _count = 0;
        productImgView = UIImageView()
        contentView.addSubview(productImgView)
        productImgView.image = UIImage.init(named: "food")
        productImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.height.equalTo(86)
        }
        
        productNameLabel = UILabel()
        productNameLabel.text = "这里是商品的名称"
        productNameLabel.textColor = RGBA(51, 51, 51, 1)
        productNameLabel.font = kFontNameSize(fontNameSize: 14)
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView.snp.right).offset(10)
            make.top.equalTo(productImgView)
            make.right.equalTo(-10)
            make.height.equalTo(14)
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
            make.left.equalTo(monthlySaleLabel.snp.right)
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
        
        spicypBgView = UIView()
        spicypBgView.backgroundColor = UIColor.clear
        contentView.addSubview(spicypBgView)
        spicypBgView.snp.makeConstraints { (make) in
            make.left.equalTo(fabulousCountLabel.snp.right)
            make.centerY.equalTo(fabulousCountLabel)
            make.height.equalTo(10)
            make.width.equalTo(4+2+4+2+4)
        }
        
        for idx in 0..<3 {
            let starImgView = UIImageView.init(frame: CGRect.init(x: idx*6, y: 0, width: 4, height: 10))
            starImgView.image = UIImage.init(named: "icon_chili")
            spicypBgView.addSubview(starImgView)
        }
        
        classImgView = UIImageView()
        classImgView.image = kImage_Name("lab_like")
        contentView.addSubview(classImgView)
        classImgView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(monthlySaleLabel.snp.bottom)
            make.height.equalTo(14)
            make.width.equalTo(classImgView.image!.size.width)
        }
        
        priceLabel = UILabel()
        priceLabel.text = "￥28"
        priceLabel.font = kFontNameSize(fontNameSize: 14)
        priceLabel.textColor = RGB(246, 90, 66)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(classImgView.snp.bottom).offset(18)
            make.height.equalTo(14)
        }
        
        originalPriceLabel = UILabel()
        originalPriceLabel.font = kFontNameSize(fontNameSize: 12)
        originalPriceLabel.textColor = RGB(153, 153, 153)
        let oldPrice:String = "￥12"
        let attri = originalPriceLabel.addDeletingLineWithText(text: oldPrice, DeletingLineColor: RGB(153, 153, 153))
        originalPriceLabel.attributedText = attri
        contentView.addSubview(originalPriceLabel)
        originalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(priceLabel.snp.right).offset(6)
            make.centerY.equalTo(priceLabel)
            make.height.equalTo(14)
        }
        
        let discountImgView = UIImageView()
        discountImgView.image = UIImage.init(named: "icon_dit")
        contentView.addSubview(discountImgView)
        discountImgView.snp.makeConstraints { (make) in
            make.left.equalTo(originalPriceLabel.snp.right)
            make.centerY.equalTo(originalPriceLabel)
            make.top.equalTo(originalPriceLabel)
            make.width.height.equalTo(8)
        }
        
        discountLabel = UILabel()
        discountLabel.text = "9折"
        discountLabel.font = kFontNameSize(fontNameSize: 11)
        discountLabel.textColor = RGB(253, 143, 51)
        contentView.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(discountImgView.snp.right).offset(6)
            make.centerY.equalTo(discountImgView)
        }
        
        //添加按钮
        addBT = UIButton.init(type: .custom)
        addBT.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        addBT.setImage(kImage_Name("but_add_yellow"), for: UIControl.State.normal)
        addBT.setImage(kImage_Name("but_add_yellow"), for: UIControl.State.highlighted)
        addBT.backgroundColor = UIColor.red
        contentView.addSubview(addBT)
        addBT.tag = 100+1;
        addBT.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.height.equalTo(22)
            make.top.equalTo(classImgView.snp.bottom).offset(10)
        }
        
        //数量
        countLab = UILabel()
        countLab.font = kFontNameSize(fontNameSize: 14)
        countLab.textColor = RGBA(51, 51, 51, 1)
        countLab.text = "11"
        countLab.textAlignment = .center
        countLab.adjustsFontSizeToFitWidth = true
        contentView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(addBT)
            make.right.equalTo(addBT.snp.left).offset(0)
            make.width.equalTo(26)
        }
        
        
        //减少按钮
        reduceBT = UIButton.init(type: UIButton.ButtonType.custom)
        reduceBT.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        reduceBT.setImage(kImage_Name("but_reduce"), for: UIControl.State.normal)
        reduceBT.setImage(kImage_Name("but_reduce"), for: UIControl.State.highlighted)
        reduceBT.backgroundColor = UIColor.red
        contentView.addSubview(reduceBT)
        reduceBT.tag = 100+2
        reduceBT.snp.makeConstraints { (make) in
            make.centerY.equalTo(addBT)
            make.right.equalTo(countLab.snp.left).offset(0)
            make.width.height.equalTo(22)
        }
        
        //选规格
        specificationBT = UIButton.init(type: UIButton.ButtonType.custom)
        specificationBT.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        specificationBT.setBackgroundImage(kImage_Name("but_spn_yellow"), for: UIControl.State.normal)
        specificationBT.setBackgroundImage(kImage_Name("but_spn_yellow"), for: UIControl.State.highlighted)
        specificationBT.backgroundColor = UIColor.red
        specificationBT.setTitle("选规格", for:UIControl.State.normal)
        specificationBT.setTitleColor(UIColor.white, for: UIControl.State.normal)
        specificationBT.titleLabel?.font = kFontNameSize(fontNameSize: 12)
        contentView.addSubview(specificationBT)
        specificationBT.tag = 100+3
        specificationBT.snp.makeConstraints { (make) in
            make.top.equalTo(classImgView.snp.bottom).offset(10)
            make.right.equalTo(-10)
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
            make.right.equalTo(-10)
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
            //增加
            _count += 1;
            if _count >= 1{
                countLab.isHidden = false
                reduceBT.isHidden = false
            }
            countLab.text = "\(_count)"        
        case 2:
            _count -= 1;
            if _count <= 0{
                self.countLab.isHidden = true
                self.reduceBT.isHidden = true
            }
            countLab.text = "\(_count)"
        case 3:
        //选规格
            print("选规格")
        default:
            break
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
