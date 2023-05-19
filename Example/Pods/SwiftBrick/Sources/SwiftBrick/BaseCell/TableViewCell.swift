//
//  JHBaseTableViewCell.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
// MARK: ===================================Cell基类:UITableViewCell=========================================
open class TableViewCell: UITableViewCell, Reusable{

    override open func awakeFromNib() {
        super.awakeFromNib()

    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = String(describing: TableViewCell.self)) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        setupCellViews()
    }
    
    // MARK: - 继承 在内部实现布局
    /// 子类重写，进行view布局
    open func setupCellViews() {
        
    }
    
}
