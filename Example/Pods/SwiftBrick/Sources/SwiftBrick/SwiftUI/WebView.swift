//
//  WebView.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI

public struct WebView: UIViewControllerRepresentable {
    public let urlString: String
    
    public init(urlString: String) {
        self.urlString = urlString
    }
    
    public func makeUIViewController(context: Context) -> WebViewController {
        let webviewController = WebViewController()
        return webviewController
    }

    public func updateUIViewController(_ webviewController: WebViewController, context: Context){
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        DispatchQueue.main.async {
            webviewController.webView.load(request)
        }
    }
}
