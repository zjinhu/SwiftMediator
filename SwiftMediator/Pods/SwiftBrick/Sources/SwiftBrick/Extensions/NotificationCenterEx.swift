//
//  NotificationCenterEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/20.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
public extension NotificationCenter {
    func add(name: String,
             obj: Any? = nil,
             queue: OperationQueue? = .main,
             block: @escaping (_ notification: Notification) -> Void) {
        
        var handler: NSObjectProtocol!
        handler = addObserver(forName: NSNotification.Name(rawValue: name), object: obj, queue: queue) { [unowned self] in
            self.removeObserver(handler!)
            block($0)
        }
    }
}
