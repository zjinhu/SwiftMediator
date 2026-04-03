//
//  SwiftMediator+Property.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  属性检查与赋值扩展 / Property Inspection and Assignment Extension
//  使用 Mirror 反射检查属性，通过 KVC 进行赋值
//  Uses Mirror reflection to inspect properties and KVC for assignment

import Foundation

//MARK:--属性检查与赋值 / Property Inspection and Assignment--Swift
extension SwiftMediator {
    /// 判断对象是否包含指定属性 / Check if object contains specified property
    /// 支持检查父类属性 / Supports checking superclass properties
    /// - Parameters:
    ///   - name: 属性名 / Property name
    ///   - obj: 目标对象实例 / Target object instance
    /// - Returns: 是否包含该属性 / Whether the property exists
    func getTypeOfProperty (_ name: String, obj: AnyObject) -> Bool{
        let mirror = Mirror(reflecting: obj)
        let superMirror = Mirror(reflecting: obj).superclassMirror
        
        for (key,_) in mirror.children {
            if key == name {
                return  true
            }
        }
        
        guard let superM = superMirror else {
            return false
        }
        
        for (key,_) in superM.children {
            if key == name {
                return  true
            }
        }
        return false
    }
    
    /// 通过 KVC 对对象属性批量赋值 / Batch assign values to object properties via KVC
    /// - Parameters:
    ///   - obj: 目标对象 / Target object
    ///   - paramsDic: 参数字典，Key 必须与属性名对应 / Parameter dictionary, keys must match property names
    func setObjectParams(obj: AnyObject, paramsDic: [String: Any]?) {
        if let paramsDic = paramsDic {
            for (key,value) in paramsDic {
                if getTypeOfProperty(key, obj: obj){
                    obj.setValue(value, forKey: key)
                }
            }
        }
    }

}
