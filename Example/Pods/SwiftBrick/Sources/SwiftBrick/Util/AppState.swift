//
//  AppState.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/18.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
// MARK: ===================================工具类:APP当前状态=========================================
extension SwiftBrick{
    public enum AppStateMode {
        case debug
        case testFlight
        case appStore
    }
    
    public struct AppState {
        
        fileprivate static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        
        public static var isDebug: Bool {
#if DEBUG
            return true
#else
            return false
#endif
        }
        
        public static var state: AppStateMode {
            if isDebug {
                return .debug
            } else if isTestFlight {
                return .testFlight
            } else {
                return .appStore
            }
        }
    }
}
