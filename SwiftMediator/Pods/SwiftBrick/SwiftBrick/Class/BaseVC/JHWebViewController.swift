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
        let webView = WKWebView.init(frame: .zero, configuration: self.config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    public lazy var reloadButton : UIButton  = {
        let reloadButton = UIButton.init(type: .custom)
        reloadButton.frame = self.view.bounds
        reloadButton.setTitle("加载失败,请点击重试", for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadWebView), for: .touchUpInside)
        return reloadButton
    }()
    
    lazy var loadingProgressView : UIProgressView = {
        let progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 4))
        progressView.trackTintColor = .clear
        progressView.tintColor = .red
        return progressView
    }()

    lazy var config : WKWebViewConfiguration = {
        let preferences = WKPreferences.init()
        preferences.minimumFontSize = 0.0
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let processPool = WKProcessPool.init()

        let config = WKWebViewConfiguration.init()
        config.userContentController = WKUserContentController.init()
        config.preferences = preferences
        config.processPool = processPool
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        return config
    }()
    
    public var closeWebPopGesture : Bool? {
        didSet{
            self.webView.allowsBackForwardNavigationGestures = closeWebPopGesture!
        }
    }
    
    public var injectCookie : (key :String, value :String)? {
        didSet{
            let cookieStr = String.init(format: "%@=%@", injectCookie!.key , injectCookie!.value)
            let jsStr = String.init(format: "document.cookie = '%@';", cookieStr)
            ///js方式
            let script = WKUserScript.init(source: jsStr, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            self.config.userContentController.addUserScript(script)
            ///PHP方式
            self.request?.setValue(cookieStr, forHTTPHeaderField: "Cookie")
        }
    }
    
    public var navTitle : String?
    public var url : String?
    public var agent : String? {
        didSet{
            let web = UIWebView.init()
            var oldAgent = web.stringByEvaluatingJavaScript(from: "navigator.userAgent")
            oldAgent! += ";"
            oldAgent! += agent!
            self.webView.customUserAgent = oldAgent
        }
    }

    var request : URLRequest?
    public var currentUrl : String?
    
    // MARK: - 初始化
    public convenience init(url: String) {
        self.init()
        self.url = url
     }
    
    public convenience init(url: String, cookie: Dictionary<String, String>) {
         self.init()
        self.url = url
        var request = URLRequest.init(url: URL.init(string: url)!)
        var cookieStr = ""
        if cookie.count > 0 {
            for (key,value) in cookie {
                cookieStr += String.init(format: "%@=%@;", key , value)
            }
        }
        if cookieStr.count > 1 {
            request.addValue(cookieStr, forHTTPHeaderField: "Cookie")
        }
        self.request = request
     }

    public convenience init(reqyest: URLRequest) {
         self.init()
        self.request = request
     }
    
    
    // MARK: - 布局
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [.left,.right,.bottom]
        
        self.title = self.navTitle
        
        self.view.addSubview(self.reloadButton)
        
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view.safeAreaInsets.top );
            make.left.equalTo(self.view.safeAreaInsets.left);
            make.right.equalTo(self.view.safeAreaInsets.right);
            make.bottom.equalTo(self.view.safeAreaInsets.bottom);
        })
        
        self.view.addSubview(self.loadingProgressView)

        self.webView.configuration.userContentController.add(WeakScriptMessageDelegate.init(delegate: self), name: "JumpViewController")
        
        self.loadRequest()
//        self.webView?.evaluateJavaScript("navigator.userAgent") {[weak self] (result, error) in
//         if let agent = result as? String {
//            self?.webView?.customUserAgent = agent + " customAgent"
//         }
//        // 为estimatedProgress添加KVO
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.old, .new], context: nil)
    }
    // MARK: - WKScriptMessageHandler JS调用原生交互
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        SLog("%@--%@",file: message.name,funcName: message.body as! String)
        switch message.name {
        case "JumpViewController":
            SLog("JumpViewController")
        default:
            SLog("")
        }
    }
    // MARK: - WKNavigationDelegate
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.targetFrame == nil{
            webView.load(navigationAction.request)
        }
        
        let cUrl = navigationAction.request.url
        let urlString = cUrl?.absoluteString
        self.currentUrl = urlString
        let scheme = cUrl?.scheme
        switch scheme {
        case "tel":
            if UIApplication.shared.canOpenURL(cUrl!) {
                UIApplication.shared.open(cUrl!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        default:
            print("")
        }
        decisionHandler(.allow)
    }
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.webView.isHidden = false
        self.loadingProgressView.isHidden = false
        if webView.url?.scheme == "about" {
            webView.isHidden = true
        }
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.isHidden = false
//        self.loadingProgressView.isHidden = true
        webView.evaluateJavaScript("document.title") { (result, error) in
            self.navigationItem.title = result as? String
        }
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
            SLog(result)
        }
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webView.isHidden = true
        self.loadingProgressView.isHidden = false
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
        self.present(alert, animated: true, completion: nil)
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
        self.present(alert, animated: true, completion: nil)
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
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - 监听进度条
//    func setupObserver(){
//        progressObervation = self.webView.observe(\.estimatedProgress, options: .new, changeHandler: { (self, change) in
//            let newValue = change.newValue  ?? 0
//            print("new value is \(newValue)")
//            self.changeLoadingProgress(progress : Float(newValue))
//        })
//    }
// 监听网络加载进度，加载过程中在navigationBar显示加载进度，加载完成显示网站标题
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let webView = object as? WKWebView, webView == self.webView && keyPath == "estimatedProgress" {
            
            guard let changes = change else { return }
            //  请注意这里读取options中数值的方法
            let newValue = changes[NSKeyValueChangeKey.newKey] as? Double ?? 0
            let oldValue = changes[NSKeyValueChangeKey.oldKey] as? Double ?? 0
            
            // 因为我们已经设置了进度条为0.1，所以只有在进度大于0.1后再进行变化
            if newValue > oldValue && newValue > 0.1 {
                self.loadingProgressView.setProgress(Float.init(newValue), animated: true)
            }
            // 当进度为100%时，隐藏progressLayer并将其初始值改为0
            if newValue == 1.0 {
                let time1 = DispatchTime.now() + 0.4
                let time2 = time1 + 0.1
                DispatchQueue.main.asyncAfter(deadline: time1) {
                    weak var weakself = self
                    weakself?.loadingProgressView.progress = 1
                }
                DispatchQueue.main.asyncAfter(deadline: time2) {
                    weak var weakself = self
                    weakself?.loadingProgressView.isHidden = true
                    weakself?.loadingProgressView.progress = 0
                }
            }
        }
    }
    // MARK: - 发起请求
    open func loadRequest() {
        if self.request != nil {
            self.webView.load(self.request!)
        }else{
            self.webView.load(URLRequest.init(url: URL.init(string: self.url!)!))
        }
    }
    // MARK: - 方法
    ///重写父类返回方法
    open override func goBack() {
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.closeVC()
        }
    }
    ///关闭当前VC
    open func closeVC() {
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
    ///reload按钮点击
    @objc func reloadWebView(){
        self.loadingProgressView.progress = 0
        self.loadingProgressView.isHidden = false
        self.webView.load(URLRequest.init(url: URL.init(string: self.currentUrl!)!))
    }

    // MARK: - 生命周期结束 清理
    deinit{
        self.cleanAllWebsiteDataStore()
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.uiDelegate = nil
        self.webView.navigationDelegate = nil
        self.webView.scrollView.delegate = nil
    }
    
    func cleanAllWebsiteDataStore() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let modifiedSince = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: modifiedSince) {
            SLog("清理完成")
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}

// MARK: - WeakScriptMessageDelegate
class WeakScriptMessageDelegate : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(
            userContentController, didReceive: message)
    }
}
