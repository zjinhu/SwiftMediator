//
//  AlertView.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/10.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SwiftButton
import SnapKit


public typealias LeftCallBack = () -> Void
public typealias RightCallback = () -> Void
public typealias DismissCallback = () -> Void

class AlertView: UIView {

    private var alertConfig : ShowAlertConfig

    var leftBlock : LeftCallBack?
    var rightBlock : RightCallback?
    var dismissBlock : DismissCallback?
     
    private lazy var titleView: SwiftButton = {
        let titleView = SwiftButton.init(alertConfig.imageType, marginArr: [alertConfig.space])
        titleView.backgroundColor = .clear
        titleView.titleLabel.textColor = alertConfig.titleColor
        titleView.titleLabel.font = alertConfig.titleFont
        titleView.titleLabel.numberOfLines = 0
        titleView.titleLabel.textAlignment = .center
        return titleView
    }()
    
    private lazy var rightBtn : UIButton = {
        let rightBtn = UIButton.init(type: .custom)
         rightBtn.titleLabel?.font = alertConfig.buttonFont
         rightBtn.setTitleColor(alertConfig.rightColor, for: .normal)
         rightBtn.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        return rightBtn
    }()
    
    private lazy var messageLabel : UILabel = {
        let messageLabel = UILabel.init()
        messageLabel.backgroundColor = .clear
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = alertConfig.textColor
        messageLabel.font = alertConfig.textFont
        return messageLabel
    }()
    
    private lazy var leftBtn : UIButton = {
        let leftBtn = UIButton.init(type: .custom)
        leftBtn.titleLabel?.font = alertConfig.buttonFont
        leftBtn.setTitleColor(alertConfig.leftColor, for: .normal)
        leftBtn.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        return leftBtn
    }()

    init(title: String? = nil,
         attributedTitle : NSAttributedString? = nil,
         titleImage: UIImage? = nil,
         message: String?  = nil,
         attributedMessage : NSAttributedString? = nil,
         leftBtnTitle: String? = nil,
         leftBtnAttributedTitle: NSAttributedString? = nil,
         rightBtnTitle: String? = nil,
         rightBtnAttributedTitle: NSAttributedString? = nil,
         config : ShowAlertConfig) {
        
        alertConfig = config
        
        super.init(frame: CGRect.zero)
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: alertConfig.effectStyle))
        addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        switch alertConfig.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = alertConfig.bgColor
        }
        
        let containerView = UIView.init() 
        addSubview(containerView)
        containerView.backgroundColor = alertConfig.tintColor
        containerView.layer.cornerRadius = alertConfig.cornerRadius
        if alertConfig.shadowColor != UIColor.clear.cgColor {
            containerView.layer.shadowColor = alertConfig.shadowColor
            containerView.layer.shadowOpacity = alertConfig.shadowOpacity
            containerView.layer.shadowRadius = alertConfig.shadowRadius
            containerView.layer.shadowOffset = CGSize.zero
        }
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(alertConfig.width)
            make.height.lessThanOrEqualTo(alertConfig.maxHeight)
        }
        

        if let att = attributedTitle{
            titleView.titleLabel.attributedText = att
        }else{
            titleView.title = title
        }
        
        titleView.image = titleImage
        containerView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
        }
        titleView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        

        if let att = attributedMessage{
            messageLabel.attributedText = att
        }else{
            messageLabel.text = message
        }
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
         }
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let lineView = UIView.init()
        lineView.backgroundColor = alertConfig.lineColor
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(1/UIScreen.main.scale)
        }
        
        if let att = leftBtnAttributedTitle{
            leftBtn.setAttributedTitle(att, for: .normal)
        }else{
            leftBtn.setTitle(leftBtnTitle, for: .normal)
        }
        containerView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(containerView.snp.centerX)
            make.height.equalTo(alertConfig.buttonHeight)
        }
        
        if let att = rightBtnAttributedTitle{
            rightBtn.setAttributedTitle(att, for: .normal)
        }else{
            rightBtn.setTitle(rightBtnTitle, for: .normal)
        }
        containerView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(leftBtnTitle != nil || leftBtnAttributedTitle != nil ? containerView.snp.centerX : containerView.snp.left)
            make.right.equalToSuperview()
            make.height.equalTo(alertConfig.buttonHeight)
            make.bottom.equalToSuperview()
        }
        
        let vLineView = UIView.init()
        vLineView.backgroundColor = alertConfig.lineColor
        containerView.addSubview(vLineView)
        vLineView.snp.makeConstraints { (make) in
            make.top.equalTo(rightBtn.snp.top)
            make.bottom.equalTo(rightBtn.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(1/UIScreen.main.scale)
        }
        
        if leftBtnTitle != nil || leftBtnAttributedTitle != nil  {
            leftBtn.isHidden = false
            vLineView.isHidden = false
        }else{
            leftBtn.isHidden = true
            vLineView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func leftClick() {
        dismiss()
        guard let block = leftBlock else {
            return
        }
        block()
    }
    @objc
    func rightClick() {
        dismiss()
        guard let block = rightBlock else {
            return
        }
        block()
    }
    @objc
    func dismiss() {
        guard let block = dismissBlock else {
            return
        }
        block()
    }
}
