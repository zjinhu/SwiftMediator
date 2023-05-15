//
//  AppState.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/18.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
// MARK: ===================================工具类:APP当前状态=========================================
public enum AppStateMode {
    case Debug
    case TestFlight
    case AppStore
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
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}
