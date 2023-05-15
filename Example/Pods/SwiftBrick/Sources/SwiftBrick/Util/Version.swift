//
//  Version.swift
//  SwiftBrick
//
//  Created by iOS on 2021/3/25.
//  Copyright © 2021 狄烨 . All rights reserved.
//

import Foundation

// MARK: ===================================工具类:iOS系统版本号对比=========================================
public struct Version {
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    /// 默认初始化,当前系统的iOS版本号
    public init() {
        major = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
        minor = ProcessInfo.processInfo.operatingSystemVersion.minorVersion
        patch = ProcessInfo.processInfo.operatingSystemVersion.patchVersion
    }
    
    /// 使用自定义的版本号初始化
    /// - Parameters:
    ///   - major: 版本号
    ///   - minor: 版本号
    ///   - patch: 版本号
    public init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

extension Version: Comparable {
    
    fileprivate static func compare<T: Comparable>(lhs: T, rhs: T) -> ComparisonResult {
        if lhs < rhs {
            return .orderedAscending
        } else if lhs > rhs {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
    
    /// 系统版本号比对
    /// - Parameters:
    ///   - lhs: 左
    ///   - rhs: 右
    /// - Returns: true/false
    public static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
    
    /// 系统版本号比对
    /// - Parameters:
    ///   - lhs: 左
    ///   - rhs: 右
    /// - Returns: true/false
    public static func < (lhs: Version, rhs: Version) -> Bool {
        let majorComparison = Version.compare(lhs: lhs.major, rhs: rhs.major)
        if majorComparison != .orderedSame {
            return majorComparison == .orderedAscending
        }

        let minorComparison = Version.compare(lhs: lhs.minor, rhs: rhs.minor)
        if minorComparison != .orderedSame {
            return minorComparison == .orderedAscending
        }

        let patchComparison = Version.compare(lhs: lhs.patch, rhs: rhs.patch)
        if patchComparison != .orderedSame {
            return patchComparison == .orderedAscending
        }

        return false
    }
}
