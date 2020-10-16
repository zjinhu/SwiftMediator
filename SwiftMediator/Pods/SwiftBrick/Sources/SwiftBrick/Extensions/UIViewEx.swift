//
//  UIViewEx.swift
//  ClassTable
//
//  Created by iOS on 2020/7/30.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

public extension UIView{
    
    /// 添加背景色,主要是渐变色背景
    /// - Parameters:
    ///   - colors: 背景色数组,一个的话仅仅是设置背景色,多个的话会设置渐变色
    ///   - size: 视图大小,默认self.bounds,snap的需要注意layoutifneed
    ///   - startPoint: 渐变色起点
    ///   - endPoint: 渐变色终点
    func setBackColor(_ colors: [UIColor],
                      size: CGSize? = nil,
                      startPoint: CGPoint = .init(x: 0, y: 0),
                      endPoint: CGPoint = .init(x: 0, y: 1)){

        guard colors.count >= 1 else {
            return
        }
        
        removeGradientLayer()
        
        if colors.count < 2 {
            backgroundColor = colors.first
        }else{
            
            let gradient: CAGradientLayer = colors.gradient { gradient in
                gradient.startPoint = startPoint
                gradient.endPoint = endPoint
                return gradient
            }
            
            gradient.drawsAsynchronously = true
            layer.insertSublayer(gradient, at: 0)
            if let s = size{
                gradient.frame = .init(x: 0, y: 0, width: s.width, height: s.height)
            }else{
              gradient.frame = self.bounds
            }
        }
    }
    
    /// 移除渐变色背景
    func removeGradientLayer() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}
