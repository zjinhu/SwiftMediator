//
//  SwiftMediator+Property.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//

import Foundation
//MARK:--Inspect property--Swift
extension SwiftMediator {
    /// Determine whether the attribute exists
    /// - Parameters:
    /// - name: attribute name
    /// - obj: target object
    func getTypeOfProperty (_ name: String, obj: AnyObject) -> Bool{
        // Note: obj is an instance (object), if it is a class, its properties cannot be obtained
        let morror = Mirror(reflecting: obj)
        let superMorror = Mirror(reflecting: obj).superclassMirror
        
        for (key,_) in morror.children {
            if key == name {
                return  true
            }
        }
        
        guard let superM = superMorror else {
            return false
        }
        
        for (key,_) in superM.children {
            if key == name {
                return  true
            }
        }
        return false
    }
    
    /// KVC assigns values to attributes
    /// - Parameters:
    /// - obj: target object
    /// - paramsDic: The parameter dictionary Key must correspond to the attribute name
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
