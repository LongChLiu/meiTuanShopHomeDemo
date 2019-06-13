//
//  ReserveEvluateCell.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/23.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit


@objc protocol ReserveEvluateCellDelegate {
    @objc optional func didSelectedPhotoView(cell:ReserveEvluateCell,ImgIndex index:Int)
}



class ReserveEvluateCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //头像
    var headImgView:UIImageView!
    
    //用户名称
    var userNameLab:UILabel!
    
    //评论时间
    var timeLab:UILabel!
    
    //酒店套房类型
    var roomTypeLab:UILabel!
    
    //评价分数
    var gradeLab:UILabel!
    
    //评论内容
    var contentLab:UILabel!
    
    //图片视图
    var photoView:UIView!
    
    //图标
    var topImgView:UIImageView!
    
    //酒店回复视图
    var replyView:UIView!
    
    //酒店回复
    var replyLab:UILabel!
    
    //底部的线
    var lineLab:UILabel!
    
    
    
    var delegate:ReserveEvluateCellDelegate!
    
    
    
    var _model:EvaluateModel! = nil
    var model:EvaluateModel{
        set{
            _model = newValue
            
            gradeLab.text = String.init(format: "%@", _model.totalScore)
            topImgView.isHidden = true
            photoView.isHidden = true
            replyView.isHidden = true
            gradeLab.text = String.init(format: "%.1f", _model.totalScore)
            
            headImgView.kf.setImage(with: URL.init(string: _model.memberHeadUrl), placeholder: UIImage.init(named: "icon_user"), options: nil, progressBlock: { (a:Int64,b:Int64) in
                
            }) { (result) in
                switch result{
                case .success(let value):
                    self.headImgView.image = value.image.drawCircularIcon(imgSize: CGSize.init(width: 24, height: 24), radius: 12)
                case .failure(let error):
                    print(error)
                }
            }
            
            
            userNameLab.text = _model.memberName
            timeLab.text = String.init(format: "%@%@", model.commTime,_model.regular ?? "")
            if self.cellType == 1 {
                timeLab.text = _model.commTime + ""
            }
            
            //评论内容
            let commContent = String.jsonUtils(strValue: model.commContent!)
            var commonContentSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 14), Str: commContent, MaxWidth: kScreenWidth-54)
            contentLab.text = commContent
            
            //是否有图片
            var picList : NSArray = _model!.picList as NSArray
            if commContent.count == 0 {
                contentLab.changeHeight = 0
                photoView.mj_y = contentLab.maxY()
            }else{
                contentLab.changeHeight = commonContentSize.height
                photoView.mj_y = contentLab.maxY() + 6
                
            }
            
            //删除所有图片子视图
            for (_,obj) in photoView.subviews.enumerated() {
                obj.removeFromSuperview()
            }
            
            if picList.count > 0 {
                photoView.isHidden = false
                //图片宽和高
                var pgotoW : CGFloat = 80
                //有图片
                if picList.count <= 3 {
                    //小于等于三张
                    photoView.changeHeight = pgotoW
                }else if (picList.count > 3 && picList.count <= 6){
                    //小于等于6张 大于3张
                    photoView.changeHeight = pgotoW+pgotoW+4
                }else{
                    //大于6张 小于等于9张
                    photoView.changeHeight = pgotoW + pgotoW + pgotoW + 4 + 4
                }
                
                
                for idx in 0..<picList.count{
                    var photoImgView = UIImageView()
                    photoImgView.frame = CGRect.init(x: CGFloat(pgotoW+CGFloat(4)) * CGFloat(idx % 3), y: (pgotoW+CGFloat(4))*CGFloat(idx/3), width: pgotoW, height: pgotoW)
                    if let urlStr:String = (picList[idx] as! NSDictionary).object(forKey: "picUrl") as? String {
                        photoImgView.kf.setImage(with: URL.init(string: urlStr),placeholder: UIImage.init(named: "thumb"))
                        photoImgView.tag = idx + 1
                        photoImgView.isUserInteractionEnabled = true
                        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapPhotoClick(tap:)))
                        photoImgView.addGestureRecognizer(tap)
                        photoView.addSubview(photoImgView)
                    }
                }
            }else{//没图片
                photoView.changeHeight = 0
            }
            
            //是否商家回复了
            let replyContent = String.init(format: "商家回复:%@", String.jsonUtils(strValue: model.replyContent!))
            if replyContent.count > 5 { //有回复
                if picList.count == 0{
                    replyView.mj_y = contentLab.maxY() + 20
                }else{
                    replyView.mj_y = photoView.maxY() + 20
                }
                
                topImgView.isHidden = false
                replyView.isHidden = false
                let replyContentSize = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 14), Str: replyContent, MaxWidth: kScreenWidth-74)
                replyLab.changeHeight = replyContentSize.height
                replyView.changeHeight = replyLab.height() + 20
                topImgView.mj_y = replyView.minY()-8
                
                let replyStr = AppDefaultUtil.returnStringColor(string: replyContent, range: NSMakeRange(5, replyContent.count-5), color: kColor_ReplyColor)
                replyLab.attributedText = replyStr
            }else{
                topImgView.isHidden = true
                replyView.isHidden = true
                replyView.changeHeight = 0
            }
            
            lineLab.mj_y = model.cellHeight - 1
        }
        get{
            return _model
        }
    }
    
    
    
    @objc func tapPhotoClick(tap:UITapGestureRecognizer){
        var tag = tap.view!.tag
        self.delegate.didSelectedPhotoView?(cell: self, ImgIndex: tag)
    }
    
    //1代表店铺优化的评价
    var cellType:Int!
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        //头像
        headImgView = UIImageView.init(frame: CGRect.init(x: 10, y: 22, width: 24, height: 24))
        headImgView.image = UIImage.init(named: "icon_user")?.drawCircularIcon(imgSize: CGSize.init(width: 22, height: 22), radius: 12)
        contentView.addSubview(headImgView)
        
        //用户名称
        userNameLab = UITool.createLabel(CGRect.init(x: 44, y: 18, width: 200, height: 18), UIColor.clear, kColor_darkBlackColor, 14, .left, lines: 1)
        userNameLab.text = "hahahahaha"
        contentView.addSubview(userNameLab)
        
        //时间
        timeLab = UITool.createLabel(CGRect.init(x: 44, y: 36, width: kScreenWidth-80, height: 14), UIColor.clear, kColor_GrayColor, 12, .left, lines: 1)
        timeLab.text = "2017/09/02 厨房清洁 | 上门服务"
        contentView.addSubview(timeLab)
        
        //分数
        let icon_scoring = UIImageView.init(image: kImage_Name("icon-soring"))
        icon_scoring.frame = CGRect.init(x: kScreenWidth-37, y: -1, width: 27, height: 24)
        contentView.addSubview(icon_scoring)
        
        gradeLab = UITool.createLabel(CGRect.init(x: kScreenWidth-37, y: -1, width: 27, height: 17), UIColor.clear, UIColor.white, 12, .center, lines: 1)
        gradeLab.text = "5.0"
        contentView.addSubview(gradeLab)
        
        //评论内容
        let str = "非常好，干净，地理位置好。附近很安静，适合散步。离宝能太古城很近，电视节目也很多。"
        let size = AppMethods.sizeWithFont(UIFont.systemFont(ofSize: 14), Str: str, MaxWidth: kScreenWidth-54)
        contentLab = UITool.createLabel(CGRect.init(x: 44, y: timeLab.maxY()+10, width: kScreenWidth-54, height: size.height+3), .clear, kColor_darkBlackColor, 14, .left, lines: 0)
        contentLab.text = str
        contentView.addSubview(contentLab)
        
        
        photoView = UIView.init(frame: CGRect.init(x: 44, y: contentLab.maxY()+6, width: kScreenWidth-54, height: 0))
        photoView.isUserInteractionEnabled = true
        contentView.addSubview(photoView)
        
        //回复内容
        replyView = UIView.init(frame: CGRect.init(x: 44, y: photoView.maxY()+20, width: kScreenWidth-54, height: 0))
        replyView.clipsToBounds = true
        replyView.backgroundColor = kColor_bgViewColor
        contentView.addSubview(replyView)
        replyLab = UITool.createLabel(CGRect.init(x: 10, y: 10, width: replyView.width()-20, height: 0), kColor_bgViewColor, UIColorFromRGB(0x878787), 14, .left, lines: 0)
        replyView.addSubview(replyLab)
        
        
        //图标
        topImgView = UIImageView.init(image: UIImage.init(named: "arrow_top"))
        topImgView.frame = CGRect.init(x: 44+30, y: replyView.minY()-8, width: 15, height: 8)
        topImgView.isHidden = true
        contentView.addSubview(topImgView)
        
        
        lineLab = UITool.lineLab(CGRect.init(x: 10, y: replyLab.maxY()+10, width: kScreenWidth-10, height: 1))
        lineLab.backgroundColor = kColor_bgHeaderViewColor
        self.contentView.addSubview(lineLab)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

