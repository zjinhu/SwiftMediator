//
//  UserRowFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/7/1.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// AvatarForm协议
public protocol UserFormableRow: FormableRow {
    
    func formUserNameLabel() -> UILabel?
    func formUserInfoLabel() -> UILabel?
    func formAvatarView() -> UIImageView?
}

/// AvatarForm
open class UserRowFormer<T: UITableViewCell> : BaseRowFormer<T>, Formable where T: UserFormableRow {
    ///头像
    public var avatarImage: UIImage?
    ///头像圆角
    public var avatarRadius: CGFloat = 40
    ///用户名
    public var userName: String?
    ///用户名 不可用时颜色
    public var userNameDisabledColor: UIColor? = .lightGray
    ///用户名 颜色
    public var userNameColor: UIColor?
    ///用户信息简介
    public var userInfo: String?
    ///用户信息简介 不可用时颜色
    public var userInfoDisabledColor: UIColor? = .lightGray
    ///用户信息简介 颜色
    public var userInfoColor: UIColor?
    
    /// AvatarForm初始化
    open override func initialized() {
        rowHeight = 150
    }
    /// AvatarForm初始化
    open override func cellInitialized(_ cell: T) {

    }
    
    open override func cellSelected(indexPath: IndexPath) {
        super.cellSelected(indexPath: indexPath)
        former?.deselect(animated: true)
    }
    
    /// AvatarForm数据更新
    open override func update() {
        super.update()

        let userNameLabel = cell.formUserNameLabel()
        let userInfoLabel = cell.formUserInfoLabel()
        let avatarView = cell.formAvatarView()
        userNameLabel?.text = userName
        userInfoLabel?.text = userInfo
        avatarView?.image = avatarImage
        avatarView?.layer.cornerRadius = avatarRadius
        if enabled {
            _ = userNameColor.map { userNameLabel?.textColor = $0 }
            _ = userInfoColor.map { userInfoLabel?.textColor = $0 }
            userNameColor = nil
            userInfoColor = nil
        } else {
            if userNameColor == nil { userNameColor = userNameLabel?.textColor ?? .black }
            userNameLabel?.textColor = userNameDisabledColor
            
            if userInfoColor == nil { userInfoColor = userInfoLabel?.textColor ?? .black }
            userInfoLabel?.textColor = userInfoDisabledColor
        }
    }
}
