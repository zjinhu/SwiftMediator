//
//  JHBaseTableViewCell.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit

open class JHTableViewCell: UITableViewCell {

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.configCellViews()
    }
    
    // MARK: - 继承 在内部实现布局
    open func configCellViews() {
        
    }
    // MARK: - cell赋值
    open func setCellModel(model: Any) {
        
    }
    // MARK: - 获取高度
    public func getCellHeightWithModel(model: Any) -> CGFloat {
        self.setCellModel(model: model)
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        let height = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    // MARK: - 注册
    public class func registerCell(tableView: UITableView, reuseIdentifier: String = String.init(describing: self)) {
        tableView.register(self, forCellReuseIdentifier: reuseIdentifier)
    }
    // MARK: - 复用取值
    public class func dequeueReusableCell(tableView: UITableView, reuseIdentifier: String = String.init(describing: self)) ->UITableViewCell{
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
    }
}
