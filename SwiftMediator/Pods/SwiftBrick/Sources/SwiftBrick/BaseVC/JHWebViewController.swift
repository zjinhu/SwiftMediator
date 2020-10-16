//
//  JHBaseWebViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

open class JHWebViewController: JHViewController ,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate{

    // MARK: - 参数变量
    public dynamic lazy var webView : WKWebView = {
        let webView = WKWebView.init(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { (obj: Any?, error: Error?) in
            guard let ua = obj as? String else {
                return
            }
            
            guard let new = self.customUserAgent else {
                return
            }
            webView.customUserAgent = "\(ua);\(new)"
        })
        return webView
    }()
    
    public lazy var reloadButton : UIButton  = {
        let reloadButton = UIButton.init(type: .custom)
        reloadButton.frame = view.bounds
        reloadButton.setTitle("加载失败,请点击重试", for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadWebView), for: .touchUpInside)
        return reloadButton
    }()
    
    lazy var loadingProgressView : UIProgressView = {
        let progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 4))
        progressView.trackTintColor = .clear
        progressView.tintColor = .red
        return progressView
    }()
    
    lazy var config : WKWebViewConfiguration = {
        let preferences = WKPreferences.init()
//        preferences.minimumFontSize = 0.0
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let processPool = WKProcessPool.init()
        
        let config = WKWebViewConfiguration.init()
        if #available(iOS 13.0, *){
            config.defaultWebpagePreferences.preferredContentMode = .mobile
            
        }
        
        if #available(iOS 14.0, *){
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        }else{
            preferences.javaScriptEnabled = true
        }
        
        config.userContentController = WKUserContentController.init()
        config.preferences = preferences
        config.processPool = processPool
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true


        return config
    }()
    
    public var closeWebPopGesture : Bool? {
        didSet{
            guard let close = closeWebPopGesture else {
                return
            }
            webView.allowsBackForwardNavigationGestures = close
        }
    }
    
    public var injectCookie : (key :String, value :String)? {
        didSet{
            guard let cookie = injectCookie else {
                return
            }
            let cookieStr = String.init(format: "%@=%@", cookie.key , cookie.value)
            let jsStr = String.init(format: "document.cookie = '%@';", cookieStr)
            ///js方式
            let script = WKUserScript.init(source: jsStr, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            config.userContentController.addUserScript(script)
            ///PHP方式
            request?.setValue(cookieStr, forHTTPHeaderField: "Cookie")
        }
    }
    
    /// 设置导航栏标题
    @objc public var navTitle : String?
    /// 访问地址
    @objc public var urlString : String?
    /// 添加userAgent标记,会拼接;
    @objc public var customUserAgent : String?
    /// 自定义请求
    @objc public var request : URLRequest?
    /// 获取当前地址
    public var currentUrl : String?
    
    // MARK: - 初始化
    public convenience init(urlString url: String) {
        self.init()
        urlString = url
    }
    
    public convenience init(urlString url: String, cookie: Dictionary<String, String>) {
        self.init()
        guard let urlReal = URL.init(string: url) else {
            return
        }
        urlString = url
        var req = URLRequest.init(url: urlReal)
        var cookieStr = ""
        if cookie.count > 0 {
            for (key,value) in cookie {
                cookieStr += String.init(format: "%@=%@;", key , value)
            }
        }
        if cookieStr.count > 1 {
            req.addValue(cookieStr, forHTTPHeaderField: "Cookie")
        }
        request = req
    }
    
    public convenience init(request req: URLRequest) {
        self.init()
        request = req
    }
    
    // MARK: - 布局
    override open func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = [.left,.right,.bottom]
        
        title = navTitle
        
        view.addSubview(reloadButton)
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaInsets.top)
            make.left.equalTo(view.safeAreaInsets.left)
            make.right.equalTo(view.safeAreaInsets.right)
            make.bottom.equalTo(view.safeAreaInsets.bottom)
        }
        
        view.addSubview(loadingProgressView)
        
        webView.configuration.userContentController.add(WeakScriptMessageDelegate.init(delegate: self), name: "JumpViewController")
        
        loadRequest()
        //        self.webView?.evaluateJavaScript("navigator.userAgent") {[weak self] (result, error) in
        //         if let agent = result as? String {
        //            self?.webView?.customUserAgent = agent + " customAgent"
        //         }
        //        // 为estimatedProgress添加KVO
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.old, .new], context: nil)
    }
    
    // MARK: - WKScriptMessageHandler JS调用原生交互
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint("\(message.name)-\(message.body)")
        switch message.name {
        case "JumpViewController":
            debugPrint("JumpViewController")
        default:
            debugPrint("")
        }
    }
    
    // MARK: - WKNavigationDelegate
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.targetFrame == nil{
            webView.load(navigationAction.request)
        }
        
        if let cUrl = navigationAction.request.url{
            let urlString = cUrl.absoluteString
            currentUrl = urlString
            let scheme = cUrl.scheme
            switch scheme {
            case "tel":
                if UIApplication.shared.canOpenURL(cUrl) {
                    UIApplication.shared.open(cUrl, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
                    return
                }
            default:
                print("")
            }
        }
        
        decisionHandler(.allow)
    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.isHidden = false
        loadingProgressView.isHidden = false
        if webView.url?.scheme == "about" {
            webView.isHidden = true
        }
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        //        self.loadingProgressView.isHidden = true
        webView.evaluateJavaScript("document.title") { (result, error) in
            self.navigationItem.title = result as? String
        }
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            debugPrint("\(String(describing: result))")
        }
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.isHidden = true
        loadingProgressView.isHidden = false
    }
    
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    // MARK: - WKUIDelegate
    
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_)in
            // We must call back js
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_)in
            // We must call back js
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_)in
            // We must call back js
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.textColor = .black
            textField.placeholder = defaultText
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_)in
            // We must call back js
            completionHandler(alert.textFields?.last?.text)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_)in
            // We must call back js
            completionHandler(nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 监听进度条
    //    func setupObserver(){
    //        progressObervation = webView.observe(\.estimatedProgress, options: .new, changeHandler: { (self, change) in
    //            let newValue = change.newValue  ?? 0
    //            print("new value is \(newValue)")
    //            changeLoadingProgress(progress : Float(newValue))
    //        })
    //    }
    // 监听网络加载进度，加载过程中在navigationBar显示加载进度，加载完成显示网站标题
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let webView = object as? WKWebView, webView == webView && keyPath == "estimatedProgress" {
            
            guard let changes = change else { return }
            //  请注意这里读取options中数值的方法
            let newValue = changes[NSKeyValueChangeKey.newKey] as? Double ?? 0
            let oldValue = changes[NSKeyValueChangeKey.oldKey] as? Double ?? 0
            
            // 因为我们已经设置了进度条为0.1，所以只有在进度大于0.1后再进行变化
            if newValue > oldValue && newValue > 0.1 {
                loadingProgressView.setProgress(Float.init(newValue), animated: true)
            }
            // 当进度为100%时，隐藏progressLayer并将其初始值改为0
            if newValue == 1.0 {
                let time1 = DispatchTime.now() + 0.4
                let time2 = time1 + 0.1
                DispatchQueue.main.asyncAfter(deadline: time1) {
                    self.loadingProgressView.progress = 1
                }
                DispatchQueue.main.asyncAfter(deadline: time2) {
                    self.loadingProgressView.isHidden = true
                    self.loadingProgressView.progress = 0
                }
            }
        }
    }
    
    // MARK: - 发起请求
    open func loadRequest() {
        
        if let re = request {
            webView.load(re)
        }else if let url = urlString, let realURL = URL.init(string: url) {
            webView.load(URLRequest.init(url: realURL))
        }
    }
    
    // MARK: - 方法
    ///重写父类返回方法
    open override func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            closeVC()
        }
    }
    
    ///关闭当前VC
    open func closeVC() {
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
    
    ///reload按钮点击
    @objc func reloadWebView(){
        loadingProgressView.progress = 0
        loadingProgressView.isHidden = false
        guard let url = currentUrl, let realURL = URL.init(string: url) else{
            return
        }
        webView.load(URLRequest.init(url: realURL))
    }
    
    // MARK: - 生命周期结束 清理
    deinit{
        cleanAllWebsiteDataStore()
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
//        print("JHWebViewController out")
    }
    
    func cleanAllWebsiteDataStore() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let modifiedSince = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: modifiedSince) {
            debugPrint("清理完成")
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}

// MARK: - WeakScriptMessageDelegate
class WeakScriptMessageDelegate : NSObject, WKScriptMessageHandler {
    
    weak var delegate: WKScriptMessageHandler?
    init(delegate dele: WKScriptMessageHandler) {
        delegate = dele
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        delegate?.userContentController(
            userContentController, didReceive: message)
    }
}
