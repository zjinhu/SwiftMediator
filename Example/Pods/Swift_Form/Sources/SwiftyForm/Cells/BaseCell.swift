//
//  FormCell.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit
///基础cell
open class BaseCell: UITableViewCell, FormableRow {
    open func updateWithRowFormer(_ rowFormer: RowFormer) {
        
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    
    open func setup() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }
}
