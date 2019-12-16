//
//  JHBaseViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit

open class JHViewController: UIViewController {
    // MARK: - 参数变量
    public lazy var leftBarButton : UIButton = {
        let leftBarButton = UIButton.init(type: .custom)
        leftBarButton.imageView?.contentMode = .center
        leftBarButton.frame = CGRect.init(x: 0, y: 0, width: NAVBAR_HEIGHT, height: NAVBAR_HEIGHT)
        return leftBarButton
    }()
    public lazy var rightBarButton : UIButton = {
        let rightBarButton = UIButton.init(type: .custom)
        rightBarButton.imageView?.contentMode = .center
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: NAVBAR_HEIGHT, height: NAVBAR_HEIGHT)
        return rightBarButton
    }()
    // MARK: - 布局
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = .all
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        self.configDefaultBackBarButton()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation 关闭手势返回
    public func closePopGestureRecognizer() {
        let target = self.navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer.init(target: target, action: nil)
        self.view.addGestureRecognizer(pan)
    }
    
    // MARK: - 返回方法
     @objc
     public func goBack() {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count <= 1 else {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        if (self.presentingViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - 设置导航栏按钮方法
    /**
    *  修正左侧按钮位置
    */
    func fixSpaceLeftBarButton(btnItem: UIBarButtonItem){
        if #available(iOS 11.0, *) {
            self.leftBarButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            self.leftBarButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            btnItem.imageInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
            self.navigationItem.leftBarButtonItem = btnItem
        }else{
            let space = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            space.width = -10
            self.navigationItem.leftBarButtonItems = [space,btnItem]
        }
    }
    /**
    *  修正右侧按钮位置
    */
    func fixSpaceRightBarButton(btnItem: UIBarButtonItem){
        if #available(iOS 11.0, *) {
            self.rightBarButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
            self.rightBarButton.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
            btnItem.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -10)
            self.navigationItem.rightBarButtonItem = btnItem
        }else{
            let space = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            space.width = -4
            self.navigationItem.rightBarButtonItems = [space,btnItem]
        }
    }
    /**
    *  设置导航默认返回按钮
    */
    public func configDefaultBackBarButton() {

        self.leftBarButton.setImage(JHImageLoader.loadToolsImage(with: "nav_ic_back"), for: .normal)
        self.leftBarButton.setImage(JHImageLoader.loadToolsImage(with: "nav_ic_back"), for: .highlighted)

        self.leftBarButton.addTarget(self, action:#selector(goBack) , for: .touchUpInside)
        let btnItem = UIBarButtonItem.init(customView: self.leftBarButton)

        self.fixSpaceLeftBarButton(btnItem: btnItem)
    }
    /**
    *  设置导航左侧按钮图片
    *
    *  @param normalImage    正常图片
    *  @param highLightImage 高亮图片
    */
    public func configLeftBarButtonWithImage(normalImage: UIImage, highLightImage: UIImage){
        self.leftBarButton.setImage(normalImage, for: .normal)
        self.leftBarButton.setImage(highLightImage, for: .highlighted)

        self.leftBarButton.addTarget(self, action:#selector(goBack) , for: .touchUpInside)
        let btnItem = UIBarButtonItem.init(customView: self.leftBarButton)
        
        self.fixSpaceLeftBarButton(btnItem: btnItem)
    }
    /**
    *  设置导航左侧按钮文本
    *
    *  @param text 导航按钮文本
    */
    public func configLeftBarButtonWithText(text: String, normalColor: UIColor, highlightColor: UIColor){
        self.leftBarButton.titleLabel?.font = FONT_16
        self.leftBarButton.setTitle(text, for: .normal)
        self.leftBarButton.setTitle(text, for: .highlighted)

        self.leftBarButton.setTitleColor(normalColor, for: .normal)
        self.leftBarButton.setTitleColor(highlightColor, for: .highlighted)

        
        self.leftBarButton.addTarget(self, action:#selector(goBack) , for: .touchUpInside)
        let btnItem = UIBarButtonItem.init(customView: self.leftBarButton)
        
        self.fixSpaceLeftBarButton(btnItem: btnItem)
    }
    
    /**
    *  设置导航右侧按钮图片
    *
    *  @param normalImage    正常图片
    *  @param highLightImage 高亮图片
    */
    public func configRightBarButtonWithImage(normalImage: UIImage, highLightImage: UIImage){
        self.rightBarButton.setImage(normalImage, for: .normal)
        self.rightBarButton.setImage(highLightImage, for: .highlighted)

        let btnItem = UIBarButtonItem.init(customView: self.rightBarButton)
        
        self.fixSpaceRightBarButton(btnItem: btnItem)
    }
 /**
    *  设置导航右侧按钮文本
    *
    *  @param text 导航按钮文本
    */
    public func configRightBarButtonWithText(text: String, normalColor: UIColor, highlightColor: UIColor){
        self.rightBarButton.titleLabel?.font = FONT_16
        self.rightBarButton.setTitle(text, for: .normal)
        self.rightBarButton.setTitle(text, for: .highlighted)
        self.rightBarButton.setTitleColor(normalColor, for: .normal)
        self.rightBarButton.setTitleColor(highlightColor, for: .highlighted)
        let btnItem = UIBarButtonItem.init(customView: self.rightBarButton)
        
        self.fixSpaceRightBarButton(btnItem: btnItem)
    }
}
