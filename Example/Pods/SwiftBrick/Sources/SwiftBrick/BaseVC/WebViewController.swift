//
//  JHBaseWebViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
import WebKit
// MARK: ===================================VC基类:UIWebViewController=========================================
open class WebViewController: ViewController ,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate{

    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.icon_back, for: .normal)
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return btn
    }()
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(.icon_close, for: .normal)
        btn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    // MARK: - 参数变量
    public dynamic lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *){
            webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { [weak self] (obj: Any?, error: Error?) in
            guard let `self` = self else{return}
            guard let ua = obj as? String else { return }
            guard let new = self.customUserAgent else { return }
            webView.customUserAgent = "\(ua);\(new)"
        })
        return webView
    }()
    
    public lazy var reloadButton: UIButton  = {
         let reloadButton = UIButton(type: .custom)
        reloadButton.frame = view.bounds
        reloadButton.setTitle("加载失败,请点击重试", for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadWebView), for: .touchUpInside)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        return reloadButton
    }()
    
    lazy var loadingProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .clear
        progressView.tintColor = .red
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    lazy var config: WKWebViewConfiguration = {
        let preferences = WKPreferences()
//        preferences.minimumFontSize = 0.0
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let processPool = WKProcessPool()
        
        let config = WKWebViewConfiguration()
        
        if #available(iOS 13.0, *){
            config.defaultWebpagePreferences.preferredContentMode = .mobile
        }
        
        if #available(iOS 14.0, *){
            config.defaultWebpagePreferences.allowsContentJavaScript = true
        }else{
            preferences.javaScriptEnabled = true
        }
        
        config.userContentController = WKUserContentController()
        config.preferences = preferences
        config.processPool = processPool
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true

        return config
    }()
    
    public var closeWebPopGesture: Bool? {
        didSet{
            guard let close = closeWebPopGesture else {
                return
            }
            webView.allowsBackForwardNavigationGestures = close
        }
    }
    
    public var injectCookie: (key:String, value:String)? {
        didSet{
            guard let cookie = injectCookie else {
                return
            }
            let cookieStr = String(format: "%@=%@", cookie.key , cookie.value)
            let jsStr = String(format: "document.cookie = '%@';", cookieStr)
            ///js方式
            let script = WKUserScript(source: jsStr, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            config.userContentController.addUserScript(script)
            ///PHP方式
            request?.setValue(cookieStr, forHTTPHeaderField: "Cookie")
        }
    }
    
    /// 设置导航栏标题
    @objc public var navTitle: String?
    
    @objc public var loadingProgressColor: String?{
        didSet{
            guard let color = loadingProgressColor else {
                return
            }
            loadingProgressView.tintColor = UIColor(color)
        }
    }
    
    /// 访问地址
    @objc public var urlString: String?
    /// 添加userAgent标记,会拼接;
    @objc public var customUserAgent: String?
    /// 自定义请求
    @objc public var request: URLRequest?
    /// 获取当前地址
    public var currentUrl: String?
    
    fileprivate var first = true
    // MARK: - 初始化
    public convenience init(urlString url: String) {
        self.init()
        urlString = url
    }
    
    public convenience init(urlString url: String, cookie: Dictionary<String, String>) {
        self.init()
        guard let urlReal = URL(string: url) else {
            return
        }
        urlString = url
        var req = URLRequest(url: urlReal)
        var cookieStr = ""
        if cookie.count > 0 {
            for (key,value) in cookie {
                cookieStr += String(format: "%@=%@;", key , value)
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

        hideDefaultBackBarButton()
        
        addLeftBarButton(backButton, closeButton)
        
        title = navTitle
        
        view.addSubview(reloadButton)
        view.addSubview(webView)
        view.addSubview(loadingProgressView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            loadingProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingProgressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadingProgressView.heightAnchor.constraint(equalToConstant: 4),
            loadingProgressView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
 
        webView.configuration.userContentController.add(WeakScriptMessageDelegate(delegate: self), name: "JumpViewController")
        
        loadRequest()

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
 
        if webView.canGoBack {
            closeButton.isHidden = false
        }
    }
    
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.isHidden = true
        loadingProgressView.isHidden = false
    }
    
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
 
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        }else{
             completionHandler(.useCredential, nil)
        }
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
    //            changeLoadingProgress(progress: Float(newValue))
    //        })
    //    }
    // 监听网络加载进度，加载过程中在navigationBar显示加载进度，加载完成显示网站标题
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let webView = object as? WKWebView, webView == webView && keyPath == "estimatedProgress" {
            
            guard let changes = change else { return }
            //  请注意这里读取options中数值的方法
            let newValue = changes[NSKeyValueChangeKey.newKey] as? Double ?? 0
            let oldValue = changes[NSKeyValueChangeKey.oldKey] as? Double ?? 0
            
            // 因为我们已经设置了进度条为0.1，所以只有在进度大于0.1后再进行变化
            if newValue > oldValue && newValue > 0.1 {
                loadingProgressView.setProgress(Float(newValue), animated: true)
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
        }else if let url = urlString, let realURL = URL(string: url) {
            webView.load(URLRequest(url: realURL))
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
    @objc open func closeVC() {
        if let viewControllers: [UIViewController] = navigationController?.viewControllers {
            guard viewControllers.count <= 1 else {
                navigationController?.popViewController(animated: true)
                return
            }
        }
        if let _ = presentingViewController{
            dismiss(animated: true, completion: nil)
        }
    }
    
    ///reload按钮点击
    @objc func reloadWebView(){
        loadingProgressView.progress = 0
        loadingProgressView.isHidden = false
        guard let url = currentUrl, let realURL = URL(string: url) else{
            return
        }
        webView.load(URLRequest(url: realURL))
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
        let modifiedSince = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: modifiedSince) {
            debugPrint("清理完成")
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}

// MARK: - WeakScriptMessageDelegate
class WeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    
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
