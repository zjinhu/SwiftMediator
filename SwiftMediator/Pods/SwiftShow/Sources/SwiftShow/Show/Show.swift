//
//  Show.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
//MARK: --Toast
extension Show{
    public typealias ConfigToast = ((_ config : ShowToastConfig) -> Void)
    
    /// 在屏幕中间展示toast
    /// - Parameters:
    ///   - text: 文案
    ///   - image: 图片
    public class func showToast(_ text: String, image: UIImage? = nil, config : ConfigToast? = nil){
        let model = ShowToastConfig()
        if let _ = image{
            model.space = 10
        }
        config?(model)
        toast(text: text, image: image, config: model)
    }
    
    private class func toast(text: String, image: UIImage? = nil, config: ShowToastConfig){
        
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: ToastView.self){
                view.removeFromSuperview()
            }
        }
        
        let toast = ToastView.init(config)
        toast.title = text
        toast.image = image
        getWindow().addSubview(toast)
        toast.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            switch config.offSetType {
            case .center:
                make.centerY.equalToSuperview()
            case .top:
                make.top.equalToSuperview().offset(config.offSet)
            case .bottom:
                make.bottom.equalToSuperview().offset(-config.offSet)
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + config.showTime) {
            UIView.animate(withDuration: config.animateDuration, animations: {
                toast.alpha = 0
            }) { (_) in
                toast.removeFromSuperview()
            }
        }
    }
}
////MARK: --Loading
extension Show{
    public typealias ConfigLoading = ((_ config : ShowLoadingConfig) -> Void)
    
    /// 在当前VC中展示loading
    /// - Parameters:
    ///   - text: 文本
    ///   - config: 配置
    public class func showLoading(_ text : String? = nil, config : ConfigLoading? = nil) {
        guard let vc = currentViewController() else {
            return
        }
        
        let model = ShowLoadingConfig()
        if let title = text , title.count > 0 {
            model.space = 10
        }
        config?(model)
        loading(text, onView: vc.view, config: model)
    }
    
    /// 隐藏上层VC中的loading
    public class func hiddenLoading() {
        guard let vc = currentViewController() else {
            return
        }
        hiddenLoadingOnView(vc.view)
    }
    
    /// 在window中展示loading
    /// - Parameters:
    ///   - text: 文本
    ///   - config: 配置
    public class func showLoadingOnWindow(_ text : String? = nil, config : ConfigLoading? = nil){
        let model = ShowLoadingConfig()
        config?(model)
        loading(text, onView: getWindow(), config: model)
    }
    
    /// 隐藏window中loading
    public class func hiddenLoadingOnWindow() {
        hiddenLoadingOnView(getWindow())
    }
    
    /// 在指定view中添加loading
    /// - Parameters:
    ///   - onView: view
    ///   - text: 文本
    ///   - config: 配置
    public class func showLoadingOnView(_ onView: UIView, text : String? = nil, config : ConfigLoading? = nil){
        let model = ShowLoadingConfig()
        config?(model)
        loading(text, onView: onView, config: model)
    }
    
    /// 隐藏指定view中loading
    /// - Parameter onView: view
    public class func hiddenLoadingOnView(_ onView: UIView) {
        onView.subviews.forEach { (view) in
            if view.isKind(of: LoadingView.self){
                view.removeFromSuperview()
            }
        }
    }
    
    private class func loading(_ text: String? = nil, onView: UIView? = nil, config : ShowLoadingConfig) {
        let loadingView = LoadingView.init(config)
        loadingView.title = text
        loadingView.isUserInteractionEnabled = !config.enableEvent
        if let base = onView{
            hiddenLoadingOnView(base)
            base.addSubview(loadingView)
            base.bringSubviewToFront(loadingView)
            loadingView.layer.zPosition = CGFloat(MAXFLOAT)
        }else{
            hiddenLoadingOnWindow()
            getWindow().addSubview(loadingView)
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
}
////MARK: --Alert
extension Show{
    
    public typealias ConfigAlert = ((_ config : ShowAlertConfig) -> Void)
    
    public class func showAlert(title: String? = nil,
                                message: String?  = nil,
                                leftBtnTitle: String? = nil,
                                rightBtnTitle: String? = nil,
                                leftBlock: LeftCallBack? = nil,
                                rightBlock: RightCallback? = nil) {
        showCustomAlert(title: title,
                        message: message,
                        leftBtnTitle: leftBtnTitle,
                        rightBtnTitle: rightBtnTitle,
                        leftBlock: leftBlock,
                        rightBlock: rightBlock)
    }
    
    public class func showAttributedAlert(attributedTitle : NSAttributedString? = nil,
                                          attributedMessage : NSAttributedString? = nil,
                                          leftBtnAttributedTitle: NSAttributedString? = nil,
                                          rightBtnAttributedTitle: NSAttributedString? = nil,
                                          leftBlock: LeftCallBack? = nil,
                                          rightBlock: RightCallback? = nil) {
        showCustomAlert(attributedTitle: attributedTitle,
                        attributedMessage: attributedMessage,
                        leftBtnAttributedTitle: leftBtnAttributedTitle,
                        rightBtnAttributedTitle: rightBtnAttributedTitle,
                        leftBlock: leftBlock,
                        rightBlock: rightBlock)
    }
    
    public class func showCustomAlert(title: String? = nil,
                                      attributedTitle : NSAttributedString? = nil,
                                      titleImage: UIImage? = nil,
                                      message: String?  = nil,
                                      attributedMessage : NSAttributedString? = nil,
                                      leftBtnTitle: String? = nil,
                                      leftBtnAttributedTitle: NSAttributedString? = nil,
                                      rightBtnTitle: String? = nil,
                                      rightBtnAttributedTitle: NSAttributedString? = nil,
                                      leftBlock: LeftCallBack? = nil,
                                      rightBlock: RightCallback? = nil,
                                      config : ConfigAlert? = nil) {
        hiddenAlert()
        
        let model = ShowAlertConfig()
        if let _ = titleImage{
            model.space = 10
        }
        config?(model)
        
        let alertView = AlertView.init(title: title,
                                       attributedTitle: attributedTitle,
                                       titleImage: titleImage,
                                       message: message,
                                       attributedMessage: attributedMessage,
                                       leftBtnTitle: leftBtnTitle,
                                       leftBtnAttributedTitle: leftBtnAttributedTitle,
                                       rightBtnTitle: rightBtnTitle,
                                       rightBtnAttributedTitle: rightBtnAttributedTitle,
                                       config: model)
        alertView.leftBlock = leftBlock
        alertView.rightBlock = rightBlock
        alertView.dismissBlock = {
            hiddenAlert()
        }
        getWindow().addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    public class func hiddenAlert() {
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: AlertView.self){
                
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0
                }) { (_) in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
}

//MARK: --pop
extension Show{
    public typealias ConfigPop = ((_ config : ShowPopViewConfig) -> Void)
    
    /// 弹出view
    /// - Parameters:
    ///   - contentView: 被弹出的view
    ///   - config: 配置信息
    public class func showPopView(contentView: UIView,
                                  config : ConfigPop? = nil,
                                  showClosure: CallBack? = nil,
                                  hideClosure: CallBack? = nil) {
        

        
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: PopView.self){
                view.removeFromSuperview()
            }
        }
        
        showPopCallBack = showClosure
        hidePopCallBack = hideClosure
        
        let model = ShowPopViewConfig()
        config?(model)
        
        let popView = PopView.init(contentView: contentView, config: model) {
            hidenPopView()
        }
        
        getWindow().addSubview(popView)
        
        popView.showAnimate()
     
        showPopCallBack?()
    }
    
    public class func hidenPopView(_ complete : (() -> Void)? = nil ) {
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: PopView.self){
                let popView : PopView = view as! PopView
                popView.hideAnimate {
                    UIView.animate(withDuration: 0.1, animations: {
                        view.alpha = 0
                    }) { (_) in
                        complete?()
                        view.removeFromSuperview()
                        hidePopCallBack?()
                    }
                }
            }
        }
    }
    
}

//MARK: --DropDown
extension Show{
    
    /// 弹出下拉视图,盖住Tabbar
    /// - Parameters:
    ///   - contentView: view
    ///   - config: 配置
    public class func showCoverTabbarView(contentView: UIView,
                                          config: ((_ config : ShowDropDownConfig) -> Void)? = nil,
                                          showClosure: CallBack? = nil,
                                          hideClosure: CallBack? = nil,
                                          willShowClosure: CallBack? = nil,
                                          willHideClosure: CallBack? = nil) {

        if !isHaveCoverTabbarView() {
            
            showCoverCallBack = showClosure
            hideCoverCallBack = hideClosure
            willShowCoverCallBack = willShowClosure
            willHideCoverCallBack = willHideClosure
            
            willShowCoverCallBack?()
            let model = ShowDropDownConfig()
            config?(model)
            
            let popView = DropDownView.init(contentView: contentView, config: model) {
                hidenCoverTabbarView()
            }
            
            getWindow().rootViewController?.view.addSubview(popView)
            
            popView.showAnimate {
                showCoverCallBack?()
            }
            
        }
        
    }
    
    public class func isHaveCoverTabbarView() -> Bool{
        var isHave = false
        getWindow().rootViewController?.view.subviews.forEach { (view) in
            if view.isKind(of: DropDownView.self){
                isHave = true
            }
        }
        return isHave
    }
    
    public class func hidenCoverTabbarView(_ complete : (() -> Void)? = nil ) {
        getWindow().rootViewController?.view.subviews.forEach { (view) in
            if view.isKind(of: DropDownView.self){
                let popView : DropDownView = view as! DropDownView
                willHideCoverCallBack?()
                popView.hideAnimate {
                    UIView.animate(withDuration: 0.1, animations: {
                        view.alpha = 0
                    }) { (_) in
                        complete?()
                        view.removeFromSuperview()
                        hideCoverCallBack?()
                    }
                }
            }
        }
    }
    
}

//MARK: -- 获取最上层视图
public class Show{
    
    public typealias CallBack = () -> Void
    
    private static var showCoverCallBack : CallBack?
    private static var hideCoverCallBack : CallBack?
    private static var willShowCoverCallBack : CallBack?
    private static var willHideCoverCallBack : CallBack?
    
    private static var showPopCallBack : CallBack?
    private static var hidePopCallBack : CallBack?
    
    private class func getWindow() -> UIWindow {
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        return window!
    }
    
    /// 获取顶层VC 根据window
    public class func currentViewController() -> (UIViewController?) {
        let vc = getWindow().rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }
    
    ///根据控制器获取 顶层控制器 递归
    private class func getCurrentViewController(withCurrentVC VC :UIViewController?) -> UIViewController? {
        if VC == nil {
            debugPrint("🌶： 找不到顶层控制器")
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getCurrentViewController(withCurrentVC: presentVC)
        }
        else if let splitVC = VC as? UISplitViewController {
            // UISplitViewController 的跟控制器
            if splitVC.viewControllers.count > 0 {
                return getCurrentViewController(withCurrentVC: splitVC.viewControllers.last)
            }else{
                return VC
            }
        }
        else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if tabVC.viewControllers != nil {
                return getCurrentViewController(withCurrentVC: tabVC.selectedViewController)
            }else{
                return VC
            }
        }
        else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            if naiVC.viewControllers.count > 0 {
                //                return getCurrentViewController(withCurrentVC: naiVC.topViewController)
                return getCurrentViewController(withCurrentVC:naiVC.visibleViewController)
            }else{
                return VC
            }
        }
        else {
            // 返回顶控制器
            return VC
        }
    }
}
