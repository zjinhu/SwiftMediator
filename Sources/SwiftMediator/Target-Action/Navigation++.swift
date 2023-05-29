//
//  SwiftMediator+Route.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//

import UIKit
import Foundation
//MARK:--route jump--code jump
extension SwiftMediator {
    
    /// Routing Push
    /// - Parameters:
    /// - fromVC: Jump from that page--if not passed, the top VC is taken by default
    /// - moduleName: The name of the component where the target VC is located
    /// - vcName: target VC name
    /// - paramsDic: parameter dictionary
    /// - animated: whether there is animation
    public func push(_ vcName: String,
                     moduleName: String? = nil,
                     fromVC: UIViewController? = nil,
                     paramsDic:[String:Any]? = nil,
                     animated: Bool = true) {
        
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        pushVC(animated: animated, vc: vc, fromVC: fromVC)
    }
    
    /// Simple Push, initialize VC in advance
    /// - Parameters:
    /// - vc: initialized VC object
    /// - fromVC: From which page to push, if not, the route selects the top VC
    /// - animated: whether there is animation
    public func push(_ vc: UIViewController?,
                     fromVC: UIViewController? = nil,
                     animated: Bool = true) {
        guard let vc = vc else { return }
        pushVC(animated: animated, vc: vc, fromVC: fromVC)
    }
    
    
    /// The current UINavigationController pop to the previous page
    /// - Parameter animated: animated
    public func pop(animated: Bool = true){
        guard let nav = UIViewController.currentNavigationController() else { return }
        nav.popViewController(animated: animated)
    }
    
    
    /// The current UINavigationController pop to the Root page
    /// - Parameter animated: animated
    public func popToRoot(animated: Bool = true){
        guard let nav = UIViewController.currentNavigationController() else { return }
        nav.popToRootViewController(animated: animated)
    }
    
    /// The current UINavigationController pops to the specified page
    /// - Parameter vc: specified page
    /// - Returns: Bool
    @discardableResult
    public func popTo(_ vc: UIViewController) -> Bool {
        guard let navigationController = UIViewController.currentNavigationController() else {
            return false
        }
        
        if navigationController.children.contains(vc){
            navigationController.popToViewController(vc, animated: true)
            return true
        }
        
        return false
    }
    
    /// The current UINavigationController pops to the specified subscript page number
    /// - Parameter index: page number
    /// - Returns: Bool
    @discardableResult
    public func popTo(_ index: Int) -> Bool {
        guard let navigationController = UIViewController.currentNavigationController(), index >= 0 else {
            return false
        }
        
        if index < navigationController.children.count - 1{
            let vc = navigationController.children[index]
            navigationController.popToViewController(vc, animated: true)
        }
        return false
    }
    
    /// The current UINavigationController pops to the specified title
    /// - Parameter navigationBarTitle
    /// - Returns: Bool
    @discardableResult
    public func popTo(_ navigationBarTitle: String) -> Bool {
        guard let navigationController = UIViewController.currentNavigationController() else {
            return false
        }
        
        for vc in navigationController.children {
            if vc.navigationItem.title == navigationBarTitle {
                navigationController.popToViewController(vc, animated: true)
                return true
            }
        }
        
        return false
    }
    
    fileprivate func pushVC(animated: Bool,
                            vc: UIViewController,
                            fromVC: UIViewController? = nil){
        
        vc.hidesBottomBarWhenPushed = true
        guard let from = fromVC else {
            UIViewController.currentNavigationController()?.pushViewController(vc, animated: animated)
            return
        }
        from.navigationController?.pushViewController(vc, animated: animated)
    }
    
    
    /// Create UINavigationController viewControllers stack
    /// - Parameter controllers: [UIViewController]
    fileprivate func createNavigationStack(controllers: [UIViewController]) {
        guard let window = UIWindow.keyWindow else { return }
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = controllers
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    /// Remove all pages in the current UINavigationController stack
    fileprivate func removeNavigationStack() {
        guard let navigationController = UIViewController.currentNavigationController() else {
            return
        }
        navigationController.children.forEach({
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        })
    }
}

//MARK:--Get the namespace where the object is located
public extension NSObject {
    
    func getModuleName() -> String{
        let name = type(of: self).description()
        guard let module : String = name.components(separatedBy: ".").first else {
            return Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        }
        return module
    }
}
