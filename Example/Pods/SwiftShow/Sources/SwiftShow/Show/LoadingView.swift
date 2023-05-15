//
//  LoadingView.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {
 
    init(title: String? = nil,
         subTitle: String? = nil, 
         config : ShowLoadingConfig) {
 
        super.init(frame: CGRect.zero)
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: config.effectStyle))
        addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        switch config.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = config.bgColor
        }
        
        let containerView = UIView.init()
        addSubview(containerView)
        
        containerView.backgroundColor = config.tintColor
        containerView.layer.cornerRadius = config.cornerRadius
        if config.shadowColor != UIColor.clear.cgColor {
            containerView.layer.shadowColor = config.shadowColor
            containerView.layer.shadowOpacity = config.shadowOpacity
            containerView.layer.shadowRadius = config.shadowRadius
            containerView.layer.shadowOffset = CGSize.zero
        }
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        let loadingView = CommonView(title: title,
                              subtitle: subTitle,
                              image: UIImage(),
                              imageType: config.imageType,
                              spaceImage: config.spaceImage,
                              spaceText: config.spaceText)
        
        loadingView.titleLabel.textColor = config.titleColor
        loadingView.titleLabel.font = config.titleFont
        
        loadingView.subtitleLabel.textColor = config.subTitleColor
        loadingView.subtitleLabel.font = config.subTitleFont
        
        containerView.addSubview(loadingView)

        loadingView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(config.verticalPadding)
            make.bottom.equalToSuperview().offset(-config.verticalPadding)
            make.left.equalToSuperview().offset(config.horizontalPadding)
            make.right.equalToSuperview().offset(-config.horizontalPadding)
            make.width.lessThanOrEqualTo(config.maxWidth)
        }
        
        if let array = config.imagesArray{
            guard let image = array.first else {
                return
            }
            loadingView.imageView.image = image
            loadingView.imageView.animationImages = config.imagesArray
            loadingView.imageView.animationDuration = config.animationTime
            loadingView.imageView.animationRepeatCount = 0
            loadingView.imageView.startAnimating()
        }else{
            let activityIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
            activityIndicatorView.color = config.activityColor
            let transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            activityIndicatorView.transform = transform
            activityIndicatorView.startAnimating()
            loadingView.imageView.addSubview(activityIndicatorView)
            activityIndicatorView.snp.makeConstraints { (make) in
                make.top.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
