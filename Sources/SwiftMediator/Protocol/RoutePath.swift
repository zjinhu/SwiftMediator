//
//  RouterPath.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/29.
//

import UIKit

public class RoutePath: NSObject {

    var path: String
    var routerClass: AnyClass
    
    ///Register the route
    /// - Parameters:
    ///- path: The registration path
    ///- routerClass: The class that needs to be evoked
    public init(path: String, routerClass: AnyClass) {
        self.path = path
        self.routerClass = routerClass
    }
}
