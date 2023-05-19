//
//  TestObjc.swift
//  SwiftMediator
//
//  Created by iOS on 2020/6/17.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
import SwiftShow
class TestObjc: NSObject {

    @objc
    func callMethodReturn(_ name: String)->String{
        print("实例方法传递参数\(name)")
        Show.toast("实例方法传递参数:\(name)")
        return "实例方法返回参数:back"
    }
    
    @objc
    func callMethodNoReturn(_ name: String){
        print("实例方法传递参数\(name)")
        Show.toast("实例方法传递参数:\(name)")
    }
    
    @objc
    func callMethod(){
        Show.toast("实例方法调用")
    }
}
