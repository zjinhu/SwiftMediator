//
//  SwiftMediator+URL.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  URL 路由跳转扩展 / URL Routing Extension
//  支持通过 URL scheme 进行页面跳转，区分 Push 和 Present
//  Supports page navigation via URL scheme, distinguishing between Push and Present

import Foundation

//MARK:--URL 路由跳转 / URL Routing--Swift
extension SwiftMediator {
    /// URL 路由跳转，自动区分 Push、Present、全屏模态 / URL routing with automatic Push/Present/fullScreen detection
    /// - Parameter urlString: URL 字符串，格式: scheme://push/moduleName/vcName?queryParams
    ///   - scheme://push/... 表示 Push 跳转 / scheme://push/... for push navigation
    ///   - scheme://fullScreen/... 表示全屏模态 / scheme://fullScreen/... for fullscreen modal
    ///   - 其他 host 表示普通模态 / Other hosts for default modal
    /// - 注意: URL 中的字符串不能包含特殊字符，需进行 URL 编码 / String encoded into URL must not contain special characters, URL encoding required
    /// - 注意: 不支持 URL 中包含 url 和 query 的 queryParams 参数 / Does not support queryParams with url and query in the URL
    public func openUrl(_ urlString: String?) {
        
        guard let str = urlString, let url = URL(string: str) else { return }
        let path = url.path as String
        let startIndex = path.index(path.startIndex, offsetBy: 1)
        let pathArray = path.suffix(from: startIndex).components(separatedBy: "/")
        guard pathArray.count == 2 , let first = pathArray.first , let last = pathArray.last else { return }
        
        switch url.host {
        case "push":
            push(last, moduleName: first, paramsDic: url.parameters)
        case "fullScreen":
            present(last, moduleName: first, paramsDic: url.parameters)
        default:
            if #available(iOS 13.0, *) {
                present(last, moduleName: first, paramsDic: url.parameters, modelStyle: .automatic)
            } else {
                present(last, moduleName: first, paramsDic: url.parameters)
            }
        }
    }
}

/// URL 扩展 / URL Extension
/// 提供从 URL 中提取查询参数的能力 / Provides ability to extract query parameters from URL
public extension URL {
    
    /// 获取 URL 中的查询参数 / Get query parameters from URL
    var parameters: [String: Any]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: Any]()) { (result, item) in
            result[item.name] = item.value
        }
    }

}

//MARK:--URL 编解码 / URL Encoding and Decoding--Swift
public extension String {
    /// 将原始字符串编码为有效的 URL 字符串 / Encode original string into a valid URL string
    /// - Returns: 编码后的字符串 / Encoded string
    func urlEncoded() -> String {
        self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
    }
    
    /// 将编码后的 URL 字符串还原为原始字符串 / Decode encoded URL string back to original string
    /// - Returns: 解码后的字符串 / Decoded string
    func urlDecoded() -> String {
        self.removingPercentEncoding ?? ""
    }
}
