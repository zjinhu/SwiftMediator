//
//  BaseHeaderFooterFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

open class BaseHeaderFooterFormer<T: UITableViewHeaderFooterView> : ViewFormer, ConfigurableForm {

    
    /// 获取form中的headerfooter
    public var headerFooter: T {
        return viewInstance as! T
    }
    
    public init() {
        super.init(withViewType: T.self)
    }
    
    /// 创建headerFooter上控件
    /// - Parameter handler: handler description
    /// - Returns: description
    public final func viewSetup(handler: ((T) -> Void)) -> Self {
        handler(headerFooter)
        return self
    }
    
    /// headerFooter 更新
    /// - Parameter update: update description
    /// - Returns: description
    public final func viewUpdate(update: ((T) -> Void)) -> Self {
        update(headerFooter)
        return self
    }
    
    /// headerFooter初始化
    /// - Parameter view: view description
    open func viewInitialized(_ view: T) {
        
    }
    
    /// headerFooter初始化
    /// - Parameter view: view description
    override func viewInstanceInitialized(_ view: UITableViewHeaderFooterView) {
        viewInitialized(view as! T)
    }
}
