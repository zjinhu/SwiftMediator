//
//  UserCell.swift
//  SwiftyForm
//
//  Created by iOS on 2020/7/1.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
/// 用户头像样式cell 上方avatarView 中间userNameLabel 底部userInfoLabel
public class UserRow: UserRowFormer<UserCell> {

}
/// 用户头像样式cell 左侧avatarView 中间userNameLabel userInfoLabel  右侧mark箭头(cell自带)
public class User2Row: UserRowFormer<User2Cell> {

}


open class UserCell: BaseCell, UserFormableRow {

    public private(set) weak var userNameLabel: UILabel!
    public private(set) weak var userInfoLabel: UILabel!
    public private(set) weak var avatarView: UIImageView!
    
    public func formUserInfoLabel() -> UILabel? {
        return userInfoLabel
    }
    
    public func formUserNameLabel() -> UILabel? {
        return userNameLabel
    }
    
    public func formAvatarView() -> UIImageView? {
        return avatarView
    }
    
    open override func setup() {
        super.setup()
        
        let avatarView = UIImageView()
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .lightGray
        contentView.addSubview(avatarView)
        self.avatarView = avatarView
        
        let userNameLabel = UILabel()
        userNameLabel.textAlignment = .center
        contentView.addSubview(userNameLabel)
        self.userNameLabel = userNameLabel
        
        let userInfoLabel = UILabel()
        userInfoLabel.textAlignment = .center
        userInfoLabel.textColor = .lightGray
        contentView.addSubview(userInfoLabel)
        self.userInfoLabel = userInfoLabel
        
        avatarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        userInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        

    }

    open override func updateWithRowFormer(_ rowFormer: RowFormer) {

    }
}


open class User2Cell: BaseCell, UserFormableRow {

    public private(set) weak var userNameLabel: UILabel!
    public private(set) weak var userInfoLabel: UILabel!
    public private(set) weak var avatarView: UIImageView!
    
    public func formUserInfoLabel() -> UILabel? {
        return userInfoLabel
    }
    
    public func formUserNameLabel() -> UILabel? {
        return userNameLabel
    }
    
    public func formAvatarView() -> UIImageView? {
        return avatarView
    }
    
    open override func setup() {
        super.setup()
        
        let avatarView = UIImageView()
        avatarView.clipsToBounds = true
        avatarView.backgroundColor = .lightGray
        contentView.addSubview(avatarView)
        self.avatarView = avatarView
        
        let userNameLabel = UILabel()
        userNameLabel.textAlignment = .left
        contentView.addSubview(userNameLabel)
        self.userNameLabel = userNameLabel
        
        let userInfoLabel = UILabel()
        userInfoLabel.numberOfLines = 2
        userInfoLabel.textAlignment = .left
        userInfoLabel.textColor = .lightGray
        contentView.addSubview(userInfoLabel)
        self.userInfoLabel = userInfoLabel
        
        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(avatarView.snp.centerY)
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
        userInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarView.snp.centerY).offset(3)
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        

    }

    open override func updateWithRowFormer(_ rowFormer: RowFormer) {

    }
}
