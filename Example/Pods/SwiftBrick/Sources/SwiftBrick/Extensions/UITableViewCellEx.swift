//
//  UITableViewCellEX.swift
//  SwiftBrick
//
//  Created by iOS on 2020/5/20.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import UIKit
// MARK: ===================================扩展: UITableViewCell添加分割线=========================================
let TopLineTag         = 19003
let BottomLineTag      = 19004
///UITableView 自定义下划线
public extension UITableViewCell {
    
    /// 添加分割线，系统原生样式
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    ///   - leftMarign: 左间距
    ///   - rightMarign: 右间距
    ///   - isHeadFootMarign: 是否首尾分割线也需要间距
    ///   - lineColor: 选中颜色
    func addAllLine(tableView: UITableView,
                     indexPath: IndexPath,
                     leftMarign: CGFloat = 0,
                     rightMarign: CGFloat = 0,
                     isHeadFootMarign: Bool = false,
                     lineColor: UIColor = .clear){
        var headFootLeftMarign: CGFloat = 0
        var headFootRightMarign: CGFloat = 0
        
        if isHeadFootMarign {
            headFootLeftMarign = leftMarign
            headFootRightMarign = rightMarign
        }
        
        var color: UIColor = .baseLine
        if lineColor != .clear{
            color = lineColor
        }
        
        guard let count = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section), count > 0 else {
            return
        }
        
        var topLineView  = viewWithTag(TopLineTag)
        
        if topLineView == nil {
            topLineView = UIView()
            topLineView?.backgroundColor = color
            topLineView?.tag = TopLineTag
            topLineView?.translatesAutoresizingMaskIntoConstraints = false

            if let topLineView = topLineView{
                addSubview(topLineView)
                bringSubviewToFront(topLineView)
                let constraints = [
                    topLineView.topAnchor.constraint(equalTo: topAnchor),
                    topLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: headFootLeftMarign),
                    topLineView.heightAnchor.constraint(equalToConstant: SwiftBrick.Define.lineHeight),
                    topLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -headFootRightMarign)
                ]
                NSLayoutConstraint.activate(constraints)
            }
        }
        
        if indexPath.row == 0 {
            topLineView?.isHidden = false
        }else{
            topLineView?.isHidden = true
        }
        
        var bottomLineView  = viewWithTag(BottomLineTag)
 
        if bottomLineView == nil {
            bottomLineView = UIView()
            bottomLineView?.backgroundColor = color
            bottomLineView?.tag = BottomLineTag
            bottomLineView?.translatesAutoresizingMaskIntoConstraints = false

            if let bottomLineView = bottomLineView{
                addSubview(bottomLineView)
                bringSubviewToFront(bottomLineView)
 
                bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                bottomLineView.heightAnchor.constraint(equalToConstant: SwiftBrick.Define.lineHeight).isActive = true
                bottomLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMarign).isActive = true
                bottomLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -leftMarign).isActive = true
            }
        }

        if indexPath.row == count - 1{
            bottomLineView?.leftAnchor.constraint(equalTo: leftAnchor, constant: headFootLeftMarign).isActive = true
            bottomLineView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -headFootRightMarign).isActive = true
        }else{
            bottomLineView?.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMarign).isActive = true
            bottomLineView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -leftMarign).isActive = true
        }
    }

    /// 添加中间分割线，首位没有线
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - leftMarign: 左间距
    ///   - rightMarign: 右间距
    func addMiddleLine(indexPath: IndexPath,
                     leftMarign: CGFloat = 0,
                     rightMarign: CGFloat = 0,
                     lineColor: UIColor = .clear){
        
        var color: UIColor = .baseLine
        if lineColor != .clear{
            color = lineColor
        }
        
        var lineView  = viewWithTag(TopLineTag)
        
        if lineView == nil {
            lineView = UIView()
            lineView?.backgroundColor = color
            lineView?.tag = TopLineTag
            addSubview(lineView!)
            bringSubviewToFront(lineView!)
 
            if let lineView = lineView{
                addSubview(lineView)
                bringSubviewToFront(lineView)
                let constraints = [
                    lineView.topAnchor.constraint(equalTo: topAnchor),
                    lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMarign),
                    lineView.heightAnchor.constraint(equalToConstant: SwiftBrick.Define.lineHeight),
                    lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -rightMarign)
                ]
                NSLayoutConstraint.activate(constraints)
            }
        }
        
        if indexPath.row == 0 {
            lineView?.isHidden = true
        }else{
            lineView?.isHidden = false
        }
    }
    
    /// 添加底部分割线
    /// - Parameters:
    ///   - leftMarign: 左侧间距
    ///   - rightMarign: 右间距
    ///   - lineColor: 选中颜色，默认为灰色线
    func addDownLine(leftMarign: CGFloat = 0,
                     rightMarign: CGFloat = 0,
                     lineColor: UIColor = .clear){
        
        var color: UIColor = .baseLine
        if lineColor != .clear{
            color = lineColor
        }
        
        var lineView  = viewWithTag(BottomLineTag)
        
        if lineView == nil {
            lineView = UIView()
            lineView?.backgroundColor = color
            lineView?.tag = BottomLineTag
 
            if let lineView = lineView{
                addSubview(lineView)
                bringSubviewToFront(lineView)
                let constraints = [
                    lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMarign),
                    lineView.heightAnchor.constraint(equalToConstant: SwiftBrick.Define.lineHeight),
                    lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -rightMarign)
                ]
                NSLayoutConstraint.activate(constraints)
            }

        }

    }

}
