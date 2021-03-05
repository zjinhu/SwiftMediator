//
//  LoadingView.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SwiftButton
import SnapKit

class LoadingView: UIView {
    
    private var loadingConfig : ShowLoadingConfig
    
    private lazy var loadingView: SwiftButton = {
        let loadingView = SwiftButton.init(loadingConfig.imageType, marginArr: [loadingConfig.space])
        loadingView.backgroundColor = .clear
        loadingView.titleLabel.textColor = loadingConfig.textColor
        loadingView.titleLabel.font = loadingConfig.textFont
        loadingView.titleLabel.numberOfLines = 0
        loadingView.titleLabel.textAlignment = .center
//        loadingView.titleLabel.backgroundColor = .purple
//        loadingView.backgroundColor = .cyan
        return loadingView
    }()
    
    var title : String?{
        didSet{
            loadingView.title = title
        }
    }
    
    init(_ config : ShowLoadingConfig) {
        
        loadingConfig = config
        
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

        containerView.addSubview(loadingView)
        loadingView.titleLabel.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(config.maxWidth)
        }
        loadingView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(config.verticalPadding)
            make.bottom.equalToSuperview().offset(-config.verticalPadding)
            make.left.equalToSuperview().offset(config.horizontalPadding)
            make.right.equalToSuperview().offset(-config.horizontalPadding)
        }
        
        if let array = config.imagesArray{
            guard let image = array.first else {
                return
            }
            loadingView.image = image
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
