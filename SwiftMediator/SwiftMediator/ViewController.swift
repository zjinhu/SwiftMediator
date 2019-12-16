//
//  ViewController.swift
//  SwiftMediator
//
//  Created by iOS on 27/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
//import SwiftBrick
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let vc = SwiftMediator.shared.currentViewController()!
        print(vc)
        
        let _ = UIButton.snpButton(supView: self.view, title: "push", snapKitMaker: { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }, touchUp: { (sender) in
            let avc = SwiftMediator.shared.initVC(vcName: "SwiftBrick.JHViewController", dic: [:])!
            SwiftMediator.shared.currentNavigationController()?.pushViewController(avc, animated: true)
        }, backColor: .orange)
        

    }


}

