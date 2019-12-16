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
    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    convenience init?(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    convenience init?(hexString: String, transparency: CGFloat = 1) {
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
        
        guard let hexValue = Int(string, radix: 16) else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    //简化RGB颜色写法
    class func RGBA(_ r : UInt, g : UInt, b : UInt, a : CGFloat) -> UIColor {
        let redFloat = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        return UIColor(red: redFloat, green: green, blue: blue, alpha: a)
    }
    //随机色
    
    static var random: UIColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return UIColor.init(red: red, green: green, blue: blue)!
    }
    
    
    struct FlatUI {

        public static let turquoise             = UIColor.init(hex: 0x1abc9c)!

        /// SwifterSwift: hex #16A085
        public static let greenSea              = UIColor.init(hex: 0x16a085)!

        /// SwifterSwift: hex #2ECC71
        public static let emerald               = UIColor.init(hex: 0x2ecc71)!

        /// SwifterSwift: hex #27AE60
        public static let nephritis             = UIColor.init(hex: 0x27ae60)!

        /// SwifterSwift: hex #3498DB
        public static let peterRiver            = UIColor.init(hex: 0x3498db)!

    }
}
