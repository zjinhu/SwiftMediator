//
//  UITableViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 22/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SnapKit
public extension UITableView {
    
    /// 快速初始化UITableView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - style: 列表样式 有默认参数
    ///   - delegate: delegate 
    ///   - dataSource: dataSource
    ///   - backColor: 背景色
    @discardableResult
    class func snpTableView(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            style: UITableView.Style = .plain,
                            delegate: UITableViewDelegate? = nil,
                            dataSource: UITableViewDataSource? = nil,
                            snapKitMaker : ((_ make: ConstraintMaker) -> Void)? = nil) -> UITableView {
        
        let tableView = UITableView.init(frame: .zero, style: style)
        if delegate != nil {
          tableView.delegate = delegate
        }
        if dataSource != nil {
          tableView.dataSource = dataSource
        }

        tableView.backgroundColor = backColor
        
        tableView.separatorStyle = .none
        //        self.tableView?.separatorColor = .lightGray
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.delaysContentTouches = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        guard let sv = supView, let maker = snapKitMaker else {
            return tableView
        }
        
        sv.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return tableView
    }
    
}
