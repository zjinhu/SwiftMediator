//
//  NSObjectEx.swift
//  SwiftBrick
//
//  Created by iOS on 2021/11/26.
//  Copyright © 2021 狄烨 . All rights reserved.
//

import Foundation

public extension NSObject {

    static func swizzling(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(forClass, originalSelector),
              let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else {
            return
        }

        let isAddSuccess = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if isAddSuccess {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}


public extension NSObject {
    
    func decode(coder aDecoder:NSCoder) {
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            guard let label = child.label,
                let value = aDecoder.decodeObject(forKey: label) else {
                return
            }
            setValue(value, forKey: label)
        }
    }
    
    // MARK: 归档
    func encode(with aCoder: NSCoder) {
        // MARK: 利用反射获取类的所有属性
        let mirror = Mirror(reflecting: self)
        
        for (label, value) in mirror.children {
            if let label = label {
                aCoder.encode(value, forKey: label)
            }
        }
    }
    
}
