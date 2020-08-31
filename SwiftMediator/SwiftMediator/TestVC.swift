//
//  TestVC.swift
//  SwiftMediator
//
//  Created by 张金虎 on 2019/12/5.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SwiftBrick

class TestVC: JHViewController {
    @objc var titleName : String?
    @objc var str : String?
    @objc var num : Int = 0
    @objc var dic : [String : Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleName
        self.view.backgroundColor = .random
        let _ = UILabel.snpLabel(supView: self.view, backColor: .yellow, text: "\(str!)--\(num)", textColor: UIColor.random, snapKitMaker: { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        })
        
        let _ = UILabel.snpLabel(supView: self.view, backColor: .yellow, text: "\(String(describing: dic))--\(num)", textColor: UIColor.random, snapKitMaker: { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
            make.top.equalToSuperview().offset(100)
        })
        
    }
    @objc
    func pppppp(_ name: String) -> String{
        print("\(name)")
        return "back!!!!"
    }
    @objc
    class func qqqqq(){
        print("2222222")
    }
}
