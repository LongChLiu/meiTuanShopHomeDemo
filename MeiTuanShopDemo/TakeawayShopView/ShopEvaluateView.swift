//
//  ShopEvaluateView.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/23.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit
import Kingfisher


class ShopEvaluateView: UIView {

    @objc var tableView:UITableView!
    var groupId:String! //店铺ID
    
    //私有全局变量
    var _evluateLastIndex:Int = 0//上次点击的索引值
    var _evaluateType:Int = 0 //评价类型、推荐、一般、不满意
    var _currPage:Int = 0//页数索引
    var _count:Int = 0 //总共多少条数据
    var _dataArray:[EvaluateModel] = [EvaluateModel]() //数据源数组
    var _selectedIndex:Int = 0 //被选中图片所在的cell索引
    
    //上拉加载相关
    var _loadView:UIActivityIndicatorView!
    var _isLoading:Bool = false //是否正在加载
    var _gestureEnd:Bool = false //手势是否已经结束
    var _isMoreThan:Bool = false
    var _noDateLab:UILabel!//无数据显示
    
    
    //私有属性
    
    
    var _evluateItemView:UIView! = nil
    var evluateItemView:UIView {
        set{
        
        }
        get{
            if _evluateItemView == nil {
                let evluateItemView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: 40))
                _evluateItemView = evluateItemView
                evluateItemView.backgroundColor = UIColor.white
                let array = ["全部","推荐(0)","一般(0)","不满意(0)"]
                let percents = [0.2,0.25,0.25,0.30]
                let content_w = self.width() - 45 - 30
                var max_X = 10
                for idx in 0..<array.count{
                    let btn = UIButton.init(type: .custom)
                    btn.setTitleColor(UIColor.white, for: .normal)
                    btn.setTitle(array[idx], for: .normal)
                    btn.backgroundColor = kColor_ButtonCornerColor
                    btn.titleLabel?.font = kFont(12)
                    btn.layer.cornerRadius = 10
                    btn.layer.masksToBounds = true
                    btn.tag = 10010+idx
                    btn.addTarget(self, action: #selector(evluateItemClick(btn:)), for: UIControl.Event.touchUpInside)
                    let btnW:CGFloat = CGFloat(percents[idx])
                    btn.frame = CGRect.init(x: max_X, y: 15, width: Int(content_w*btnW), height: 20)
                    max_X = Int(btn.maxX()+15)
                    if idx == 0{
                        self.evluateItemClick(btn: btn)
                    }
                    evluateItemView.addSubview(btn)
                }
                let line = UITool.lineLab(CGRect.init(x: 0, y: 39, width: self.width(), height: 1))
                line.backgroundColor = kColor_bgHeaderViewColor
                evluateItemView.addSubview(line)
            }
            return _evluateItemView
        }
    }
    
    
    //推荐 一般  有图
    @objc func evluateItemClick(btn:UIButton){
        if let lastBT:UIButton = _evluateItemView.viewWithTag(_evluateLastIndex) as? UIButton{
            lastBT.backgroundColor = kColor_ButtonCornerColor
            btn.backgroundColor = kColor_CircleColor
            if _evluateLastIndex != btn.tag {
                //切换菜单的时候，删除所有手势，禁止滑动
                NotificationCenter.default.post(name: NSNotification.Name.init("removeAllBehaviors"), object: self)
                _evaluateType = btn.tag - 10010
                _dataArray.removeAll()
                _currPage = 1
                tableView.reloadData()
                _loadView.frame = CGRect.init(x: self.center.x-40, y: 0, width: 80, height: 50)
                self.requestGetNewShopComList()
            }
            _evluateLastIndex = btn.tag
        }
    }
    
    
    @objc init(frame: CGRect,GroupId groupId:String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        _evluateLastIndex = 10010
        _currPage = 1
        self.groupId = groupId
        self.addSubview(self.evluateItemView)
        self.createView()
        self.requestGetNewShopComList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gestureStateBegan(noti:)), name: NSNotification.Name.init("GestureRecognizerStateBegan"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gestureStateEnd(noti:)), name: NSNotification.Name.init("GestureRecognizerStateEnded"), object: nil)
    }
    
    
    //MARK: 通知方法
    @objc func gestureStateBegan(noti:NSNotification){
        let isMore = tableView.contentOffset.y >= (tableView.contentSize.height - tableView.height())
        if isMore {
            _gestureEnd = false
        }
    }
    
    @objc func gestureStateEnd(noti:NSNotification){
        //手势已经结束
        let isMore = tableView.contentOffset.y > (tableView.contentSize.height - tableView.height())
        if isMore {
            //如果滑动的偏移量超出最大的内容范围
            let between = tableView.contentOffset.y - (tableView.contentSize.height - tableView.height())
            if between >= 70{
                _gestureEnd = true
            }
        }
    }
    
    func createView(){
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 40, width: self.width(), height: self.height()-40), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.backgroundColor = UIColorFromRGB(0xf4f4f4)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = kColor_bgHeaderViewColor
        self.tableView.showsVerticalScrollIndicator = false
        self.addSubview(self.tableView)
        
        _loadView = UIActivityIndicatorView()
        _loadView.style = UIActivityIndicatorView.Style.gray
        
        _noDateLab = UITool.createLabel(textColor: kColor_GrayColor, 12, .center)
        _noDateLab.text = "-  已经到底啦  -"
        
        self.tableView.addSubview(_loadView)
        self.tableView.addSubview(_noDateLab)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ShopEvaluateView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:EvaluateModel = _dataArray[indexPath.row] as! EvaluateModel
        model.calculateReserveCellHeight()
        return model.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//评价
        let reuseID = "evluateCell"
        var cell:ReserveEvluateCell? = tableView.dequeueReusableCell(withIdentifier: reuseID) as? ReserveEvluateCell
        if cell == nil {
            cell = ReserveEvluateCell.init(style: .default, reuseIdentifier: reuseID)
            cell?.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
            cell?.selectionStyle = .none
            cell?.cellType = 1
            cell?.delegate = self
        }
        
        let model = _dataArray[indexPath.row]
        model.calculateReserveCellHeight()
        cell?.model = model
        cell?.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: model.cellHeight)
        return cell!
    }
    
    
    //tableView加载完成可以调用的方法  因为tableview的cell高度不定，所以在加载完成以后重新计算高度
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.indexPathsForVisibleRows?.last?.row {
            //end of loading
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                if self._dataArray.count == self._count && self._count > 0 {
                    self._noDateLab.isHidden = false
                    self._noDateLab.frame = CGRect.init(x: 0, y: tableView.contentSize.height, width: self.width(), height: 50)
                }else{
                    self._noDateLab.isHidden = true
                }
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView != scrollView {return}
        if _gestureEnd {return}
        let isMore = tableView.contentOffset.y > (tableView.contentSize.height - tableView.height())
        if isMore{
            if (_count == 0) {
                _loadView.stopAnimating()
                _noDateLab.isHidden = true
            }
            if _dataArray.count == _count && _count > 0 {
                _loadView.stopAnimating()
                _noDateLab.isHidden = false
            }
            if _dataArray.count < _count && _count > 0{
                _noDateLab.isHidden = true
                _loadView.startAnimating()
                _loadView.frame = CGRect.init(x: self.tableView.center.x - 40, y: tableView.contentSize.height, width: 80, height: 50)
            }
            //如果滑动的偏移量超出最大的内容范围
            let between = tableView.contentOffset.y - (tableView.contentSize.height - tableView.height())
            if between >= 70 {
                if _isMoreThan{return}
                _isMoreThan = true
                //超出这个范围就开始做上拉加载动作
                if _isLoading == false{
                    _isLoading = true
                    _currPage += 1
                    if _dataArray.count >= _count{
                        _currPage -= 1
                        _loadView.stopAnimating()
                        _isLoading = false
                    }else{
                        self.requestGetNewShopComList()
                    }
                }
            }else{
                _isMoreThan = false
            }
        }
    }
    
    
    //MARK: 获取服务店铺评论列表
    func requestGetNewShopComList(){
        let dataDict = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "pizza.json", ofType: nil)!)
        self.analysisData(dic: dataDict!)
    }
    
    
    func analysisData(dic:NSDictionary){
        if _currPage == 1 {
            _dataArray.removeAll()
        }
        
        let btn2:UIButton = evluateItemView.viewWithTag(10011) as! UIButton
        let btn3:UIButton = evluateItemView.viewWithTag(10012) as! UIButton
        let btn4:UIButton = evluateItemView.viewWithTag(10013) as! UIButton
        
        if let btn2Str:String = dic.object(forKey: "recommendedCount") as? String {
            btn2.setTitle(String.init(format: "推荐(%@)",btn2Str), for: .normal)
        }
        if let btn3Str:String = dic.object(forKey: "normalCount") as? String {
            btn3.setTitle(String.init(format: "一般(%@)",btn3Str), for: .normal)
        }
        if let btn4Str:String = dic.object(forKey: "unsatisfyCount") as? String {
            btn4.setTitle(String.init(format: "不满意(%@)",btn4Str), for: .normal)
        }
        
        let productCommentList:NSArray = dic.object(forKey: "productCommentList") as! NSArray
        //列表
        if productCommentList.count > 0{
            var infoArray:[EvaluateModel] = [EvaluateModel]()
            for (_,obj) in productCommentList.enumerated(){
                let data = try! JSONSerialization.data(withJSONObject: obj, options: [])
                let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//                let infoModel:EvaluateModel =  EvaluateModel.deserialize(from: str as String?) ?? EvaluateModel()
                let infoModel:EvaluateModel? =  EvaluateModel.deserialize(from: str as String?) ?? nil
                infoArray.append(infoModel!)
            }
            _dataArray = infoArray
        }
        
        _count = Int(dic.object(forKey: "count") as! String)!
        tableView.reloadData()
        
        _isLoading = false
        if _dataArray.count == 0 {
            _noDateLab.isHidden = true
        }
    }
    
    
}



//MARK: ReverveEvluateCellDelegate 评价列表代理方法
extension ShopEvaluateView:ReserveEvluateCellDelegate{
    func didSelectedPhotoView(cell: ReserveEvluateCell, ImgIndex index: Int) {
        
        var indexPath = tableView.indexPath(for: cell)
        _selectedIndex = indexPath!.row
        var _:UIImageView = cell.viewWithTag(index) as! UIImageView
        //展示图片浏览器 （Cell模式）
        let browser:SDPhotoBrowser = SDPhotoBrowser()
        let model:EvaluateModel = _dataArray[_selectedIndex] as! EvaluateModel
        let picList = model.picList
        browser.sourceImagesContainerView = cell.photoView
        browser.imageCount = picList.count
        browser.currentImageIndex = index - 1
        browser.delegate = self
        browser.show()
    }
}

//MARK：SDPhotoBrowserDelegate 图片浏览器
extension ShopEvaluateView:SDPhotoBrowserDelegate{
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        //图片的高清图片地址
        let model : EvaluateModel = _dataArray[_selectedIndex] as! EvaluateModel
        let picList:NSArray = model.picList as NSArray
        
        let url = URL.init(string: (picList[index] as! Dictionary<String,Any>)["picUrl"] as! String)
        return url
    }

    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        //返回占位图片
        let model:EvaluateModel = _dataArray[_selectedIndex] as! EvaluateModel
        let picList:NSArray = model.picList as NSArray
        return KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: (picList[index] as! Dictionary<String,Any>)["picUrl"] as! String)
    }
    
}






