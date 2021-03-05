//
//  HeaderFooterFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public protocol FormableHeaderFooter{
    
    func updateHeaderFooterFormer(_ headerFooterFormer: ViewFormer)
}

open class ViewFormer {
    
    open var viewHeight: CGFloat = .leastNormalMagnitude
    
    internal func viewInstanceInitialized(_ view: UITableViewHeaderFooterView) {
        
    }
    
    // MARK: Private
    private var _viewInstance: UITableViewHeaderFooterView?
    private final let viewType: UITableViewHeaderFooterView.Type
    internal final var viewSetup: ((UITableViewHeaderFooterView) -> Void)?
    
    public init<T: UITableViewHeaderFooterView>(withViewType type: T.Type) {
            viewType = type
            initialized()
    }
    
    @discardableResult
    public final func viewSetup(_ handler: @escaping ((UITableViewHeaderFooterView) -> Void)) -> Self {
        viewSetup = handler
        return self
    }
    
    @discardableResult
    public func dynamicViewHeight(_ handler: @escaping ((UITableView, /*section:*/Int) -> CGFloat)) -> Self {
        dynamicViewHeight = handler
        return self
    }
    
    open func initialized() {
        
    }
    
    open func update() {
        if let formableView = viewInstance as? FormableHeaderFooter {
            formableView.updateHeaderFooterFormer(self)
        }
    }
    
    // MARK: Internal
    
    internal final var dynamicViewHeight: ((UITableView, Int) -> CGFloat)?
    
    internal final var viewInstance: UITableViewHeaderFooterView {
        if _viewInstance == nil {
            _viewInstance = viewType.init(reuseIdentifier: nil)
            viewInstanceInitialized(_viewInstance!)
            viewSetup?(_viewInstance!)
        }
        return _viewInstance!
    }
}
