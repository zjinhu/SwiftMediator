//
//  JHBaseViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
// MARK: ===================================VC基类:UIViewController=========================================
open class JHViewController: UIViewController, JHBaseVC {

    // MARK: - 布局
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = L.color("bgColor")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "      ", style: .plain, target: self, action: #selector(goBack))
//        if let viewControllers: [UIViewController] = navigationController?.viewControllers , viewControllers.count > 1{
//            addDefaultBackBarButton()
//        }
    }
    
    // MARK: - Navigation 关闭手势返回
    public func closePopGestureRecognizer() {
        let target = navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: nil)
        view.addGestureRecognizer(pan)
    }
    
    // MARK: - 返回方法
    @objc
    open func goBack() {
        if let viewControllers: [UIViewController] = navigationController?.viewControllers {
            guard viewControllers.count <= 1 else {
                navigationController?.popViewController(animated: true)
                return
            }
        }
        
        if (presentingViewController != nil) {
            dismiss(animated: true, completion: nil)
        }
    }

    /// 设置导航默认返回按钮
    public func addDefaultBackBarButton() {
        addLeftBarButton(normalImage: SwiftBrick.navBarNorBackImage ?? L.image("nav_ic_back"),
                         highLightImage: SwiftBrick.navBarHigBackImage ?? L.image("nav_ic_back")) { [weak self] _ in
            guard let `self` = self else{return}
            self.goBack()
        }
    }
    
    public func addLeftBarButton(_ button: UIButton...,
                                 fixSpace: CGFloat = 0,
                                 buttonSpace: CGFloat = 20){
        addLeftBarButtons(buttons: button, fixSpace: fixSpace)
    }
    
    fileprivate func addLeftBarButtons(buttons: [UIButton],
                                       fixSpace: CGFloat = 0,
                                       buttonSpace: CGFloat = 20){
        
        navigationItem.leftBarButtonItems?.removeAll()
        
        let gap = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        gap.width = buttonSpace;
        
        var items = [UIBarButtonItem]()
        
        let count = buttons.count
        
        for (index, button) in buttons.enumerated() {
            button.contentHorizontalAlignment = .leading
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: fixSpace, bottom: 0, right: 0)
            if index != count - 1 {
                let barButton = UIBarButtonItem(customView: button)
                items.append(barButton)
                items.append(gap)
            }else{
                let barButton = UIBarButtonItem(customView: button)
                items.append(barButton)
            }
        }
        
        navigationItem.leftBarButtonItems = items
    }
    
    public func addRightBarButton(_ button: UIButton...,
                                  fixSpace: CGFloat = 0,
                                  buttonSpace: CGFloat = 20){
        addRightBarButtons(buttons: button, fixSpace: fixSpace)
    }
    
    fileprivate func addRightBarButtons(buttons: [UIButton],
                                        fixSpace: CGFloat = 0,
                                        buttonSpace: CGFloat = 20){
        
        navigationItem.rightBarButtonItems?.removeAll()
        
        let gap = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        gap.width = buttonSpace;
        
        var items = [UIBarButtonItem]()
        
        let count = buttons.count
        
        for (index, button) in buttons.enumerated() {
            button.contentHorizontalAlignment = .trailing
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: fixSpace)
            if index != count - 1 {
                let barButton = UIBarButtonItem(customView: button)
                items.append(barButton)
                items.append(gap)
            }else{
                let barButton = UIBarButtonItem(customView: button)
                items.append(barButton)
            }
        }
        
        navigationItem.rightBarButtonItems = items
    }
}
