//
//  UINavigationControllerEx.swift
//  SwiftBrick
//
//  Created by iOS on 25/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================扩展: UINavigationController出入栈导航栏隐藏展示平滑切换,只需要①②两步即可=========================================
//extension UIApplication {
//    ///ios13以上失效,需要手动调用SwizzleNavBar.swizzle
//    override open var next: UIResponder? {
//        SwizzleNavBar.swizzle
//        return super.next
//    }
//}

public class SwizzleNavBar {
    //MARK: ‼️APP初始化时需要交换一下方法‼️重要①‼️
    public static let swizzle: Void = {
        UIViewController.swizzleMethod()
        UINavigationController.swizzle()
    }()
}

public extension UIViewController {
 
    private struct Associated {
        static var WillAppearInject: String = "WillAppearInject"
    }
    typealias ViewControllerWillAppearInjectBlock = (_ viewController: UIViewController , _ animated: Bool) -> Void

    class func swizzleMethod(){
        guard self == UIViewController.self else { return }
        let originalSelector = #selector(viewWillAppear(_: ))
        let swizzledSelector = #selector(jh_viewWillAppear(_: ))
        swizzling(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }

    @objc internal var willAppearInjectBlock: ViewControllerWillAppearInjectBlock? {
        get {
            if let block =  objc_getAssociatedObject(self, &Associated.WillAppearInject) as? ViewControllerWillAppearInjectBlock{
                return block
            }
            return nil
        }
        set (newValue){
            objc_setAssociatedObject(self, &Associated.WillAppearInject, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
//    @_dynamicReplacement(for: viewWillAppear(_: ))
    @objc func jh_viewWillAppear(_ animated: Bool) {
        jh_viewWillAppear(animated)
        guard let block = willAppearInjectBlock else {
            return
        }
        block(self , animated)
    }

}

public extension UIViewController {
    private struct Associate {
        static var NavigationBarHidden: String = "NavigationBarHidden"
    }
    //MARK: ‼️在需要展示隐藏导航栏的VC中赋值即可处理导航栏‼️重要②‼️
    /// 处理导航栏在VC内赋值True即可隐藏导航栏
    var prefersNavigationBarHidden: Bool? {
        get {
            return objc_getAssociatedObject(self, &Associate.NavigationBarHidden) as? Bool
        }
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &Associate.NavigationBarHidden, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

public extension UINavigationController {
    
    private struct Associated {
        static var NavigationBarAppearanceEnabled: String = "NavigationBarAppearanceEnabled"
    }
    
    var viewControllerBasedNavigationBarAppearanceEnabled: Bool? {
        get {
            self.viewControllerBasedNavigationBarAppearanceEnabled = true
            guard let number = objc_getAssociatedObject(self, &Associated.NavigationBarAppearanceEnabled) as? NSNumber else {
                return true
            }
            return  number.boolValue
        }
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &Associated.NavigationBarAppearanceEnabled, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    class func swizzle(){
        guard self == UINavigationController.self else { return }
        let originalSelector = #selector(setViewControllers(_:animated:))
        let swizzledSelector = #selector(jh_setViewControllers(_:animated:))
        swizzling(UINavigationController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
        
        let original = #selector(pushViewController(_:animated:))
        let swizzled = #selector(jh_pushViewController(_:animated:))
        swizzling(UINavigationController.self, originalSelector: original, swizzledSelector: swizzled)
    }

    @objc func jh_pushViewController(_ viewController: UIViewController, animated: Bool) {
        setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: viewController)
        jh_pushViewController(viewController, animated: animated)
    }
//
//    @_dynamicReplacement(for: setViewControllers(_: animated:))
    @objc func jh_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        for  vc in viewControllers {
            setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: vc)
        }
        jh_setViewControllers(viewControllers, animated: animated)
    }
    
    func setupViewControllerBasedNavigationBarAppearanceIfNeeded(appearingViewController: UIViewController){
        if viewControllerBasedNavigationBarAppearanceEnabled == false {
            return
        }

        appearingViewController.willAppearInjectBlock = { [weak self] (viewController: UIViewController, animated: Bool) in
            guard let `self` = self else { return }
            self.setNavigationBarHidden(viewController.prefersNavigationBarHidden ?? false, animated: animated)
        }
        
        // 因为不是所有的都是通过push的方式，把控制器压入stack中，也可能是"-setViewControllers:"的方式，所以需要对栈顶控制器做下判断并赋值。
        guard let disappearingViewController = viewControllers.last, disappearingViewController.willAppearInjectBlock == nil else {
            return
        }
        disappearingViewController.willAppearInjectBlock = { [weak self] (viewController: UIViewController, animated: Bool) in
            guard let `self` = self else { return }
            self.setNavigationBarHidden(viewController.prefersNavigationBarHidden ?? false, animated: animated)
        }
        
    }
}
