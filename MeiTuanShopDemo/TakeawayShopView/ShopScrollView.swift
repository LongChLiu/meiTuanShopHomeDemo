//
//  ShopScrollView.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/15.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

//全局函数
func rubberBandDistance(offset:CGFloat,dimension:CGFloat) -> CGFloat{
    let constant:CGFloat = 0.55
    let result:CGFloat = (constant * abs(offset) * dimension) / (dimension + constant * abs(offset))
    return offset < 0.0 ? -result : result
}

@objc protocol ShopScrollViewDelegate {
    //监听列表滚动视图的偏移量
    @objc optional func listScrollViewDidScroll(_ scrollView:UIScrollView)
    //偏移结束后
    @objc optional func listScrollViewDidEndDragging(_ scrollView:UIScrollView)
    //点击顶部视图 让该视图平移向下消失
    @objc optional func listScrollViewDropDown(scrollView:UIScrollView)
}

class ShopScrollView: UIScrollView {

    //是否显示动画
    var isStopAnimation:Bool = false
    //商家展示风格类型
    var shopViewType:ShopModuleType = .None
    //申明代理
    var scrollDelegate:ShopScrollViewDelegate!
    //店铺ID
    var groupId:String!
    //当前视图控制器
    var currentVC:UIViewController?
    
    
    
    /*
     全局变量
     */
    var _scrollLab:UILabel!
    var _lastIndex:Int!
    var _currentIndex:Int!
    var currentScrollY:CGFloat!
    var isVertical:Bool = false
    var scrollArray = NSMutableArray()
    var _evaluateBT:UIButton!
    var _sys_moduleType:Int! = 0
    var _maxOffset_Y:Int!
    
    
    /*
     私有属性
     */
    private var menuView:UIView!
    //MARK:懒加载
    private lazy var subScrollView:UIScrollView = {
        let subScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: menuView.maxY(), width: self.width(), height: self.height() - menuView.maxY() + CGFloat(_maxOffset_Y)))
        subScrollView.contentSize = CGSize.init(width: self.width()*3, height: subScrollView.height())
        subScrollView.isPagingEnabled = true
        subScrollView.isScrollEnabled = true
        subScrollView.showsHorizontalScrollIndicator = false
        subScrollView.backgroundColor = kColor_bgHeaderViewColor
        subScrollView.delegate = self
        self.subScrollView = subScrollView
        return subScrollView
    }()
    
    private lazy var shopHomePageView:ShopHomePageView = {
        let shopHomePageView = ShopHomePageView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: self.subScrollView.height()))
        shopHomePageView.shopSuperView = self
        shopHomePageView.currentVC = self.currentVC
        shopHomePageView.shopModuleType = self.shopViewType
        shopHomePageView.groupId = self.groupId
        shopHomePageView.shopModel = self.shopModel
        return shopHomePageView
    }() //商家列表主页、二级联动
    
    lazy private var merchantView:ShopMerchantView = {
        let merchant = ShopMerchantView.init(frame: CGRect.init(x: self.width()*2, y: 0, width: self.width(), height: self.subScrollView.height()))
        merchant.groupId = self.groupId
        merchant.shopModel = self.shopModel
        return merchant
    }() //商家视图
    
    lazy private var shopEvaluateView:ShopEvaluateView = {
        let shopEvaluat = ShopEvaluateView.init(frame: CGRect.init(x: self.width(), y: 0, width: self.width(), height: self.subScrollView.height()), GroupId: self.groupId)
        return shopEvaluat
    }() //评价视图
    
    private var subTableView:UIScrollView! //获取当前页面的子tableView
    private var shopModel:NewShopModel! //数据模型
    
    //弹性和惯性动画
    private var animator:UIDynamicAnimator!
    private var decelerationBehavior:UIDynamicBehavior!
    private var dynamicItem:LJDynamicItem!
    private var springBehavior:UIAttachmentBehavior!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //初始化店铺主页方法
    init(frame:CGRect,shopModel:NewShopModel,groupId:String,currentVc:UIViewController?){
        super.init(frame: frame)
        self.delegate = self
        self.isScrollEnabled = false
        self.currentVC = currentVc
        _lastIndex = 1
        _currentIndex = 1
        self.shopModel = shopModel
        self.groupId = groupId
        
        let activityLast = self.shopModel.activityList //活动数组
        if activityLast != nil && activityLast!.count > 0 {
            _maxOffset_Y = Int(Size(150) + CGFloat(48) - kDefaultNavBarHeight())
        }else{
            _maxOffset_Y = Int(Size(150) + CGFloat(48) - kDefaultNavBarHeight() - CGFloat(28))
        }
        
        self.contentSize = CGSize.init(width: self.width(), height: self.height()+CGFloat( _maxOffset_Y))
        
        //创建顶部视图，商品、评价、商家
        self.createTopMenuView()
        //创建上下滑动的scrollView
        self.addSubview(self.subScrollView)
        
        
        //MARK: 在这里暂时改变商家主页样式
        //列表布局、宫格布局、卡片布局
        self.shopViewType = ShopModuleType.ShopModuleTypeList
        self.subScrollView.addSubview(self.shopHomePageView) //店铺主页
        self.subScrollView.addSubview(self.shopEvaluateView) //评价
        self.subScrollView.addSubview(self.merchantView) //商家
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureRecognizerAction(pan:)))
        pan.delegate = self;self.addGestureRecognizer(pan);
        
        
        self.animator = UIDynamicAnimator.init(referenceView: self)
        self.dynamicItem = LJDynamicItem()
        self.subTableView = self.currentSubTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeAllBehaviors), name: NSNotification.Name.init("removeAllBehaviors"), object: nil)
    }
    
    //删除所有动力行为
    @objc func removeAllBehaviors(noti:NSNotification){
        self.animator.removeAllBehaviors()
    }
    
    //MARK: 控制方法
    //下拉 显示店铺详情
    @objc func dropDownTap(tap:UITapGestureRecognizer){
        //点击顶部 让整个视图平移
        
        //删除所有动力行为
        self.animator.removeAllBehaviors()
        self.scrollDelegate.listScrollViewDropDown?(scrollView: self)
    }
    
    //MARK:创建顶部菜单视图
    //创建顶部菜单视图 商品、评价、商家
    func createTopMenuView(){
        //顶部高度为_maxOffset_Y, 背景透明、可以点击
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width(), height: CGFloat(_maxOffset_Y)))
        topView.isUserInteractionEnabled = true
        self.addSubview(topView)
        
        //添加点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dropDownTap(tap:)))
        topView.addGestureRecognizer(tap)
        
        //创建 商品、评价、商家
        let menuView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(_maxOffset_Y), width: self.width(), height: 36))
        menuView.backgroundColor = UIColor.white
        self.addSubview(menuView)
        self.menuView = menuView
        
        //商品
        let button_W = self.width()/3
        let productBT = UITool.createButton(Frame: CGRect(x: 0, y: 0, width: button_W, height: menuView.height()), Title: "商品", BgColor: UIColor.white, TitleColor: kColor_darkBlackColor, Target: self, Sel: #selector(btnClick(btn:)), Tag: 101)
        productBT.titleLabel?.font = kFont(14)
        productBT.setBackgroundImage(AppMethods.createImage(UIColor.white), for:UIControl.State.highlighted)
        menuView.addSubview(productBT)
        
        //评价
        let evaluateBT = UITool.createButton(Frame: CGRect.init(x: button_W, y: 0, width: button_W, height: menuView.height()), Title: "评价\((6))", BgColor: UIColor.white, TitleColor: kColor_TitleColor, Target: self, Sel: #selector(btnClick(btn:)), Tag: 100+2)
        evaluateBT.titleLabel?.font = kFont(14)
        evaluateBT.setBackgroundImage(AppMethods.createImage(UIColor.white), for: .highlighted)
        menuView.addSubview(evaluateBT)
        self._evaluateBT = evaluateBT
        
        //商家
        let merchantBT = UITool.createButton(Frame: CGRect.init(x: button_W*2, y: 0, width: button_W, height: menuView.height()), Title: "商家", BgColor: UIColor.white, TitleColor: kColor_TitleColor, Target: self, Sel: #selector(btnClick(btn:)), Tag: 100+3)
        merchantBT.titleLabel?.font = kFont(14)
        merchantBT.setBackgroundImage(AppMethods.createImage(UIColor.white), for: .highlighted)
        menuView.addSubview(merchantBT)
        
        let line = UITool.lineLab(CGRect.init(x: 0, y: menuView.height()-Single_Line_Width(), width: self.width(), height: Single_Line_Width()))
        line.backgroundColor = kColor_bgHeaderViewColor
        menuView.addSubview(line)
        
        //可移动的底部滑竿
        _scrollLab = UILabel()
        _scrollLab.frame = CGRect.init(x: productBT.center.x-10, y: menuView.height()-2, width: 20, height: 2)
        _scrollLab.backgroundColor = UIColor.red
        menuView.addSubview(_scrollLab)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //委托 方法
        if scrollView == self {
            if(self.contentOffset.y == 0){
                //如果已经回到顶部了 则移除手势 禁止来回谈动
                self.animator.removeAllBehaviors()
            }
            if (!isStopAnimation){
                self.scrollDelegate.listScrollViewDidScroll?(scrollView)
            }
            //设置二级联动的左tableview的偏移量
            self.shopHomePageView.superScrollViewDidScrollOffset(offset: scrollView.contentOffset.y)
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name.init("bottomShopCartOffsetY"), object: self, userInfo: ["offsetY":String.init(format: "%f", scrollView.mj_offsetY)])
        }else if(scrollView == self.subScrollView){
            let scrollOffsetW = self.subScrollView.width()*2
            let currentOffsetX = self.subScrollView.contentOffset.x
            let rate = currentOffsetX/scrollOffsetW //速率
            let offset_X = self.width()/3 * rate*2
            _scrollLab.mj_x = offset_X+(self.width()/3/2-10)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        if scrollView == self.subScrollView {
            let index = self.subScrollView.contentOffset.x / self.subScrollView.frame.size.width
            _currentIndex = Int(index) + 1
            let lastBT:UIButton = menuView.viewWithTag(_lastIndex+100) as! UIButton
            let currentBT:UIButton = menuView.viewWithTag(_currentIndex+100) as! UIButton
            lastBT.setTitleColor(kColor_TitleColor, for: .normal)
            currentBT.setTitleColor(kColor_darkBlackColor, for: .normal)
            _lastIndex = _currentIndex
            self.subTableView = self.currentSubTableView()
        }
    }
    
    //MARK: 控制事件
    @objc func btnClick(btn:UIButton){
        let tag = btn.tag
        _currentIndex = tag - 100
        let lastBT:UIButton = menuView.viewWithTag(_lastIndex+100) as! UIButton
        lastBT.setTitleColor(kColor_TitleColor, for: .normal)
        btn.setTitleColor(kColor_darkBlackColor, for: .normal)
        
        _lastIndex = tag - 100
        if tag == 101 {
            //商品
            self.animator.removeAllBehaviors()
        }else if(tag == 102){
            //评价
            self.animator.removeAllBehaviors()
        }else if(tag == 103){
            //商家
            self.animator.removeAllBehaviors()
        }
        
        self.subScrollView.setContentOffset(CGPoint.init(x: CGFloat(_lastIndex-1)*self.subScrollView.width(), y: 0), animated: true)
        self.subTableView = self.currentSubTableView()
    }
    
    
    //MARK:是否支持多个手势共存
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let recognizer:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let currentY = recognizer.translation(in: self).y
            let currentX = recognizer.translation(in: self).x
            if currentY == 0.0{
                isVertical = false
                return true
            }else{
                //判断如果currentX为currentY的5倍以及以上就是断定为横向滑动 返回true 否则返回false
                if abs(currentX)/abs(currentY) >= 5.0{
                    isVertical = false
                    return true
                }else{
                    isVertical = true
                    return false
                }
            }
        }
        return false
    }
    
    
    
    @objc func panGestureRecognizerAction(pan:UIPanGestureRecognizer){
        isStopAnimation = false
        switch pan.state {
        case .began:
            currentScrollY = self.contentOffset.y
            if(isVertical){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GestureRecognizerStateBegan"), object: self)
            }
            self.animator.removeAllBehaviors()
        case .changed:
            if(isVertical){
                //往上滑为负数、往下滑为正数
                let currentY = pan.translation(in: self).y
                //
                self.controlScrollForVertical(detal: currentY, state: .changed)
            }
        case .cancelled:
            print("")
        case .ended:
            if(isVertical){
                NotificationCenter.default.post(name: NSNotification.Name.init("GestureRecognizerStateEnded"), object: self)
                if self.contentOffset.y <= -100{
                    //向下滑动
                    self.scrollDelegate.listScrollViewDropDown?(scrollView: self)
                }else{
                    self.dynamicItem.center = CGPoint.init(x: 0, y: 0)
                    //velocity是在手势结束的时候获取的竖直方向的手势速度
                    let velocity = pan.velocity(in: self)
                    
                    let inertialBehavior = UIDynamicItemBehavior.init(items: [self.dynamicItem as UIDynamicItem])
                    inertialBehavior.addLinearVelocity(CGPoint.init(x: 0, y: velocity.y), for: self.dynamicItem as UIDynamicItem)
                    //通过尝试2.0比较像系统的效果
                    inertialBehavior.resistance = 5.0
                    var lastCenter:CGPoint = CGPoint.zero
                    weak var weakSelf = self
                    inertialBehavior.action = {()->Void in
                        if (weakSelf?.isVertical == true){
                            //得到每次移动的距离
                            let currentY = weakSelf!.dynamicItem.center.y - lastCenter.y
                            weakSelf!.controlScrollForVertical(detal: currentY, state: .ended)
                        }
                        lastCenter = weakSelf!.dynamicItem.center
                    }
                    self.animator.addBehavior(inertialBehavior)
                    self.decelerationBehavior = inertialBehavior
                }
            }
        default:
            break
        }
        //保证每次只是移动的距离，不是从头一直移动的距离
        pan.setTranslation(CGPoint.zero, in: self)
    }
    
    
    //MARK:控制上下滑动的方法
    func controlScrollForVertical(detal:CGFloat,state:UIGestureRecognizer.State){
        //判断是主ScrollView滚动还是子ScrollView滚动，detail为手指移动的距离
        if self.contentOffset.y >= CGFloat(_maxOffset_Y) {
            var offsetY = self.subTableView.contentOffset.y - detal
            if offsetY < 0{
                //当子ScrollView的contentOffset小于0之后就不再移动子ScrollView 而要移动主ScrollView
                offsetY = 0
                self.contentOffset = CGPoint.init(x: self.frame.origin.x, y: self.contentOffset.y-detal)
            }else if(offsetY > (self.subTableView.contentSize.height - self.subTableView.frame.size.height)){
                //当子ScrollView的contentOffet大于contentSize.height时
                offsetY = self.subTableView.contentOffset.y - rubberBandDistance(offset: detal, dimension: self.height())
            }
            self.subTableView.contentOffset = CGPoint.init(x: 0, y: offsetY)
        }else{
            if(self.subTableView.contentOffset.y != 0 && detal >= 0){
                var offsetY = self.subTableView.contentOffset.y - detal
                if offsetY < 0 {                    //当子ScrollView的contentOffset小于0之后就不再移动子ScrollView，而要移动主ScrollView
                    offsetY = 0
                    self.contentOffset = CGPoint.init(x: self.frame.origin.x, y: self.contentOffset.y-detal)
                }else if(offsetY > (self.subTableView.contentSize.height-self.subTableView.frame.size.height)){
                    //当子ScrollView的contentOffset大于contentSize.height时
                    offsetY = self.subTableView.contentOffset.y - rubberBandDistance(offset: detal, dimension: self.height())
                }
                self.subTableView.contentOffset = CGPoint.init(x: 0, y: offsetY)
            }else{
                var mainOffsetY:CGFloat = self.contentOffset.y - detal
                if mainOffsetY < 0{
                    //滚动到顶部之后继续往上滚动需要乘以一个小于1的系数
                    mainOffsetY = self.contentOffset.y - rubberBandDistance(offset: detal, dimension: self.height())
                }else if(mainOffsetY > CGFloat(_maxOffset_Y)){
                    mainOffsetY = CGFloat(_maxOffset_Y)
                }
                self.contentOffset = CGPoint.init(x: self.frame.origin.x, y: mainOffsetY)
                if mainOffsetY == 0{
                    self.subTableView.contentOffset = CGPoint.init(x: 0, y: 0)
                }
            }
        }
        
        let outsideFrame = self.contentOffset.y < 0 || (self.subTableView.contentOffset.y > (self.subTableView.contentSize.height - self.subTableView.frame.size.height))
        let isMore = (self.subTableView.contentSize.height >= self.subTableView.frame.size.height) || (self.contentOffset.y >= CGFloat(_maxOffset_Y)) || (self.contentOffset.y < 0);
        
        if isMore && outsideFrame && (self.decelerationBehavior != nil && self.springBehavior == nil) {
            var target:CGPoint = CGPoint.zero
            var isMian = false
            if self.contentOffset.y < 0{
                self.dynamicItem.center = self.contentOffset
                target = CGPoint.zero
                isMian = true
            }else if(self.subTableView.contentOffset.y > (self.subTableView.contentSize.height - self.subTableView.frame.size.height)){
                self.dynamicItem.center = self.subTableView.contentOffset
                target = CGPoint.init(x: self.subTableView.contentOffset.x, y: (self.subTableView.contentSize.height - self.subTableView.frame.size.height))
                
                if(self.subTableView.contentSize.height <= self.subTableView.frame.size.height){
                    target = CGPoint.init(x: self.subTableView.contentOffset.x, y: 0)
                }
                isMian = false
            }
            
            self.animator.removeBehavior(self.decelerationBehavior)
            weak var weakSelf = self
            let springBehavior = UIAttachmentBehavior.init(item: self.dynamicItem as UIDynamicItem, attachedToAnchor: target)
            springBehavior.length = 0
            springBehavior.damping = 1
            springBehavior.frequency = 2
            springBehavior.action = {()->Void in
                if isMian{
                    weakSelf!.contentOffset = weakSelf!.dynamicItem.center
                    if weakSelf?.contentOffset.y == 0 {
                        self.subTableView.contentOffset = CGPoint.init(x: 0, y: 0)
                    }
                }else{
                    weakSelf?.subTableView.contentOffset = self.dynamicItem.center
                }
            }
            self.animator.addBehavior(springBehavior)
            self.springBehavior = springBehavior
        }
    }
    
    
    func removeBehaviors(){
        self.animator.removeAllBehaviors()
    }
    
    
    func currentSubTableView()->UIScrollView{
        var tableView:UIScrollView!
        //单
        switch _currentIndex {
        case 1:
            //店铺主页样式
            if self.shopViewType == ShopModuleType.ShopModuleTypeList{
                //列表样式
                tableView = self.shopHomePageView.rightTabView
            }else if(self.shopViewType == ShopModuleType.ShopModuleTypeCard){
                //卡片样式
                tableView = self.shopHomePageView.rightTabView
            }else{
                //宫格样式
                tableView = self.shopHomePageView.collectionView
            }
        case 2:
            tableView = self.shopEvaluateView.tableView
        case 3:
            tableView = self.merchantView.tableView
        default:
            break
        }
        return tableView
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ShopScrollView:UIScrollViewDelegate,UIGestureRecognizerDelegate{
    
    
    
    
    
    
    
}

