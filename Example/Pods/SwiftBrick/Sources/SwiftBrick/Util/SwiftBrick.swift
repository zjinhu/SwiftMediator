//
//  SwiftBrick.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/30.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import UIKit
// MARK: ===================================VC基类:协议=========================================
public struct SwiftBrick{
    ///如果使用导航栏的功能可以全局设置下
    ///统一设置返回按钮图片(默认)
    public static var navBarNorBackImage: UIImage?
    ///统一设置返回按钮图片(按下)
    public static var navBarHigBackImage: UIImage?
    ///导航栏左按钮修正距离,默认按钮距离边缘为20:左移为-,右移为+
    public static var navBarLeftFixSpace: CGFloat = 0
    ///导航栏右按钮修正距离,默认按钮距离边缘为20:左移为+,右移为-
    public static var navBarRightFixSpace: CGFloat = 0

}
