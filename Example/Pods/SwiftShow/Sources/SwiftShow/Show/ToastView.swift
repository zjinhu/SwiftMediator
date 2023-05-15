//
//  ToastView.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit


class ToastView: UIView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String,
         subTitle: String? = nil,
         image: UIImage? = nil,
         config : ShowToastConfig) {

        super.init(frame: CGRect.zero)
        
        let containerView = UIView()
        addSubview(containerView)
        containerView.backgroundColor = config.bgColor
        containerView.layer.cornerRadius = config.cornerRadius
        if config.shadowColor != UIColor.clear.cgColor {
            containerView.layer.shadowColor = config.shadowColor
            containerView.layer.shadowOpacity = config.shadowOpacity
            containerView.layer.shadowRadius = config.shadowRadius
            containerView.layer.shadowOffset = CGSize.zero
        }
        containerView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        let view = CommonView(title: title,
                              subtitle: subTitle,
                              image: image,
                              imageType: config.imageType,
                              spaceImage: config.spaceImage,
                              spaceText: config.spaceText)
        
        view.titleLabel.textColor = config.titleColor
        view.titleLabel.font = config.titleFont
        
        view.subtitleLabel.textColor = config.subTitleColor
        view.subtitleLabel.font = config.subTitleFont
        
        containerView.addSubview(view)

        view.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(config.padding)
            make.bottom.right.equalToSuperview().offset(-config.padding)
            make.width.lessThanOrEqualTo(config.maxWidth)
            make.height.lessThanOrEqualTo(config.maxHeight)
        }
    }

}
