//
//  Application.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import Foundation
// MARK:- App信息
extension SwiftBrick{
    public struct Application {
        
        public static var appDisplayName: String {
            return Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
        }
        
        public static var appName: String {
            return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as! String
        }
        
        public static var appBundleID: String {
            return Bundle.main.bundleIdentifier!
        }
        
        public static var version: String {
            return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        }
        
        public static var build: String {
            return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        }
        
        public static var completeAppVersion: String {
            return "\(Application.version) (\(Application.build))"
        }
    }
}
