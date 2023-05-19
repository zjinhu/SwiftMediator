//
//  UILineView.swift
//  SwiftBrick
//
//  Created by iOS on 2020/9/2.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================工厂类:虚线 实线=========================================
public class UILineView: UIView {
    ///线宽度
    public var lineWidth: CGFloat = SwiftBrick.Define.lineHeight{
        didSet{
            setNeedsDisplay()
        }
    }
    ///线颜色
    public var lineColor: UIColor = .baseLine{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var paddingLeft: CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var paddingRight: CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var paddingTop: CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var paddingBottom: CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    // 横线 竖线
    public var isHorizontal: Bool = true{
        didSet{
            setNeedsDisplay()
        }
    }
    
    // 是否虚线
    public var isDash: Bool = false{
        didSet{
            setNeedsDisplay()
        }
    }
    
    ///虚线长
    public var dashPointWidth: CGFloat = 3.0{
        didSet{
            setNeedsDisplay()
        }
    }
    ///虚线间距
    public var dashPointSpace: CGFloat = 1.0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        // 获取上下文对象
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        var bx: CGFloat = 0, by: CGFloat = 0, ex: CGFloat = 0, ey: CGFloat = 0;
        if isHorizontal {
            bx = paddingLeft
            by = CGFloat(Int(rect.size.height)/2)
            ex = rect.size.width - paddingRight
            ey = by
        } else {
            bx = CGFloat(Int(rect.size.width)/2)
            by = paddingTop
            ex = bx
            ey = rect.size.height - paddingBottom
        }
        // 画中间虚线
        let path    = CGMutablePath()
        let begin   = CGPoint(x: bx, y: by),
            end     = CGPoint(x: ex, y: ey)
        path.move(to: begin)
        path.addLine(to: end)
        // 2、 添加路径到图形上下文
        context.addPath(path)
        // 3、 设置状态
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        if isDash {
            context.setLineDash(phase: 0, lengths: [dashPointWidth, dashPointSpace])
        }
        // 4、 绘制图像到指定图形上下文
        context.drawPath(using: .fillStroke)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    /// 快速画线
    /// - Parameters:
    ///   - horizontal: bool 横线 竖线
    ///   - width: 线宽
    ///   - color: 颜色
    ///   - dash: 是否虚线
    ///   - dashWidth: 虚线长
    ///   - dashSpace: 虚线间隔
    public convenience init(horizontal: Bool = true,
                            width: CGFloat = SwiftBrick.Define.lineHeight,
                            color: UIColor = .baseLine,
                            dash: Bool = false,
                            dashWidth: CGFloat = 1,
                            dashSpace: CGFloat = 1){
        self.init()
        isHorizontal = horizontal
        isDash = dash
        lineWidth = width
        lineColor = color
        if dash {
            dashPointWidth = dashWidth
            dashPointSpace = dashSpace
        }
    }
}
