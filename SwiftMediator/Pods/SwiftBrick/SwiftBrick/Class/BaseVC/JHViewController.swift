//
//  JHBaseViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit

open class JHViewController: UIViewController {
//    deinit {
//        print("JHViewController out")
//    }
    // MARK: - 参数变量
    public lazy var leftBarButton : UIButton = {
        let leftBarButton = UIButton.init(type: .custom)
        leftBarButton.imageView?.contentMode = .center
        leftBarButton.frame = CGRect.init(x: 0, y: 0, width: nav_bar_height, height: nav_bar_height)
        leftBarButton.addTarget(self, action:#selector(goBack) , for: .touchUpInside)
        return leftBarButton
    }()
    
    public lazy var rightBarButton : UIButton = {
        let rightBarButton = UIButton.init(type: .custom)
        rightBarButton.imageView?.contentMode = .center
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: nav_bar_height, height: nav_bar_height)
        return rightBarButton
    }()
    
    // MARK: - 布局
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = L.color("bgColor")
        edgesForExtendedLayout = .all
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        if let viewControllers: [UIViewController] = navigationController?.viewControllers , viewControllers.count > 1{
            addDefaultBackBarButton()
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation 关闭手势返回
    public func closePopGestureRecognizer() {
        let target = navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer.init(target: target, action: nil)
        view.addGestureRecognizer(pan)
    }
    
    // MARK: - 返回方法
     @objc
     public func goBack() {
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
    
    // MARK: - 设置导航栏按钮方法
    /**
    *  修正左侧按钮位置
    */
    func fixSpaceLeftBarButton(btnItem: UIBarButtonItem){
            leftBarButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            leftBarButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            btnItem.imageInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            navigationItem.leftBarButtonItem = btnItem
    }
    
    /**
    *  修正右侧按钮位置
    */
    func fixSpaceRightBarButton(btnItem: UIBarButtonItem){
            rightBarButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
            rightBarButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
            btnItem.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
            navigationItem.rightBarButtonItem = btnItem
      }
    
    /// 设置导航默认返回按钮
    public func addDefaultBackBarButton() {
        addLeftBarButton(normalImage: L.image("nav_ic_back"), highLightImage: L.image("nav_ic_back"))
    }
    
    /// 设置导航左侧按钮图片
    /// - Parameters:
    ///   - normalImage: normalImage
    ///   - highLightImage: highLightImage
    public func addLeftBarButton(normalImage: UIImage? = nil, highLightImage: UIImage? = nil){
        
        comfigLeftBarButton(normalImage: normalImage, highLightImage: highLightImage)
        let btnItem = UIBarButtonItem.init(customView: leftBarButton)
        
        fixSpaceLeftBarButton(btnItem: btnItem)
    }
    
    /// 设置导航左侧按钮文本
    /// - Parameters:
    ///   - text: text
    ///   - normalColor: normalColor
    ///   - highlightColor: highlightColor
    public func addLeftBarButton(text: String,
                                 normalColor: UIColor? = UIColor.BaseUI.textTitleColor,
                                 highlightColor: UIColor? = UIColor.BaseUI.textDesColor){
        
        comfigLeftBarButton(text: text, normalColor: normalColor, highlightColor: highlightColor)
        let btnItem = UIBarButtonItem.init(customView: leftBarButton)
        
        fixSpaceLeftBarButton(btnItem: btnItem)
    }
    
    /// 设置导航右侧按钮图片
    /// - Parameters:
    ///   - normalImage: normalImage
    ///   - highLightImage: highLightImage
    public func addRightBarButton(normalImage: UIImage? = nil, highLightImage: UIImage? = nil){

        comfigRightBarButton(normalImage: normalImage, highLightImage: highLightImage)
        let btnItem = UIBarButtonItem.init(customView: rightBarButton)
        
        fixSpaceRightBarButton(btnItem: btnItem)
    }
    
    /// 设置导航右侧按钮文本
    /// - Parameters:
    ///   - text: text
    ///   - normalColor: normalColor
    ///   - highlightColor: highlightColor
    public func addRightBarButton(text: String,
                                  normalColor: UIColor? = UIColor.BaseUI.textTitleColor,
                                  highlightColor: UIColor? = UIColor.BaseUI.textDesColor){

        comfigRightBarButton(text: text, normalColor: normalColor, highlightColor: highlightColor)
        let btnItem = UIBarButtonItem.init(customView: rightBarButton)
        
        fixSpaceRightBarButton(btnItem: btnItem)
    }
    
    /// 配置左侧导航栏按钮
    /// - Parameters:
    ///   - text: text
    ///   - font: font
    ///   - normalColor: normalColor
    ///   - highlightColor: highlightColor
    ///   - normalImage: normalImage
    ///   - highLightImage: highLightImage
    public func comfigLeftBarButton(text: String? = nil,
                                    font: UIFont? = font_16,
                                    normalColor: UIColor? = UIColor.BaseUI.textTitleColor,
                                    highlightColor: UIColor? = UIColor.BaseUI.textDesColor,
                                    normalImage: UIImage? = nil,
                                    highLightImage: UIImage? = nil){
        
        leftBarButton.titleLabel?.font = font
        leftBarButton.setTitle(text, for: .normal)
        leftBarButton.setTitle(text, for: .highlighted)
        leftBarButton.setTitleColor(normalColor, for: .normal)
        leftBarButton.setTitleColor(highlightColor, for: .highlighted)
        
        leftBarButton.setImage(normalImage, for: .normal)
        leftBarButton.setImage(highLightImage, for: .highlighted)
    }
    
    /// 配置右侧导航栏按钮
    /// - Parameters:
    ///   - text: text
    ///   - font: font
    ///   - normalColor: normalColor
    ///   - highlightColor: highlightColor
    ///   - normalImage: normalImage
    ///   - highLightImage: highLightImage
    public func comfigRightBarButton(text: String? = nil,
                                     font: UIFont? = font_16,
                                     normalColor: UIColor? = nil,
                                     highlightColor: UIColor? = nil,
                                     normalImage: UIImage? = nil,
                                     highLightImage: UIImage? = nil){
        
        rightBarButton.titleLabel?.font = font
        rightBarButton.setTitle(text, for: .normal)
        rightBarButton.setTitle(text, for: .highlighted)
        rightBarButton.setTitleColor(normalColor, for: .normal)
        rightBarButton.setTitleColor(highlightColor, for: .highlighted)
        
        rightBarButton.setImage(normalImage, for: .normal)
        rightBarButton.setImage(highLightImage, for: .highlighted)
    }
}
