//
//  SwiftBrick.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/30.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import UIKit

public struct SwiftBrick{
    ///如果使用导航栏的功能可以全局设置下
    ///统一设置返回按钮图片(默认)
    public static var navBarNorBackImage: UIImage?
    ///统一设置返回按钮图片(按下)
    public static var navBarHigBackImage: UIImage?
    ///导航栏左按钮修正距离,默认按钮距离边缘为20:左移为-,右移为+
    public static var navBarLeftFixSpace: CGFloat = 0
    ///导航栏右按钮修正距离,默认按钮距离边缘为20:左移为+,右移为-
    public static var navBarRightFixSpace: CGFloat = 0
    
    ///当导航栏从隐藏的页面滑动到有导航栏的页面或者从有到无的页面滑动,使过度更加平滑,vc需要隐藏导航栏设置下prefersNavigationBarHidden = true
    public static func navBarSmooth() {
        SwizzleNavBar.swizzle
    }
}

public protocol JHBaseVC{
    
    func hideDefaultBackBarButton()
    
    func fixSpaceLeftBarButton(btnItem: UIBarButtonItem)
    
    func fixSpaceRightBarButton(btnItem: UIBarButtonItem, fixSpace: CGFloat)
    
    func addLeftBarButton(normalImage: UIImage?,
                          highLightImage: UIImage?,
                          touchUp: ButtonClosure?)
    
    func addLeftBarButton(text: String,
                          font: UIFont?,
                          normalColor: UIColor?,
                          highlightColor: UIColor?,
                          touchUp: ButtonClosure?)
    
    func addRightBarButton(normalImage: UIImage?,
                           highLightImage: UIImage?,
                           selectedImage: UIImage?,
                           disableImage: UIImage?,
                           fixSpace: CGFloat,
                           touchUp: ButtonClosure?)
    
    func addRightBarButton(text: String,
                           font: UIFont?,
                           normalColor: UIColor?,
                           highlightColor: UIColor?,
                           selectedColor: UIColor?,
                           disableColor: UIColor?,
                           fixSpace: CGFloat,
                           touchUp: ButtonClosure?)
    
    func configLeftBarButton(text: String?,
                             font: UIFont?,
                             normalColor: UIColor?,
                             highlightColor: UIColor?,
                             normalImage: UIImage?,
                             highLightImage: UIImage?)
    
    func configRightBarButton(text: String?,
                              font: UIFont?,
                              normalColor: UIColor?,
                              highlightColor: UIColor?,
                              selectedColor: UIColor?,
                              disableColor: UIColor?,
                              normalImage: UIImage?,
                              highLightImage: UIImage?,
                              selectedImage: UIImage?,
                              disableImage: UIImage?)
    
}

public extension JHBaseVC where Self: UIViewController {
    
    func hideDefaultBackBarButton(){
        leftBarButton.isHidden = true
        navigationItem.hidesBackButton = true
    }
    
    func addLeftBarButton(normalImage: UIImage?,
                          highLightImage: UIImage?,
                          touchUp: ButtonClosure?){
        
        configLeftBarButton(normalImage: normalImage,
                            highLightImage: highLightImage)
        
        let btnItem = UIBarButtonItem(customView: leftBarButton)
        
        fixSpaceLeftBarButton(btnItem: btnItem)
        guard let ges = touchUp else {
            return
        }
        leftBarButton.addTouchUpInSideBtnAction(touchUp: ges)
    }
    
    func addLeftBarButton(text: String,
                          font: UIFont?,
                          normalColor: UIColor? = nil,
                          highlightColor: UIColor? = nil,
                          touchUp: ButtonClosure?){
        configLeftBarButton(text: text,
                            font: font,
                            normalColor: normalColor,
                            highlightColor: highlightColor)
        let btnItem = UIBarButtonItem(customView: leftBarButton)
        
        fixSpaceLeftBarButton(btnItem: btnItem)
        guard let ges = touchUp else {
            return
        }
        leftBarButton.addTouchUpInSideBtnAction(touchUp: ges)
    }
    
    func addRightBarButton(normalImage: UIImage? = nil,
                           highLightImage: UIImage? = nil,
                           selectedImage: UIImage? = nil,
                           disableImage: UIImage? = nil,
                           fixSpace: CGFloat = 0,
                           touchUp: ButtonClosure?){
        
        configRightBarButton(normalImage: normalImage,
                             highLightImage: highLightImage,
                             selectedImage: selectedImage,
                             disableImage: disableImage)
        let btnItem = UIBarButtonItem(customView: rightBarButton)
        
        fixSpaceRightBarButton(btnItem: btnItem, fixSpace: fixSpace)
        guard let ges = touchUp else {
            return
        }
        rightBarButton.addTouchUpInSideBtnAction(touchUp: ges)
    }
    
    func addRightBarButton(text: String,
                           font: UIFont? = nil,
                           normalColor: UIColor? = nil,
                           highlightColor: UIColor? = nil,
                           selectedColor: UIColor? = nil,
                           disableColor: UIColor? = nil,
                           fixSpace: CGFloat = 0,
                           touchUp: ButtonClosure?){
        configRightBarButton(text: text,
                             font: font,
                             normalColor: normalColor,
                             highlightColor: highlightColor,
                             selectedColor: selectedColor,
                             disableColor: disableColor)
        let btnItem = UIBarButtonItem(customView: rightBarButton)
        
        fixSpaceRightBarButton(btnItem: btnItem, fixSpace: fixSpace)
        guard let ges = touchUp else {
            return
        }
        rightBarButton.addTouchUpInSideBtnAction(touchUp: ges)
    }
    
    func configLeftBarButton(text: String? = nil,
                             font: UIFont? = nil,
                             normalColor: UIColor? = nil,
                             highlightColor: UIColor? = nil,
                             normalImage: UIImage? = nil,
                             highLightImage: UIImage? = nil){
        leftBarButton.titleLabel?.font = font ?? Font14
        leftBarButton.setTitle(text, for: .normal)
        leftBarButton.setTitle(text, for: .highlighted)
        leftBarButton.setTitleColor(normalColor, for: .normal)
        leftBarButton.setTitleColor(highlightColor, for: .highlighted)
        
        leftBarButton.setImage(normalImage, for: .normal)
        leftBarButton.setImage(highLightImage, for: .highlighted)
    }
    
    func configRightBarButton(text: String? = nil,
                              font: UIFont? = nil,
                              normalColor: UIColor? = nil,
                              highlightColor: UIColor? = nil,
                              selectedColor: UIColor? = nil,
                              disableColor: UIColor? = nil,
                              normalImage: UIImage? = nil,
                              highLightImage: UIImage? = nil,
                              selectedImage: UIImage? = nil,
                              disableImage: UIImage? = nil){
        
        rightBarButton.titleLabel?.font = font ?? Font14
        rightBarButton.setTitle(text, for: .normal)
        rightBarButton.setTitle(text, for: .highlighted)
        rightBarButton.setTitle(text, for: .selected)
        rightBarButton.setTitle(text, for: .disabled)
        
        rightBarButton.setTitleColor(normalColor, for: .normal)
        rightBarButton.setTitleColor(highlightColor, for: .highlighted)
        rightBarButton.setTitleColor(selectedColor, for: .selected)
        rightBarButton.setTitleColor(disableColor, for: .disabled)
        
        rightBarButton.setImage(normalImage, for: .normal)
        rightBarButton.setImage(highLightImage, for: .highlighted)
        rightBarButton.setImage(selectedImage, for: .selected)
        rightBarButton.setImage(disableImage, for: .disabled)
    }
    
    func fixSpaceLeftBarButton(btnItem: UIBarButtonItem){
        leftBarButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: SwiftBrick.navBarLeftFixSpace, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = btnItem
    }
    
    func fixSpaceRightBarButton(btnItem: UIBarButtonItem, fixSpace: CGFloat = 0){
        rightBarButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (fixSpace != 0 ? fixSpace: SwiftBrick.navBarRightFixSpace))
        self.navigationItem.rightBarButtonItem = btnItem
    }
}

public extension UIViewController {
    struct AssociatedKeys {
        static var leftButtonKey: String = "ButtonLeftKey"
        static var rightButtonKey: String = "ButtonRightKey"
    }
    
    var leftBarButton: UIButton {
        get {
            var button = UIButton(type: .custom)
            button.imageView?.contentMode = .center
            button.frame = CGRect(x: 0, y: 0, width: 0, height: NavBarHeight())
            if let b = objc_getAssociatedObject(self, &AssociatedKeys.leftButtonKey) as? UIButton {
                button = b
            } else {
                objc_setAssociatedObject(self, &AssociatedKeys.leftButtonKey, button, .OBJC_ASSOCIATION_RETAIN)
            }
            return button
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.leftButtonKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var rightBarButton: UIButton {
        get {
            var button = UIButton(type: .custom)
            button.imageView?.contentMode = .center
            button.frame = CGRect(x: 0, y: 0, width: 0, height: NavBarHeight())
            if let b = objc_getAssociatedObject(self, &AssociatedKeys.rightButtonKey) as? UIButton {
                button = b
            } else {
                objc_setAssociatedObject(self, &AssociatedKeys.rightButtonKey, button, .OBJC_ASSOCIATION_RETAIN)
            }
            return button
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rightButtonKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
