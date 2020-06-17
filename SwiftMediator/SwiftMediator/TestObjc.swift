//
//  TestObjc.swift
//  SwiftMediator
//
//  Created by iOS on 2020/6/17.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit

class TestObjc: NSObject {

    @objc func ccccc(_ name: String)->String{
        print("\(name)")
        return "back"
    }
}
