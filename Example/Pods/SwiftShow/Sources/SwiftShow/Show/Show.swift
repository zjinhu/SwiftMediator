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
    ///适配器回调,用于给适配器参数赋值
    public typealias ConfigToast = ((_ config : ShowToastConfig) -> Void)
    
    /// 展示toast
    /// - Parameters:
    ///   - text: 文本
    ///   - image: 图片
    ///   - config: toast适配器
    public class func toast(_ title: String,
                            subTitle: String? = nil,
                            image: UIImage? = nil,
                            config : ConfigToast? = nil){
        let model = ShowToastConfig()
        config?(model)
        showToast(title: title, subTitle: subTitle, image: image, config: model)
    }
    
    private class func showToast(title: String,
                                 subTitle: String? = nil,
                                 image: UIImage? = nil,
                                 config: ShowToastConfig){
        
        getWindow().subviews.forEach { (view) in
            if view.isKind(of: ToastView.self){
                view.removeFromSuperview()
            }
        }
        
        let toast = ToastView(title: title, subTitle: subTitle, image: image, config: config)
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
    ///适配器回调,用于给适配器参数赋值
    public typealias ConfigLoading = ((_ config : ShowLoadingConfig) -> Void)
    
    /// 在当前VC中展示loading
    /// - Parameters:
    ///   - text: 文本
    ///   - config: loading适配器
    public class func loading(_ title : String? = nil,
                              subTitle: String? = nil,
                              config : ConfigLoading? = nil) {
        guard let vc = currentViewController() else {
            return
        }
        
        let model = ShowLoadingConfig()
        config?(model)
        loading(title: title, subTitle: subTitle, onView: vc.view, config: model)
    }
    
    /// 手动隐藏上层VC中的loading
    public class func hideLoading() {
        guard let vc = currentViewController() else {
            return
        }
        hideLoadingOnView(vc.view)
    }
    
    /// 在window中展示loading
    /// - Parameters:
    ///   - text: 文本
    ///   - config: 配置
    public class func loadingOnWindow(_ title : String? = nil,
                                      subTitle: String? = nil,
                                      config : ConfigLoading? = nil){
        let model = ShowLoadingConfig()
        config?(model)
        loading(title: title, subTitle: subTitle, onView: getWindow(), config: model)
    }
    
    /// 手动隐藏window中loading
    public class func hideLoadingOnWindow() {
        hideLoadingOnView(getWindow())
    }
    
    /// 在指定view中添加loading
    /// - Parameters:
    ///   - onView: view
    ///   - text: 文本
    ///   - config: 配置
    public class func loadingOnView(_ onView: UIView,
                                    title : String? = nil,
                                    subTitle: String? = nil,
                                    config : ConfigLoading? = nil){
        let model = ShowLoadingConfig()
        config?(model)
        loading(title: title, subTitle: subTitle, onView: onView, config: model)
    }
    
    /// 手动隐藏指定view中loading
    /// - Parameter onView: view
    public class func hideLoadingOnView(_ onView: UIView) {
        onView.subviews.forEach { (view) in
            if view.isKind(of: LoadingView.self){
                view.removeFromSuperview()
            }
        }
    }
    
    private class func loading(title: String? = nil,
                               subTitle: String? = nil,
                               onView: UIView? = nil,
                               config : ShowLoadingConfig) {
        let loadingView = LoadingView(title: title, subTitle: subTitle, config: config)
        loadingView.isUserInteractionEnabled = !config.enableEvent
        if let base = onView{
            hideLoadingOnView(base)
            base.addSubview(loadingView)
            base.bringSubviewToFront(loadingView)
            loadingView.layer.zPosition = CGFloat(MAXFLOAT)
        }else{
            hideLoadingOnWindow()
            getWindow().addSubview(loadingView)
        }
        
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
}
//////MARK: --Alert
extension Show{
    ///适配器回调,用于给适配器参数赋值
    public typealias ConfigAlert = ((_ config : ShowAlertConfig) -> Void)
    
    /// 默认样式Alert
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 信息
    ///   - leftBtnTitle: 左侧按钮标题
    ///   - rightBtnTitle: 右侧按钮标题
    ///   - leftBlock: 左侧按钮回调
    ///   - rightBlock: 右侧按钮回调
    public class func alert(title: String? = nil,
                            message: String?  = nil,
                            leftBtnTitle: String? = nil,
                            rightBtnTitle: String? = nil,
                            leftBlock: LeftCallBack? = nil,
                            rightBlock: RightCallback? = nil) {
        customAlert(title: title,
                    message: message,
                    leftBtnTitle: leftBtnTitle,
                    rightBtnTitle: rightBtnTitle,
                    leftBlock: leftBlock,
                    rightBlock: rightBlock)
    }
    
    /// 富文本样式Alert
    /// - Parameters:
    ///   - attributedTitle: 富文本标题
    ///   - attributedMessage: 富文本信息
    ///   - leftBtnAttributedTitle: 富文本左侧按钮标题
    ///   - rightBtnAttributedTitle: 富文本右侧按钮标题
    ///   - leftBlock: 左侧按钮回调
    ///   - rightBlock: 右侧按钮回调
    public class func attributedAlert(attributedTitle : NSAttributedString? = nil,
                                      attributedMessage : NSAttributedString? = nil,
                                      leftBtnAttributedTitle: NSAttributedString? = nil,
                                      rightBtnAttributedTitle: NSAttributedString? = nil,
                                      leftBlock: LeftCallBack? = nil,
                                      rightBlock: RightCallback? = nil) {
        customAlert(attributedTitle: attributedTitle,
                    attributedMessage: attributedMessage,
                    leftBtnAttributedTitle: leftBtnAttributedTitle,
                    rightBtnAttributedTitle: rightBtnAttributedTitle,
                    leftBlock: leftBlock,
                    rightBlock: rightBlock)
    }
    
    /// 自定义Alert
    /// - Parameters:
    ///   - title: 标题
    ///   - attributedTitle: 富文本标题
    ///   - titleImage: 顶图
    ///   - message: 信息
    ///   - attributedMessage: 富文本信息
    ///   - leftBtnTitle: 左侧按钮标题
    ///   - leftBtnAttributedTitle: 富文本左侧按钮标题
    ///   - rightBtnTitle: 右侧按钮标题
    ///   - rightBtnAttributedTitle: 富文本右侧按钮标题
    ///   - leftBlock:  左侧按钮回调
    ///   - rightBlock: 右侧按钮回调
    ///   - config: Alert适配器，不传为默认样式
    public class func customAlert(title: String? = nil,
                                  attributedTitle : NSAttributedString? = nil,
                                  image: UIImage? = nil,
                                  message: String?  = nil,
                                  attributedMessage : NSAttributedString? = nil,
                                  leftBtnTitle: String? = nil,
                                  leftBtnAttributedTitle: NSAttributedString? = nil,
                                  rightBtnTitle: String? = nil,
                                  rightBtnAttributedTitle: NSAttributedString? = nil,
                                  leftBlock: LeftCallBack? = nil,
                                  rightBlock: RightCallback? = nil,
                                  config : ConfigAlert? = nil) {
        hideAlert()
        
        let model = ShowAlertConfig()
        config?(model)
        
        let alertView = AlertView(title: title,
                                  attributedTitle: attributedTitle,
                                  image: image,
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
            hideAlert()
        }
        getWindow().addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    /// 手动隐藏Alert
    public class func hideAlert() {
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
    ///适配器回调,用于给适配器参数赋值
    public typealias ConfigPop = ((_ config : ShowPopViewConfig) -> Void)
    
    
    /// 弹出view
    /// - Parameters:
    ///   - contentView: 被弹出的View
    ///   - config: popview适配器
    ///   - showClosure: 弹出回调
    ///   - hideClosure: 收起回调
    public class func pop(_ contentView: UIView,
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
            hidePop()
        }
        
        getWindow().addSubview(popView)
        
        popView.showAnimate()
        
        showPopCallBack?()
    }
    
    /// 手动收起popview
    /// - Parameter complete: 完成回调
    public class func hidePop(_ complete : (() -> Void)? = nil ) {
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
    
    /// 从NavBar或VC的view中弹出下拉视图,可以盖住Tabbar
    /// - Parameters:
    ///   - contentView: 被弹出的view
    ///   - config: 适配器回调
    ///   - showClosure: 展示回调
    ///   - hideClosure: 隐藏回调
    ///   - willShowClosure: 即将展示回调
    ///   - willHideClosure: 即将收起回调
    public class func coverTabbar(_ contentView: UIView,
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
                hideCoverTabbar()
            }
            
            getWindow().rootViewController?.view.addSubview(popView)
            
            popView.showAnimate {
                showCoverCallBack?()
            }
            
        }
        
    }
    
    /// 当前是否正在展示DropDown
    /// - Returns: true/false
    public class func isHaveCoverTabbarView() -> Bool{
        var isHave = false
        getWindow().rootViewController?.view.subviews.forEach { (view) in
            if view.isKind(of: DropDownView.self){
                isHave = true
            }
        }
        return isHave
    }
    
    /// 手动隐藏DropDown
    /// - Parameter complete: 完成回调
    public class func hideCoverTabbar(_ complete : (() -> Void)? = nil ) {
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
    /// 通用回调
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
    public class func currentViewController() -> UIViewController? {
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
