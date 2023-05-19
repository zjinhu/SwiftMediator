//
//  Device.swift
//  SwiftBrick
//
//  Created by iOS on 2021/11/4.
//  Copyright © 2021 狄烨 . All rights reserved.
//

import Foundation
import UIKit
extension SwiftBrick{
    public struct Device {
        /// 判断是否iphoneX 带刘海
        public static var isiPhoneX: Bool {
            return Define.bottomHomeHeight > 0
        }
        
        ///判断是否iPad
        public static let isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad) ? true: false
        
        
        // MARK:- 系统版本
        public static let systemVersion: String = UIDevice.current.systemVersion
        
        public static func later_iOS13() -> Bool {
            guard #available(iOS 13.0, *) else {
                return false
            }
            return true
        }
        
        public static func later_iOS14() -> Bool {
            guard #available(iOS 14.0, *) else {
                return false
            }
            return true
        }
        
        public static func later_iOS15() -> Bool {
            guard #available(iOS 15.0, *) else {
                return false
            }
            return true
        }
        
        public static func later_iOS16() -> Bool {
            guard #available(iOS 16.0, *) else {
                return false
            }
            return true
        }
        
    }
    
    public enum DeviceKit {
        /// iPhone 5, 5s, 5c, SE, iPod Touch 5-6th.
        case screen4Inch
        /// iPhone 6, 6s, 7, 8, SE2,3
        case screen4_7Inch
        /// iPhone 12,13Mini
        case screen5_4Inch
        /// iPhone 6+, 6s+, 7+, 8+
        case screen5_5Inch
        /// iPhone X, Xs, 11Pro
        case screen5_8Inch
        /// iPhone XR, 11 , 12,13,14 , 12,13,14Pro
        case screen6_1Inch
        /// iPhone Xs Max, 11 Pro Max
        case screen6_5Inch
        /// iPhone 12,13,14 Pro MAX plus
        case screen6_7Inch
        case unknown
        
        public static var current: DeviceKit {
            return DeviceKit.size()
        }
        
        static public func size() -> DeviceKit {
            let w: Double = Double(UIScreen.main.bounds.width)
            let h: Double = Double(UIScreen.main.bounds.height)
            let screenHeight: Double = max(w, h)
            
            switch screenHeight {
                
            case 568:
                return .screen4Inch
            case 667:
                return UIScreen.main.scale == 3.0 ? .screen5_5Inch : .screen4_7Inch
            case 736:
                return .screen5_5Inch
            case 780:
                return .screen5_4Inch
            case 812:
                if #available(iOS 11.0, *) {
                    return UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.minY != 44 ?  .screen5_4Inch : .screen5_8Inch
                } else {
                    return .screen5_8Inch
                }
            case 844 :
                return .screen6_1Inch
            case 896:
                return  UIScreen.main.scale == 3.0 ? .screen6_5Inch : .screen6_1Inch
            case 926:
                return .screen6_7Inch
            default:
                return .unknown
            }
        }
        
        public static var isDevice4: Bool {
            if DeviceKit.size() == .screen4Inch {
                return true
            }
            return false
        }
        public static var isDevice4_7: Bool {
            if DeviceKit.size() == .screen4_7Inch {
                return true
            }
            return false
        }
        public static var isDevice5_5: Bool {
            if DeviceKit.size() == .screen5_5Inch {
                return true
            }
            return false
        }
        public static var isDevice5_4: Bool {
            if DeviceKit.size() == .screen5_4Inch {
                return true
            }
            return false
        }
        public static var isDevice5_8: Bool {
            if DeviceKit.size() == .screen5_8Inch {
                return true
            }
            return false
        }
        public static var isDevice6_1: Bool {
            if DeviceKit.size() == .screen6_1Inch {
                return true
            }
            return false
        }
        public static var isDevice6_5: Bool {
            if DeviceKit.size() == .screen6_5Inch {
                return true
            }
            return false
        }
        public static var isDevice6_7: Bool {
            if DeviceKit.size() == .screen6_7Inch {
                return true
            }
            return false
        }
        
        public static var identifier: String = {
           var systemInfo = utsname()
           uname(&systemInfo)
           let mirror = Mirror(reflecting: systemInfo.machine)

           let identifier = mirror.children.reduce("") { identifier, element in
             guard let value = element.value as? Int8, value != 0 else { return identifier }
             return identifier + String(UnicodeScalar(UInt8(value)))
           }
           return identifier
         }()

    }
}
