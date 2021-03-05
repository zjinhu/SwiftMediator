//
//  ToastView.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SwiftButton
import SnapKit
class ToastView: UIView {
    
    private var toastConfig : ShowToastConfig
    
    private lazy var toastView: SwiftButton = {
        let toastView = SwiftButton.init(toastConfig.imageType, marginArr: [toastConfig.space])
        toastView.backgroundColor = .clear
        toastView.titleLabel.textColor = toastConfig.textColor
        toastView.titleLabel.font = toastConfig.textFont
        toastView.titleLabel.numberOfLines = 0
        toastView.titleLabel.textAlignment = .center
        return toastView
    }()
    
    var title : String?{
        didSet{
            toastView.title = title
        }
    }
    
    var image : UIImage?{
        didSet{
            toastView.image = image
        }
    }
    
    init(_ config : ShowToastConfig) {
        toastConfig = config
        
        super.init(frame: CGRect.zero)
        
        let containerView = UIView.init()
        addSubview(containerView)
        containerView.backgroundColor = toastConfig.bgColor
        containerView.layer.cornerRadius = toastConfig.cornerRadius
        if toastConfig.shadowColor != UIColor.clear.cgColor {
            containerView.layer.shadowColor = toastConfig.shadowColor
            containerView.layer.shadowOpacity = toastConfig.shadowOpacity
            containerView.layer.shadowRadius = toastConfig.shadowRadius
            containerView.layer.shadowOffset = CGSize.zero
        }
        containerView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        containerView.addSubview(toastView)
        toastView.titleLabel.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(toastConfig.maxWidth)
            make.height.lessThanOrEqualTo(toastConfig.maxHeight)
        }
        toastView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(toastConfig.padding)
            make.bottom.right.equalToSuperview().offset(-toastConfig.padding)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
