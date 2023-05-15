//
//  DropDownView.swift
//  SwiftShow
//
//  Created by iOS on 2020/8/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit
class DropDownView: UIView {
    
    private var dropDownConfig : ShowDropDownConfig
    
    private weak var contentVie : UIView?
    private var contentSize = CGSize.zero
    
    private lazy var backCtl: UIControl = {
        let backCtl = UIControl()
        backCtl.addTarget(self, action: #selector(backClick), for: .touchUpInside)
        return backCtl
    }()
    
    typealias CallBack = () -> Void
    private var hiddenDrop : CallBack?
    
    init(contentView: UIView, config : ShowDropDownConfig, hiden : CallBack? = nil) {
        dropDownConfig = config
        let frame = CGRect.init(x: 0, y: config.fromY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - config.fromY)
        super.init(frame: frame)
        clipsToBounds = true
        
        hiddenDrop = hiden
        contentVie = contentView
        contentSize = contentView.bounds.size
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: dropDownConfig.effectStyle))
        addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        switch dropDownConfig.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = dropDownConfig.bgColor
        }
        
        addSubview(backCtl)
        backCtl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset( -contentSize.height)
            make.centerX.equalToSuperview()
            make.size.equalTo(contentSize)
        }
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backClick(){
        if dropDownConfig.clickOutHidden {
            hiddenDrop?()
        }
    }
    
    func showAnimate(_ block: CallBack?){
        
        contentVie?.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(0)
        }
        
        if dropDownConfig.animateDamping {
            UIView.animate(withDuration: dropDownConfig.animateDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                block?()
            }
        }else{
            UIView.animate(withDuration: dropDownConfig.animateDuration, animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                block?()
            }

        }
    }
    
    func hideAnimate(_ block: CallBack?){
        
        contentVie?.snp.updateConstraints { (make) in
            make.top.equalTo(self.snp.top).offset( -contentSize.height)
        }
        
        UIView.animate(withDuration: dropDownConfig.animateDuration, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            block?()
        }
    }
}
