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
    class func callMethodReturn(_ name: String)->String{
        print("Class method passing parameters\(name)")
        Show.toast("Class method passing parameters:\(name)")
        return "Class method return parameter: laile"
    }
    
    @objc
    class func callMethodNoReturn(_ name: String){
        print("Class method passing parameters\(name)")
        Show.toast("Class method passing parameters:\(name)")
    }
    
    @objc
    class func callMethod(){
        Show.toast("Class method call")
    }
}
