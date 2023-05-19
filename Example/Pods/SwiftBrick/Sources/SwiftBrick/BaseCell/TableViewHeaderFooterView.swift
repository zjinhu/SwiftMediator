//
//  JHTableViewHeaderFooterView.swift
//  SwiftBrick
//
//  Created by iOS on 19/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================Cell基类:UITableViewHeaderFooterView=========================================
open class TableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable{

    public var backColor: UIColor? {
        didSet{
            backgroundView?.backgroundColor = backColor
        }
    }
    
    public override init(reuseIdentifier: String? = String(describing: TableViewHeaderFooterView.self)) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = .clear
        setupCellViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 继承 在内部实现布局
    /// 子类重写，进行view布局
    open func setupCellViews() {
        
    }
    
}
