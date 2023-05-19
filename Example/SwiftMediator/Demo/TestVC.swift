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
class TestVC: ViewController {
    
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
        
        let label = UILabel().then { lab in
            lab.backgroundColor = .orange
            lab.numberOfLines = 0
            lab.text = "收到String:\(str!)--收到Int:\(num)"
            lab.textColor = .random
        }
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(200)
        }
 
        let label2 = UILabel().then { lab in
            lab.backgroundColor = .orange
            lab.numberOfLines = 0
            lab.text = "收到字典:\(String(describing: dic))--收到Int:\(num)"
            lab.textColor = .random
        }
        view.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(300)
        }
 
        let button = UIButton().then { btn in
            btn.backgroundColor = .random
            btn.setTitle("关闭页面", for: .normal)
            btn.addTouchUpInSideBtnAction { [weak self] sender in
                
                self?.goBack()
            }
        }
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(100)
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(60)
        }
 
    }
    
    @objc
    func callMethodReturn(_ name: String)->String{
        print("实例方法传递参数\(name)")
        Show.toast("实例方法传递参数:\(name)")
        return "实例方法返回参数:back"
    }
    
    @objc
    class func callClassM(){
        print("类方法调用")
        Show.toast("类方法调用")
    }
}
