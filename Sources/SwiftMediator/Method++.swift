//
//  SwiftMediator+Method.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//

import Foundation

//MARK:--routing execution method
extension SwiftMediator {
    /// Routing call instance object method: @objc must be marked Example: @objc class func qqqqq(_ name: String)
    /// - Parameters:
    /// - objc: initialized object
    /// - selName: method name
    /// - param: parameter 1
    /// - otherParam: parameter 2
    @discardableResult
    public func callObjcMethod(objc: AnyObject,
                               selName: String,
                               param: Any? = nil,
                               otherParam: Any? = nil ) -> Unmanaged<AnyObject>?{
        
        let sel = NSSelectorFromString(selName)
        guard let _ = class_getInstanceMethod(type(of: objc), sel) else {
            return nil
        }
        return objc.perform(sel, with: param, with: otherParam)
    }
    
    /// Routing call class method: @objc must be marked Example: @objc func qqqqq(_ name: String)
    /// - Parameters:
    /// - moduleName: component name
    /// - className: class name
    /// - selName: method name
    /// - param: parameter 1
    /// - otherParam: parameter 2
    @discardableResult
    public func callClassMethod(className: String,
                                selName: String,
                                moduleName: String? = nil,
                                param: Any? = nil,
                                otherParam: Any? = nil ) -> Unmanaged<AnyObject>?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        let className = "\(namespace).\(className)"
        guard let cls: AnyObject? = NSClassFromString(className) else {
            return nil
        }
        
        let sel = NSSelectorFromString(selName)
        guard let _ = class_getClassMethod(cls as? AnyClass, sel) else {
            return nil
        }
        
        return cls?.perform(sel, with: param, with: otherParam)
    }
    
    //    /// 路由调用类方法，仅支持单一参数或者无参数，样式：@objc class func qqqqq(_ name: String)
    //    /// - Parameters:
    //    ///   - moduleName: 组件名称
    //    ///   - objName: 类名称
    //    ///   - selName: 方法名
    //    ///   - param: 参数
    //    func callClassMethod(moduleName: String, objName: String, selName: String, param: Any? = nil ){
    //        let className = "\(moduleName).\(objName)"
    //        let cls: AnyClass? = NSClassFromString(className)
    //
    //        let sel = NSSelectorFromString(selName)
    //
    //        guard let method = class_getClassMethod(cls, sel) else {
    //            return
    //        }
    //        let imp = method_getImplementation(method)
    //
    //        typealias Function = @convention(c) (AnyObject, Selector, Any?) -> Void
    //        let function = unsafeBitCast(imp, to: Function.self)
    //        return function(cls!, sel, param)
    //    }
    
}
