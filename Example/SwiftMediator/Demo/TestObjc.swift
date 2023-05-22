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
        print("instance method passing parameters\(name)")
        Show.toast("Instance method passing parameters:\(name)")
        return "Instance method return parameter: back"
    }
    
    @objc
    func callMethodNoReturn(_ name: String){
        print("instance method passing parameters\(name)")
        Show.toast("Instance method passing parameters:\(name)")
    }
    
    @objc
    func callMethod(){
        Show.toast("instance method call")
    }
}
