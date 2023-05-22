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
        
        let label = UILabel(). then { lab in
            lab.backgroundColor = .orange
            lab.numberOfLines = 0
            lab.text = "Received String:\(str!)--Received Int:\(num)"
            lab.textColor = .random
        }
        view. addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(200)
        }
        
        let label2 = UILabel(). then { lab in
            lab.backgroundColor = .orange
            lab.numberOfLines = 0
            lab.text = "Dictionary received:\(String(describing: dic))--Int received:\(num)"
            lab.textColor = .random
        }
        view. addSubview(label2)
        label2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(300)
        }
        
        let button = UIButton(). then { btn in
            btn.backgroundColor = .random
            btn.setTitle("Close page", for: .normal)
            btn.addTouchUpInSideBtnAction { [weak self] sender in
                
                self?. goBack()
            }
        }
        view. addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(100)
            make.height.equalTo(50)
            make.top.equalToSuperview().offset(60)
        }
        
    }
    
    @objc
    func callMethodReturn(_ name: String)->String{
        print("instance method passing parameters\(name)")
        Show.toast("Instance method passing parameters:\(name)")
        return "Instance method return parameter: back"
    }
    
    @objc
    class func callClassM(){
        print("Class method call")
        Show.toast("Class method call")
    }
}
