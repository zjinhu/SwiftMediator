//
//  UIColorEx.swift
//  SwiftBrick
//
//  Created by iOS on 25/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import Foundation
// MARK: ===================================扩展: 颜色=========================================

public extension UIColor {
    /// 支持暗黑模式的颜色
    static let baseBlue = L.color("baseBlue")
    static let baseGray = L.color("baseGray")
    static let baseGreen = L.color("baseGreen")
    static let baseIndigo = L.color("baseIndigo")
    static let baseOrange = L.color("baseOrange")
    static let basePink = L.color("basePink")
    static let basePurple = L.color("basePurple")
    static let baseRed = L.color("baseRed")
    static let baseTeal = L.color("baseTeal")
    static let baseYellow = L.color("baseYellow")
    static let baseBackground = L.color("bgColor")
    static let baseBGColor = L.color("backColor")
    
    static let baseLine = L.color("baseLine")
    
    static let textTitleColor = L.color("textTitleColor")
    static let textSecColor = L.color("textSecColor")
    static let textDesColor = L.color("textDesColor")
    static let textLinkColor = L.color("textLinkColor")
    
}

public extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light } 
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }

}
 
public extension UIColor {
    
    ///根据RGB生成颜色
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        var trans = a
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: trans)
    }
    
    ///根据16进制生成颜色
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(r: red, g: green, b: blue, a: alpha)
    }
    
    ///根据16进制字符串生成颜色.支持 0x 或 # 开头字符串
    convenience init(_ hex: String) {
        var string = ""
        if hex.lowercased().hasPrefix("0x") {
            string =  hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.hasPrefix("#") {
            string = hex.replacingOccurrences(of: "#", with: "")
        } else {
            string = hex
        }
        var int: UInt64 = 0
        
        Scanner(string: string).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch string.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(r: Int(r), g: Int(g), b: Int(b), a: CGFloat(a))
    }
    
    ///简化RGB颜色写法
    class func RGBA(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
        let redFloat = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        return UIColor(red: redFloat, green: green, blue: blue, alpha: a)
    }
    
    ///随机色
    static var random: UIColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return UIColor(r: red, g: green, b: blue)
    }
    
    ///最小饱和度值
    func color(_ minSaturation: CGFloat) -> UIColor {
      var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
      getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      
      return saturation < minSaturation
        ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
       : self
    }
    
    ///调整alpha
    func alpha(_ value: CGFloat) -> UIColor {
      return withAlphaComponent(value)
    }

}

public extension Array where Element: UIColor {
  ///通过颜色数组生成渐变色
  func gradient(_ transform: ((_ gradient: inout CAGradientLayer) -> CAGradientLayer)? = nil) -> CAGradientLayer {
    var gradient = CAGradientLayer()
    gradient.colors = self.map { $0.cgColor }
    
    if let transform = transform {
      gradient = transform(&gradient)
    }
    
    return gradient
  }
}

public extension UIColor {

  internal func rgbComponents() -> [CGFloat] {
    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return [r, g, b]
  }
  
  var isDark: Bool {
    let RGB = rgbComponents()
    return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
  }
  
  var isBlackOrWhite: Bool {
    let RGB = rgbComponents()
    return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
  }
  
  var isBlack: Bool {
    let RGB = rgbComponents()
    return (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
  }
  
  var isWhite: Bool {
    let RGB = rgbComponents()
    return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91)
  }
  
  func isDistinct(from color: UIColor) -> Bool {
    let bg = rgbComponents()
    let fg = color.rgbComponents()
    let threshold: CGFloat = 0.25
    var result = false
    
    if abs(bg[0] - fg[0]) > threshold || abs(bg[1] - fg[1]) > threshold || abs(bg[2] - fg[2]) > threshold {
        if abs(bg[0] - bg[1]) < 0.03 && abs(bg[0] - bg[2]) < 0.03 {
            if abs(fg[0] - fg[1]) < 0.03 && abs(fg[0] - fg[2]) < 0.03 {
          result = false
        }
      }
      result = true
    }
    
    return result
  }
  
  func isContrasting(with color: UIColor) -> Bool {
    let bg = rgbComponents()
    let fg = color.rgbComponents()
    
    let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
    let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
    let contrast = bgLum > fgLum
      ? (bgLum + 0.05) / (fgLum + 0.05)
     : (fgLum + 0.05) / (bgLum + 0.05)
    
    return 1.6 < contrast
  }
  
}
