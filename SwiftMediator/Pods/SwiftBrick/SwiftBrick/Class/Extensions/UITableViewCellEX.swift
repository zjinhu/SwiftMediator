//
//  UITableViewCellEX.swift
//  SwiftBrick
//
//  Created by iOS on 2020/5/20.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import UIKit
import SnapKit
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
    func addAllLine(tableView : UITableView,
                     indexPath : IndexPath,
                     leftMarign : CGFloat = 0,
                     rightMarign : CGFloat = 0,
                     isHeadFootMarign : Bool = false,
                     lineColor : UIColor = .clear){
        var headFootLeftMarign : CGFloat = 0
        var headFootRightMarign : CGFloat = 0
        
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
            topLineView = UIView.init()
            topLineView?.backgroundColor = color
            topLineView?.tag = TopLineTag
            addSubview(topLineView!)
            bringSubviewToFront(topLineView!)
            topLineView?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(headFootLeftMarign)
                make.right.equalToSuperview().offset(-headFootRightMarign)
                make.height.equalTo(LineHeight)
            })
        }
        
        if indexPath.row == 0 {
            topLineView?.isHidden = false
        }else{
            topLineView?.isHidden = true
        }
        
        var bottomLineView  = viewWithTag(BottomLineTag)
        
        if bottomLineView == nil {
            bottomLineView = UIView.init()
            bottomLineView?.backgroundColor = color
            bottomLineView?.tag = BottomLineTag
            addSubview(bottomLineView!)
            bringSubviewToFront(bottomLineView!)
            bottomLineView?.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(leftMarign)
                make.right.equalToSuperview().offset(-rightMarign)
                make.height.equalTo(LineHeight)
            })
        }

        if indexPath.row == count - 1{
            bottomLineView?.snp.remakeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(headFootLeftMarign)
                make.right.equalToSuperview().offset(-headFootRightMarign)
                make.height.equalTo(LineHeight)
            })
        }else{
            bottomLineView?.snp.remakeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(leftMarign)
                make.right.equalToSuperview().offset(-rightMarign)
                make.height.equalTo(LineHeight)
            })
        }
    }

    /// 添加中间分割线，首位没有线
    /// - Parameters:
    ///   - indexPath: indexPath
    ///   - leftMarign: 左间距
    ///   - rightMarign: 右间距
    func addMiddleLine(indexPath : IndexPath,
                     leftMarign : CGFloat = 0,
                     rightMarign : CGFloat = 0,
                     lineColor : UIColor = .clear){
        
        var color: UIColor = .baseLine
        if lineColor != .clear{
            color = lineColor
        }
        
        var lineView  = viewWithTag(TopLineTag)
        
        if lineView == nil {
            lineView = UIView.init()
            lineView?.backgroundColor = color
            lineView?.tag = TopLineTag
            addSubview(lineView!)
            bringSubviewToFront(lineView!)
            lineView?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(leftMarign)
                make.right.equalToSuperview().offset(-rightMarign)
                make.height.equalTo(LineHeight)
            })
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
    func addDownLine(leftMarign : CGFloat = 0,
                     rightMarign : CGFloat = 0,
                     lineColor : UIColor = .clear){
        
        var color: UIColor = .baseLine
        if lineColor != .clear{
            color = lineColor
        }
        
        var lineView  = viewWithTag(BottomLineTag)
        
        if lineView == nil {
            lineView = UIView.init()
            lineView?.backgroundColor = color
            lineView?.tag = BottomLineTag
            addSubview(lineView!)
            bringSubviewToFront(lineView!)
            lineView?.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.right.equalToSuperview().offset(-rightMarign)
                make.left.equalToSuperview().offset(leftMarign)
                make.height.equalTo(LineHeight)
            })
        }

    }

}
