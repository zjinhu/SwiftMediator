//
//  UIColorEx.swift
//  SwiftBrick
//
//  Created by iOS on 25/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import Foundation
public extension UIColor {
    
    ///根据RGB生成颜色
    convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    ///根据16进制生成颜色
    convenience init(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    ///根据16进制字符串生成颜色.支持 0x 或 # 开头字符串
    convenience init(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }
        
        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        
        guard let hexValue = Int(string, radix: 16) else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    ///简化RGB颜色写法
    class func RGBA(_ r : UInt, g : UInt, b : UInt, a : CGFloat) -> UIColor {
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
        return UIColor.init(red: red, green: green, blue: blue)
    }
    
    ///最小饱和度值
    func color(minSaturation: CGFloat) -> UIColor {
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
    
    static let baseLine = UIColor.init(hex: 0xe3e3e3)
    
    static let textTitleColor = L.color("textTitleColor")
    static let textSecColor = L.color("textSecColor")
    static let textDesColor = L.color("textDesColor")
    static let textLinkColor = L.color("textLinkColor")

}

public extension Array where Element : UIColor {
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

