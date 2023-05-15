//
//  CALayerExtension.swift
//  SwiftBrick
//
//  Created by iOS on 22/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================扩展: 阴影 边框 圆角=========================================
public extension CALayer {
    
    /// 设置阴影--sketch效果
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - alpha: 透明度
    ///   - x: 以view的center算
    ///   - y: 以view的center算
    ///   - blur: 半径,多大阴影需要多大半径,必须比view的半径大
    ///   - spread: 模糊范围
    func sketchShadow(color: UIColor? = .black,
                       alpha: CGFloat = 0.5,
                       x: CGFloat = 0,
                       y: CGFloat = 0,
                       blur: CGFloat = 0,
                       spread: CGFloat = 0) {
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur * 0.5
        shadowColor = color?.cgColor
        shadowOpacity = Float(alpha)
        
        let rect = bounds.insetBy(dx: -spread, dy: -spread)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        shadowPath = path.cgPath
    }
    
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - x: shadowOffset
    ///   - y: shadowOffset
    ///   - alpha: shadowOpacity
    ///   - radius: shadowRadius
    func setShadow(color: UIColor? = .black,
                   x: CGFloat = 0,
                   y: CGFloat = 0,
                   alpha: Float = 0.5,
                   radius: CGFloat = 0) {
        //设置阴影颜色
        shadowColor = color?.cgColor
        //设置透明度
        shadowOpacity = alpha
        //设置阴影半径
        shadowRadius = radius
        //设置阴影偏移量
        shadowOffset = CGSize(width: x, height: y)
    }
    
    /// 设置边框 或 圆角
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - width: borderWidth
    ///   - corner: cornerRadius
    func setBorder(color: UIColor? = .clear,
                   width: CGFloat = 0.5,
                   corner: CGFloat = 0){
        //设置视图边框宽度
        borderWidth = width
        //设置边框颜色
        borderColor = color?.cgColor
        //设置边框圆角
        cornerRadius = corner
    }

    /// 设置部分圆角 需要View设置clipsToBounds = true
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: CACornerMask集合 rightBottom:右下  rightTop:右上  leftBottom:左下  leftTop:左上  all:全部 bothTop:上边  bothBottom:下边  bothLeft:左边  bothRight:右边
    func setCorners(_ radius: CGFloat, corners: CACornerMask){
        cornerRadius = radius
        maskedCorners = corners
    }
}

public extension CACornerMask {

    static let leftTop = CACornerMask.layerMinXMinYCorner

    static let rightTop = CACornerMask.layerMaxXMinYCorner

    static let leftBottom = CACornerMask.layerMinXMaxYCorner

    static let rightBottom = CACornerMask.layerMaxXMaxYCorner
    
    static let all: CACornerMask = [.leftTop, .rightTop, .leftBottom, .rightBottom]
    
    static let bothTop: CACornerMask = [.leftTop, .rightTop]
    
    static let bothBottom: CACornerMask = [.leftBottom, .rightBottom]
    
    static let bothLeft: CACornerMask = [.leftTop, .leftBottom]
    
    static let bothRight: CACornerMask = [.rightTop, .rightBottom]
}

