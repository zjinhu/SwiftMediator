//
//  ColorEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public extension Color {
 
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: r, green: g, blue: b, opacity: a)
            return
        }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(red: r, green: g, blue: b, opacity: a)
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

@available(iOS 13.0, *)
public extension Color {
    static func dynamic(light: String, dark: String) -> Color {
        let l = UIColor(light)
        let d = UIColor(dark)
        return UIColor.dynamicColor(light: l, dark: d).toColor()
    }
    
    @available(iOS 14.0, *)
    static func dynamic(light: Color, dark: Color) -> Color {
        let l = UIColor(light)
        let d = UIColor(dark)
        return UIColor.dynamicColor(light: l, dark: d).toColor()
    }
    
    @available(iOS 14.0, *)
    func toUIColor() -> UIColor {
        return UIColor(self)
    }
}

@available(iOS 13.0, *)
public extension UIColor {
    func toColor() -> Color {
        return Color(self)
    }
}

@available(iOS 14.0, *)
public extension Color {

    static let defaultBackground = Color(light: .white, dark: .black)

    init(light: Color, dark: Color) {
        self.init(UIColor.dynamicColor(light: light.toUIColor(), dark: dark.toUIColor()))
    }
}

@available(iOS 13.0, *)
extension Color {
    public static var almostClear: Color {
        Color.black.opacity(0.0001)
    }
}

@available(iOS 13.0, *)
struct DetectThemeChange: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        
        if(colorScheme == .dark){
            content.colorInvert()
        }else{
            content
        }
    }
}

@available(iOS 13.0, *)
public extension View {
    func invertOnDarkTheme() -> some View {
        modifier(DetectThemeChange())
    }
}
