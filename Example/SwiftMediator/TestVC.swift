//
//  TestVC.swift
//  SwiftMediator
//
//  Created by 张金虎 on 2019/12/5.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SwiftBrick
import SwiftShow
class TestVC: JHViewController {
    
    @objc var titleName : String?
    @objc var str : String?
    @objc var num : Int = 0
    @objc var dic : [String : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundColor(.baseBGColor)
        navigationController?.navigationBar.setLineHidden(hidden: true)
        navigationController?.navigationBar.isTranslucent = false
        
        self.title = titleName
        self.view.backgroundColor = .random
        
        let _ = UILabel.snpLabel(supView: self.view, backColor: .yellow, text: "收到String:\(str!)--收到Int:\(num)", textColor: UIColor.random, snapKitMaker: { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(100)
        })
        
        let _ = UILabel.snpLabel(supView: self.view, backColor: .yellow, text: "收到字典:\(String(describing: dic))--收到Int:\(num)", textColor: UIColor.random, snapKitMaker: { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(100)
        })
        
        UIButton.snpButton(supView: view,
                           backColor: .random,
                           title: "关闭页面") { _ in
            self.goBack()
        } snapKitMaker: { (m) in
            m.left.equalToSuperview()
            m.width.height.equalTo(100)
            m.top.equalToSuperview()
        }

        
    }
    
    @objc
    func callObjcM(_ name: String) -> String{
        print("实例方法调用\(name)")
        Show.toast("实例方法调用,收到参数:\(name)")
        return "实例方法返回值:haha"
    }
    @objc
    class func callClassM(){
        print("类方法调用")
        Show.toast("类方法调用")
    }
}
