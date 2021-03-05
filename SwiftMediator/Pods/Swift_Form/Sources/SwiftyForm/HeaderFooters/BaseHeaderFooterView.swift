//
//  FormHeaderFooterView.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit

open class BaseHeaderFooterView: UITableViewHeaderFooterView, FormableHeaderFooter {
    
    public var backColor : UIColor? {
        didSet{
            self.backgroundView?.backgroundColor = backColor
        }
    }
    
    open func updateHeaderFooterFormer(_ headerFooterFormer: ViewFormer) {
        
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = .clear
        setup()
    }
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = .clear
        setup()
    }
    
    open func setup() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
