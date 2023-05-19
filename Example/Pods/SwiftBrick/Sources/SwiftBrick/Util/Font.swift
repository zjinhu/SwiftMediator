//
//  Font.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//
import UIKit
import Foundation
extension SwiftBrick{
    public struct Font {
        // MARK:- 字体
        ///根据屏幕自适应字体参数 16*FontFit
        public static let fontFit = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375
        
        /// 系统默认字体
        public static func systemFont(_ size: CGFloat) -> UIFont {
            return .systemFont(ofSize: size)
        }
        /// 系统默认字体
        public static func systemFontBold(_ size: CGFloat) -> UIFont {
            return .boldSystemFont(ofSize: size)
        }
        /// 系统默认字体
        public static func systemFont(_ size: CGFloat, weight: UIFont.Weight) -> UIFont {
            return .systemFont(ofSize: size, weight: weight)
        }
        
        public enum Weight {
            case ultralight
            case thin
            case light
            case regular
            case medium
            case semibold
            case bold
            case heavy
        }
        /// pingfang-sc 字体
        public static func font(_ size: CGFloat) -> UIFont {
            return fontWeight(size, weight: .regular)
        }
        /// pingfang-sc 字体
        public static func fontMedium(_ size: CGFloat) -> UIFont {
            return fontWeight(size, weight: .medium)
        }
        /// pingfang-sc 字体
        public static func fontBold(_ size: CGFloat) -> UIFont {
            return fontWeight(size, weight: .semibold)
        }
        /// pingfang-sc 字体
        public static func fontWeight(_ size: CGFloat, weight: Weight) -> UIFont {
            var name = ""
            switch weight {
            case .ultralight:
                name = "PingFangSC-Ultralight"
            case .thin:
                name = "PingFangSC-Thin"
            case .light:
                name = "PingFangSC-Light"
            case .regular:
                name = "PingFangSC-Regular"
            case .medium:
                name = "PingFangSC-Medium"
            case .semibold:
                name = "PingFangSC-Semibold"
            case .bold:
                name = "PingFangSC-Bold"
            case .heavy:
                name = "PingFangSC-Heavy"
            }
            return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
    }
}
