//
//  Device.swift
//  SwiftBrick
//
//  Created by iOS on 2021/11/4.
//  Copyright © 2021 狄烨 . All rights reserved.
//

import Foundation
import UIKit
/// 判断是否iphoneX 带刘海
public func IsBangs_iPhone() -> Bool {
    return BottomHomeHeight > 0
}

public var isX: Bool {
    return BottomHomeHeight > 0
}

///判断是否iPad
public let IsIPAD: Bool = (UIDevice.current.userInterfaceIdiom == .pad) ? true: false


// MARK:- 系统版本
public let SystemVersion: String = UIDevice.current.systemVersion

public func Later_iOS11() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    return true
}

public func Later_iOS12() -> Bool {
    guard #available(iOS 12.0, *) else {
        return false
    }
    return true
}

public func Later_iOS13() -> Bool {
    guard #available(iOS 13.0, *) else {
        return false
    }
    return true
}

public func Later_iOS14() -> Bool {
    guard #available(iOS 14.0, *) else {
        return false
    }
    return true
}

public func Later_iOS15() -> Bool {
    guard #available(iOS 15.0, *) else {
        return false
    }
    return true
}

public func Later_iOS16() -> Bool {
    guard #available(iOS 16.0, *) else {
        return false
    }
    return true
}


public enum Device {
    /// iPhone 5, 5s, 5c, SE, iPod Touch 5-6th.
    case screen4Inch
    /// iPhone 6, 6s, 7, 8, SE2
    case screen4_7Inch
    /// iPhone 12,13Mini
    case screen5_4Inch
    /// iPhone 6+, 6s+, 7+, 8+
    case screen5_5Inch
    /// iPhone X, Xs, 11Pro
    case screen5_8Inch
    /// iPhone XR, 11 , 12,13 , 12,13Pro
    case screen6_1Inch
    /// iPhone Xs Max, 11 Pro Max
    case screen6_5Inch
    /// iPhone 12,13 Pro MAX
    case screen6_7Inch
    case unknown
    
    public static var current: Device {
       return Device.size()
    }
    
    static public func size() -> Device {
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
        if Device.size() == .screen4Inch {
            return true
        }
        return false
    }
    public static var isDevice4_7: Bool {
        if Device.size() == .screen4_7Inch {
            return true
        }
        return false
    }
    public static var isDevice5_5: Bool {
        if Device.size() == .screen5_5Inch {
            return true
        }
        return false
    }
    public static var isDevice5_4: Bool {
        if Device.size() == .screen5_4Inch {
            return true
        }
        return false
    }
    public static var isDevice5_8: Bool {
        if Device.size() == .screen5_8Inch {
            return true
        }
        return false
    }
    public static var isDevice6_1: Bool {
        if Device.size() == .screen6_1Inch {
            return true
        }
        return false
    }
    public static var isDevice6_5: Bool {
        if Device.size() == .screen6_5Inch {
            return true
        }
        return false
    }
    public static var isDevice6_7: Bool {
        if Device.size() == .screen6_7Inch {
            return true
        }
        return false
    }
}
