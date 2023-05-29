//
//  Routable.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/26.
//

import Foundation
import SafariServices
public protocol Routable{
    ///Initialize the current class
    static func initVC(params: [String: Any]) -> Routable
    ///Custom route handling
    func openRouter(path: String)
}
 
public extension Routable {
    ///This function can be implemented on its own
    func openRouter(path: String) {
 
        guard let url = URL(string: path) else { return }
 
        switch url.scheme {
        case "push":
            Router.shared.push(path, params: url.queryDictionary)
        case "present":
            if #available(iOS 13.0, *) {
                Router.shared.present(path, params: url.queryDictionary, modelStyle: .automatic)
            } else {
                Router.shared.present(path, params: url.queryDictionary, modelStyle: .fullScreen)
            }
        case "fullScreen":
            Router.shared.present(path, params: url.queryDictionary, modelStyle: .fullScreen)
        default:
            let safariController = SFSafariViewController(url: URL(string: path)!)
            UIViewController.currentViewController()?.present(safariController, animated: true, completion: nil)
        }
        
    }
}
