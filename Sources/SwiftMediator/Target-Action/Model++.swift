//
//  Model++.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//

import Foundation
import UIKit
extension SwiftMediator {
    /// route present
    /// - Parameters:
    /// - fromVC: Jump from that page--if not passed, the top VC is taken by default
    /// - moduleName: The name of the component where the target VC is located
    /// - vcName: target VC name
    /// - paramsDic: parameter dictionary
    /// - modelStyle: 0: modal style is default, 1: full screen modal, 2: custom
    /// - needNav: Do you need a navigation bar (native navigation bar, if you need a custom navigation bar, please directly pass the corresponding VC object with navigation bar)
    /// - animated: whether there is animation
    public func present(_ vcName: String,
                        moduleName: String? = nil,
                        paramsDic: [String: Any]? = nil,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = false,
                        modelStyle: UIModalPresentationStyle = .fullScreen,
                        animated: Bool = true) {
        
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        presentVC(needNav: needNav, animated: animated, modelStyle: modelStyle, vc: vc)
        
    }
    
    /// Simple present, initialize VC in advance
    /// - Parameters:
    /// - vc: initialized VC object, can pass Nav object (custom navigation bar)
    /// - fromVC: From which page to push, if not, the route selects the top VC
    /// - needNav: Do you need a navigation bar (native navigation bar, if you need a custom navigation bar, please directly pass the corresponding VC object with navigation bar)
    /// - modelStyle: 0: modal style is default, 1: full screen modal, 2: custom
    /// - animated: whether there is animation
    public func present(_ vc: UIViewController?,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = false,
                        modelStyle: UIModalPresentationStyle = .fullScreen,
                        animated: Bool = true) {
        guard let vc = vc else { return }
        presentVC(needNav: needNav, animated: animated, modelStyle: modelStyle, vc: vc)
    }
    
    fileprivate func presentVC(needNav: Bool,
                               animated: Bool,
                               modelStyle: UIModalPresentationStyle,
                               vc: UIViewController,
                               fromVC: UIViewController? = nil){
        var container = vc
        
        if needNav {
            let nav = UINavigationController(rootViewController: vc)
            container = nav
        }
 
        container.modalPresentationStyle = modelStyle
 
        guard let from = fromVC else {
            UIViewController.currentViewController()?.present(container, animated: animated, completion: nil)
            return
        }
        from.present(container, animated: animated, completion: nil)
    }
    
    /// Exit the current page
    public func dismissVC(animated: Bool = true) {
        let current = UIViewController.currentViewController()
        if let viewControllers: [UIViewController] = current?.navigationController?.viewControllers {
            guard viewControllers.count <= 1 else {
                current?.navigationController?.popViewController(animated: animated)
                return
            }
        }
        
        if let _ = current?.presentingViewController {
            current?.dismiss(animated: animated, completion: nil)
        }
    }
}
