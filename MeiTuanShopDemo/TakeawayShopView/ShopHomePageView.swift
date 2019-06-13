//
//  ShopHomePageView.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/16.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit
import MJRefresh


let collectionCellH = (takeawayRight_W - 30)/2 + 97



/*
 店铺主页
 */
class ShopHomePageView: UIView {

    //商家展示风格类型 cell样式
    var shopModuleType:ShopModuleType = ShopModuleType.None
    
    
    @objc var shopModuleType_OC:Int = 0{
        didSet{
            if self.shopModuleType_OC == 0{
                self.shopModuleType = .None
            }else if self.shopModuleType_OC == 1{
                self.shopModuleType = .ShopModuleTypeList
            }else if self.shopModuleType_OC == 2{
                self.shopModuleType = .ShopModuleTypeGongGe
            }else if self.shopModuleType_OC == 3{
                self.shopModuleType = .ShopModuleTypeCard
            }
        }
    }
    
    
    //左视图--->标签tableView
    @objc var leftTabView:UITableView!
    //右视图--->列表样式or卡片样式
    @objc var rightTabView:UITableView!
    //右视图--->宫格样式
    @objc var collectionView:UICollectionView!
    //当前视图控制器
    @objc var currentVC:UIViewController!
    //店铺ID
    @objc var groupId:String!
    
    
    //数据模型
    @objc var _shopModel:NewShopModel! = nil
    @objc var shopModel:NewShopModel!{
        set{
            _shopModel = newValue
            
            if let sortInfo = _shopModel.sortInfo{
                titlesAry = sortInfo
            }
            
            let activityList = _shopModel.activityList
            if activityList != nil && activityList!.count > 0 {
                _maxOffset_Y = Size(150) +  CGFloat(48) - kDefaultNavBarHeight()
            }else{
                _maxOffset_Y = Size(150) + 48 - kDefaultNavBarHeight() - 28
            }
            
            self.createView()
            _currentSubView = self.currentScrollView()
        }
        get{
            return _shopModel
        }
    }
    
    func createView(){
        self.leftTabView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: takeawayLeft_W, height: self.height()-_maxOffset_Y), style: UITableView.Style.grouped)
        self.leftTabView.dataSource = self
        self.leftTabView.delegate = self
        self.leftTabView.backgroundColor = UIColorFromRGB(0xF4F4F4)
        self.leftTabView.tableFooterView = UIView()
        self.leftTabView.separatorColor = kColor_bgHeaderViewColor
        self.leftTabView.showsVerticalScrollIndicator = false
        self.addSubview(self.leftTabView)
        
        
        let line = UITool.lineLab(CGRect.init(x: takeawayLeft_W-0.5, y: 0, width: 0.5, height: self.height()))
        line.backgroundColor = kColor_bgHeaderViewColor
        self.leftTabView.addSubview(line)
        
        
        if self.shopModuleType == ShopModuleType.ShopModuleTypeGongGe {
            self.createCollectionView()
        }else{
            self.createRightTableView()
        }
    }
    
    
    func createRightTableView(){
        self.rightTabView = UITableView.init(frame: CGRect.init(x: takeawayLeft_W, y: 0, width: takeawayRight_W, height: self.height()), style: UITableView.Style.plain)
        self.rightTabView.dataSource = self
        self.rightTabView.delegate = self
        self.rightTabView.backgroundColor = UIColor.white
        self.rightTabView.tableFooterView = UIView.init()
        self.rightTabView.separatorColor = kColor_bgHeaderViewColor
        if self.shopModuleType == ShopModuleType.ShopModuleTypeCard {
            self.rightTabView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
        self.rightTabView.showsVerticalScrollIndicator = false
        self.rightTabView.isScrollEnabled = false
        self.addSubview(self.rightTabView)
    }
    
    func createCollectionView(){
        //创建流水布局
        _layout = JHHeaderFlowLayout.init()
        _layout.headerReferenceSize = CGSize.init(width: takeawayRight_W, height: 34)
        _layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        //设置列表视图
        collectionView = UICollectionView.init(frame: CGRect(x: takeawayLeft_W, y: 0, width: takeawayRight_W, height: self.height()), collectionViewLayout: _layout)
        
        //注册cell、sectionHeader、sectionFooter
        collectionView.register(TakeawayProductCollectionCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        //设置代理
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor.white
        self.addSubview(self.collectionView)
    }
    
    
    //该视图的父视图
    @objc var shopSuperView:ShopScrollView!
    
    
    
    /*全局变量*/
    var _leftIndex:Int!
    var _isStop:Bool!
    var _layout:JHHeaderFlowLayout!
    
    var _dataArray = NSMutableArray()
    var _maxOffset_Y:CGFloat!
    
    
    var _gestureEnd:Bool = false //手势是否已经结束
    var _isMoreThan:Bool = false
    
    var _currentSubView:UIScrollView!
    var _isSelectSlide:Bool = false //是点击leftTableView，还是拖曳右边滑动视图
    
    
    
    var titlesAry:NSMutableArray = []
    
    
    
    
    
    var productList:NSArray!
    
    
    
    
    var addOrderList:NSMutableArray = NSMutableArray()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        _leftIndex = 0
        NotificationCenter.default.addObserver(self, selector: #selector(gestureStateBegan(noti:)), name: NSNotification.Name.init("GestureRecognizerStateBegan"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gestureStateEnd(noti:)), name: NSNotification.Name.init("GestureRecognizerStateEnded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bottomShoppingCartMethod(noti:)), name: NSNotification.Name.init("bottomShopCartOffsetY"), object: nil)
    }
    
    //MARK: 通知方法
    @objc func gestureStateBegan(noti:NSNotification){
        let isMore:Bool = _currentSubView.contentOffset.y >= (_currentSubView.contentSize.height - _currentSubView.height())
        if isMore {
            _gestureEnd = false
        }
        //手动拖曳
        _isSelectSlide = false
    }
    
    @objc func gestureStateEnd(noti:NSNotification){
        //手势已经结束
        let isMore = _currentSubView.contentOffset.y > (_currentSubView.contentSize.height - _currentSubView.height())
        if isMore {
            //如果滑动的偏移量超出最大的内容范围
            let between = _currentSubView.contentOffset.y - (_currentSubView.contentSize.height - _currentSubView.height())
            if between >= 70{
                _gestureEnd = true
            }
        }
    }
    
    @objc func bottomShoppingCartMethod(noti:NSNotification){
        if let dic = noti.userInfo {
            let offsetYStr:String! = dic["offsetY"] as? String;
            _ = Float(offsetYStr)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //父视图偏移量
    @objc func superScrollViewDidScrollOffset(offset:CGFloat){
        if offset <= _maxOffset_Y {
            leftTabView.mj_h = self.height()-_maxOffset_Y+offset
        }
    }
    
}


extension ShopHomePageView:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titlesAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TakeawayProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectCell", for: indexPath) as! TakeawayProductCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView:HeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! HeaderReusableView
            let dic:NSDictionary = titlesAry[indexPath.section] as! NSDictionary
            headerView.titleLab.text = dic["name"] as? String
            headerView.tag = 50
            return headerView
        }
        return UICollectionReusableView()
    }
    
    
    
    
    
}


extension ShopHomePageView:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionCellH-97, height: collectionCellH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    //选中cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: ThrowLineToolDelegate methods   抛物线结束动画回调
    func animationDidFinish(){
        
        
    }
    
    
}

extension ShopHomePageView:UICollectionViewDelegate{
    
    
    
    
    
}





extension ShopHomePageView:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.leftTabView {
            return 1
        }
        return titlesAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTabView {
            return titlesAry.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.leftTabView {
            return 44
        }else{
            if self.shopModuleType == ShopModuleType.ShopModuleTypeCard{
                return 110+4*(takeawayRight_W-20)/7
            }else{
                return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if rightTabView == tableView {
            return 30
        }else{
            return 0.01
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //最后一个
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        if tableView == leftTabView {
            bgView.backgroundColor = UIColorFromRGB(0xf4f4f4)
        }
        return bgView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == rightTabView {
            let bgView = UIView()
            bgView.backgroundColor = UIColor.white
            
            let line = UITool.lineLab(CGRect.init(x: 10, y: 10, width: 1, height: 14))
            line.backgroundColor = UIColorFromRGB(0xFF5A49)
            bgView.addSubview(line)
            
            let titleLab = UITool.createLabel(CGRect.init(x: line.maxX()+7, y: 0, width: 200, height: 34), UIColor.clear, kColor_GrayColor, 12, .left, lines: 1)
            let dic:NSDictionary = titlesAry[section] as! NSDictionary
            titleLab.text = dic["name"] as? String
            bgView.addSubview(titleLab)
            return bgView
        }
        return nil
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.leftTabView {
            let reuseId = "lettCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
            if cell == nil{
                cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseId)
                let titleLab = UITool.createLabel(CGRect.init(x: 0, y: 0, width: takeawayLeft_W, height: 50), UIColor.clear, kColor_darkBlackColor, 13, .center, lines: 1)
                titleLab.tag = 10+100
                cell?.contentView.addSubview(titleLab)
                
                let selectView = UIView.init(frame: cell!.frame)
                selectView.backgroundColor = UIColor.white
                cell?.selectedBackgroundView = selectView
                cell?.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            let titleLab:UILabel = cell?.contentView.viewWithTag(10+100) as! UILabel
            let dic : NSDictionary = titlesAry[indexPath.row] as! NSDictionary
            titleLab.text = dic["name"] as? String
            if indexPath.row == _leftIndex{
                leftTabView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
            
            cell!.backgroundColor = UIColorFromRGB(0xf4f4f4)
            
            return cell!
            
        }else{
            if self.shopModuleType == ShopModuleType.ShopModuleTypeCard{
                let cardCell = "cardCell"
                var cell:TakeawayProductCardCell? = tableView.dequeueReusableCell(withIdentifier: cardCell) as? TakeawayProductCardCell
                if cell == nil{
                    cell = TakeawayProductCardCell.init(style: .default, reuseIdentifier: cardCell)
                    cell?.selectionStyle = .none
                    cell?.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                }
                return cell!
            }else{
                let listCell:String = "listCell1"
                var cell:TakeawayProductListCell? = tableView.dequeueReusableCell(withIdentifier: listCell) as? TakeawayProductListCell
                if cell == nil{
                    cell = TakeawayProductListCell.init(style:UITableViewCell.CellStyle.default, reuseIdentifier: listCell)
                    cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                    cell?.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                }
                return cell!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if leftTabView == tableView {
            //选中leftTabView而不是拖曳右边的滑动视图
            _isSelectSlide = true
            if self.shopModuleType == ShopModuleType.ShopModuleTypeGongGe{
                var offsetY:CGFloat = 0
                for _ in 0..<indexPath.row{
                    let count:Int = 10 //动态返回数量
                    let countMake:CGFloat = (CGFloat(count/2+count%2))
                    offsetY = countMake*collectionCellH + CGFloat(74) + offsetY
                }
                collectionView.setContentOffset(CGPoint.init(x: 0, y: offsetY), animated: true)
            }else{
                rightTabView.scrollToRow(at: IndexPath.init(row: 0, section: indexPath.row), at: UITableView.ScrollPosition.top, animated: true)
            }
            leftTabView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.middle)
            _leftIndex = indexPath.row
        }else{
            print("跳转到详情")
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //当拖曳leftTabView时候 应该停止右视图的手势 停止滚动
        shopSuperView.removeBehaviors()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != leftTabView {
            var array:[IndexPath] = [IndexPath]()
            if scrollView == collectionView{
                array = collectionView.indexPathsForVisibleItems
            }else{
                array = rightTabView.indexPathsForVisibleRows!
            }
            if array.count > 0 {
                //1:找到indexPath
                var indexPath:IndexPath = array[0]
                //1:可见的第一个section位置
                let section:Int = indexPath.section
                //3:
                if !_isSelectSlide{
                    //只有拖曳的时候 才执行该方法
                    leftTabView.selectRow(at: IndexPath.init(row: section, section: 0), animated: false, scrollPosition:UITableView.ScrollPosition.middle)
                }
            }
        }
    }
    
    
    func currentScrollView()->UIScrollView{
        var scrollView:UIScrollView! = nil
        switch self.shopModuleType.rawValue {
        case 1:
            scrollView = rightTabView
        case 2:
            scrollView = collectionView
        case 3:
            scrollView = rightTabView
        default:
            break
        }
        return scrollView
    }
    
    
    
}




