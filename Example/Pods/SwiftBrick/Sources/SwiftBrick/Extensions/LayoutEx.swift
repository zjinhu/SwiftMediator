//
//  LayoutEx.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2022/6/13.
//  Copyright © 2022 狄烨 . All rights reserved.
//

import UIKit
///方便自适应布局进行等比例宽高 等同于 FitWidth FitHight
public extension CGFloat {
    /// 比例缩放 width
    ///
    /// - Parameter size: origin width
    /// - Returns: 比例缩放后的 width 没有除以2.0
    func scaleWidth() -> CGFloat {
        return SwiftBrick.Define.screenWidth / 375 * self
    }
    /// 比例缩放 height
    ///
    /// - Parameter size: origin height
    /// - Returns: 比例缩放后的 height 没有除以2.0
    func scaleHeight() -> CGFloat {
        return SwiftBrick.Define.screenHeight / 667 * self
    }
}
///方便自适应布局进行等比例宽高 等同于 FitWidth FitHight
public extension Int {
    /// 比例缩放 width
    ///
    /// - Parameter size: origin width
    /// - Returns: 比例缩放后的 width 没有除以2.0
    func scaleWidth() -> CGFloat {
        return SwiftBrick.Define.screenWidth / 375 * CGFloat(self)
    }
    /// 比例缩放 height
    ///
    /// - Parameter size: origin height
    /// - Returns: 比例缩放后的 height 没有除以2.0
    func scaleHeight() -> CGFloat {
        return SwiftBrick.Define.screenHeight / 667 * CGFloat(self)
    }
}
