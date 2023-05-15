//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

open class BaseRowFormer<T: UITableViewCell>: RowFormer {
    ///cell不可点击是标题颜色
    public var titleDisabledColor: UIColor? = .lightGray
    ///cell标题颜色
    public var titleColor: UIColor?
    
    /// 获取form里的cell
    public var cell: T {
        return cellInstance as! T
    }
    
    public init() {
        super.init(withCellType: T.self)
    }
    
    /// 设置cell内视图
    /// - Parameter handler: 回调闭包
    /// - Returns: 返回former
    @discardableResult public final func cellSetup(_ handler: @escaping ((T) -> Void)) -> Self {
        cellSetup = { handler(($0 as! T)) }
        return self
    }
    
    /// cell更新
    /// - Parameter update: 回调闭包
    /// - Returns: 返回former
    @discardableResult public final func cellUpdate(_ update: ((T) -> Void)) -> Self {
        update(cell)
        return self
    }
    
    /// cell初始化
    /// - Parameter cell: cell泛型
    open func cellInitialized(_ cell: T) {
        
    }

    
    /// cell初始化
    /// - Parameter cell: cell
    override func cellInstanceInitialized(_ cell: UITableViewCell) {
        cellInitialized(cell as! T)
    }
}
