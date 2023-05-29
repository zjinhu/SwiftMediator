//
//  TestAViewController.swift
//  Example
//
//  Created by iOS on 2023/5/26.
//

import UIKit
import Foundation
import SwiftMediator
import SafariServices
import SwiftBrick
class TestAViewController: ViewController {

    var titleName : String?
    var str : String?
    var num : Int = 0
    var dic : [String : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = titleName
        self.view.backgroundColor = .random
        
        let label = UILabel().then { lab in
            lab.backgroundColor = .orange
            lab.numberOfLines = 0
            lab.text = "Received String:\(str ?? "")--Received Int:\(num)"
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
            lab.text = "Dictionary received:\(String(describing: dic))--Int received:\(num)"
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
            btn.setTitle("Close page", for: .normal)
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

}

extension TestAViewController: Routable {

    // 返回一个路由协议的实例
    static func initVC(params: [String : Any]) -> Routable {
        let vc = TestAViewController()
        vc.dic = params
        return vc
    }
 
//    func openRouter(path: String) {
//        debugPrint("\(path)")
//    }
}

public extension Router {
    @objc
    func registerAController() -> RoutePath {
        return RoutePath(path: "push://xxx",
                          routerClass: TestAViewController.self)
    }
}

