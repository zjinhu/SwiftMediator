//
//  SwiftMediator+Init.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//

import Foundation
import UIKit
//MARK:--initialize object--Swift
extension SwiftMediator {
    
    /// Reflect UIViewController initialization and assignment
    /// - Parameters:
    /// - moduleName: component boundle name, if not passed, it will be the default namespace
    /// - vcName: UIViewController name
    /// - dic: parameter dictionary // Since it is a KVC assignment, @objc must be marked on the parameter
    @discardableResult
    public func initVC(_ vcName: String,
                       moduleName: String? = nil,
                       dic: [String: Any]? = nil) -> UIViewController?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(vcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let vc = cls as? UIViewController.Type else {
            return nil
        }
        let controller = vc.init()
        setObjectParams(obj: controller, paramsDic: dic)
        return controller
    }
    
    /// Reflect objc initialization and assignment Inherit NSObject
    /// - Parameters:
    /// - objcName: objcName
    /// - moduleName: moduleName
    /// - dic: parameter dictionary // Since it is a KVC assignment, @objc must be marked on the parameter
    /// - Returns: objc
    @discardableResult
    public func initObjc(_ objcName: String,
                         moduleName: String? = nil,
                         dic: [String : Any]? = nil) -> NSObject?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(objcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let ob = cls as? NSObject.Type else {
            return nil
        }
        let objc = ob.init()
        setObjectParams(obj: objc, paramsDic: dic)
        return objc
    }
    
    /// Reflect UIView initialization and assignment
    /// - Parameters:
    /// - moduleName: component boundle name, if not passed, it will be the default namespace
    /// - vcName: UIView name
    /// - dic: parameter dictionary // Since it is a KVC assignment, @objc must be marked on the parameter
    @discardableResult
    public func initView(_ viewName: String,
                       moduleName: String? = nil,
                       dic: [String: Any]? = nil) -> UIView?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(viewName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let vc = cls as? UIView.Type else {
            return nil
        }
        let view = vc.init()
        setObjectParams(obj: view, paramsDic: dic)
        return view
    }

}
