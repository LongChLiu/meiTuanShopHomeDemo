//
//  TakeawayShopMainVC.swift
//  MeiTuanShopDemo
//
//  Created by 艺教星 on 2019/5/15.
//  Copyright © 2019 艺教星. All rights reserved.
//

import UIKit

class TakeawayShopMainVC: UIViewController {

    var GroupID:String!="" //店铺id
    
    //视图生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initData()
        self.initSubView()
    }
    
    func initData(){
        
    }
    
    func initSubView(){
        //在请求中携带店铺ID
        let shopView = TakeawayShopView.init(frame: self.view.bounds, GroupId: GroupID)
        self.view.addSubview(shopView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
