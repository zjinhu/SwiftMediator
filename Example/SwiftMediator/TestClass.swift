//
//  TestClass.swift
//  SwiftMediator
//
//  Created by iOS on 2020/1/9.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import SwiftShow
class TestClass {

    @objc
    class func callClassM(_ name: String)->String{
        print("类方法传递参数\(name)")
        Show.toast("类方法传递参数:\(name)")
        return "类方法返回参数:laile"
    }

}
