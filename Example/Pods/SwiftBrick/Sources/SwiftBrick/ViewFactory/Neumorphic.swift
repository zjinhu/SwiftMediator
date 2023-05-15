//
//  Neumorphic.swift
//  SwiftBrick
//
//  Created by HU on 2022/8/8.
//  Copyright © 2022 狄烨 . All rights reserved.
//

import Foundation
import UIKit
import SnapKit
public enum NeuButtonType {
    case active
    case toggle
    case noActive
}

public class NeuButton: UIControl {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createSubLayers()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        createSubLayers()
    }
    
    open var type: NeuButtonType = .active {
        didSet { updateShadowLayers() }
    }
    
    open var backColor: UIColor = NeuButton.defalutMainColorColor {
        didSet { updateBackColor() }
    }
    
    open var darkShadowColor: UIColor = NeuButton.defalutDarkShadowColor {
        didSet { updateDarkShadowColor() }
    }
    
    open var lightShadowColor: UIColor = NeuButton.defalutLightShadowColor {
        didSet { updateLightShadowColor() }
    }
    
    open var shadowOffset: CGSize = NeuButton.defalutShadowOffset {
        didSet { updateShadowOffset() }
    }
    
    open var shadowOpacity: Float = NeuButton.defalutShadowOpacity {
        didSet { updateShadowOpacity() }
    }
    
    open var shadowRadius: CGFloat = NeuButton.defalutShadowRadius {
        didSet { updateShadowRadius() }
    }
    
    open var cornerRadius: CGFloat = NeuButton.defalutCornerRadius {
        didSet { updateSublayersShape() }
    }
    
    open override var bounds: CGRect {
        didSet { updateSublayersShape() }
    }
    
    open override var isSelected: Bool {
        didSet {
            updateShadowLayers()
            updateContentView()
        }
    }
    
    open override var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .active:
            isSelected = true
        case .toggle:
            isSelected = !isSelected
        case .noActive:
            break
        }
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .active:
            isSelected = isTracking
        case .noActive, .toggle:
            break
        }
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .active:
            isSelected = false
        case .noActive, .toggle:
            break
        }
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch type {
        case .active:
            isSelected = false
        case .noActive, .toggle:
            break
        }
        super.touchesCancelled(touches, with: event)
    }
    
    private var backgroundLayer: CALayer!
    private var darkOuterShadowLayer: CAShapeLayer!
    private var lightOuterShadowLayer: CAShapeLayer!
    private var darkInnerShadowLayer: CAShapeLayer!
    private var lightInnerShadowLayer: CAShapeLayer!
    
    private var normalView: UIView?
    private var selectedView: UIView?
    private var selectedTransform: CGAffineTransform?
    
}

extension NeuButton {
    
    public func setContentView(_ normalView: UIView,
                               selectedView: UIView? = nil,
                               selectedTransform: CGAffineTransform? = CGAffineTransform.init(scaleX: 0.95, y: 0.95),
                               snapKitMaker: ((_ make: ConstraintMaker) -> Void)) {
        
        resetContentView(normalView,
                         selectedView: selectedView,
                         selectedTransform: selectedTransform,
                         snapKitMaker: snapKitMaker)
    }
    
    func resetContentView(_ normalView: UIView?,
                          selectedView: UIView? = nil,
                          selectedTransform: CGAffineTransform? = CGAffineTransform.init(scaleX: 0.95, y: 0.95),
                          snapKitMaker: ((_ make: ConstraintMaker) -> Void)) {
        
        self.normalView.map {
            $0.transform = .identity
            $0.removeFromSuperview()
        }
        self.selectedView.map { $0.removeFromSuperview() }
        
        normalView.map {
            $0.isUserInteractionEnabled = false
            addSubview($0)
            $0.snp.makeConstraints { make in
                snapKitMaker(make)
            }
        }
        selectedView.map {
            $0.isUserInteractionEnabled = false
            addSubview($0)
            $0.snp.makeConstraints({ make in
                make.edges.equalTo(normalView!)
            })
        }
        
        self.normalView = normalView
        self.selectedView = selectedView
        self.selectedTransform = selectedTransform
        
        updateContentView()
    }
    
    func updateContentView() {
        if isSelected, selectedView != nil {
            showSelectedContentView()
        } else if isSelected, selectedTransform != nil {
            showSelectedTransform()
        } else {
            showContentView()
        }
    }
    
    func showContentView() {
        normalView?.isHidden = false
        normalView?.transform = .identity
        selectedView?.isHidden = true
    }
    
    func showSelectedContentView() {
        normalView?.isHidden = true
        normalView?.transform = .identity
        selectedView?.isHidden = false
    }
    
    func showSelectedTransform() {
        normalView?.isHidden = false
        selectedTransform.map { normalView?.transform = $0 }
        selectedView?.isHidden = true
    }
}

extension NeuButton {
    
    public static let defalutMainColorColor: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    public static let defalutDarkShadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public static let defalutLightShadowColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public static let defalutShadowOffset: CGSize = .init(width: 6, height: 6)
    public static let defalutShadowOpacity: Float = 1
    public static let defalutShadowRadius: CGFloat = 5
    public static let defalutCornerRadius: CGFloat = 10
    
}

private extension NeuButton {
    
    func createSubLayers() {
        
        lightOuterShadowLayer = {
            let shadowLayer = createOuterShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
            layer.addSublayer(shadowLayer)
            return shadowLayer
        }()
        
        darkOuterShadowLayer = {
            let shadowLayer = createOuterShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
            layer.addSublayer(shadowLayer)
            return shadowLayer
        }()
        
        backgroundLayer = {
            let backgroundLayer = CALayer()
            layer.addSublayer(backgroundLayer)
            backgroundLayer.frame = bounds
            backgroundLayer.cornerRadius = cornerRadius
            backgroundLayer.backgroundColor = backColor.cgColor
            return backgroundLayer
        }()
        
        darkInnerShadowLayer = {
            let shadowLayer = createInnerShadowLayer(shadowColor: darkShadowColor, shadowOffset: shadowOffset)
            layer.addSublayer(shadowLayer)
            shadowLayer.isHidden = true
            return shadowLayer
        }()
        
        lightInnerShadowLayer = {
            let shadowLayer = createInnerShadowLayer(shadowColor: lightShadowColor, shadowOffset: shadowOffset.inverse)
            layer.addSublayer(shadowLayer)
            shadowLayer.isHidden = true
            return shadowLayer
        }()
        
        updateSublayersShape()
    }
    
    func createOuterShadowLayer(shadowColor: UIColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = backColor.cgColor
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        return layer
    }
    
    func createOuterShadowPath() -> CGPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    func createInnerShadowLayer(shadowColor: UIColor, shadowOffset: CGSize) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = backColor.cgColor
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.fillRule = .evenOdd
        return layer
    }
    
    func createInnerShadowPath() -> CGPath {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: -100, dy: -100), cornerRadius: cornerRadius)
        path.append(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius))
        return path.cgPath
    }
    
    func createInnerShadowMask() -> CALayer {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        return layer
    }
    
    func updateSublayersShape() {
        backgroundLayer.frame = bounds
        backgroundLayer.cornerRadius = cornerRadius
        
        darkOuterShadowLayer.path = createOuterShadowPath()
        lightOuterShadowLayer.path = createOuterShadowPath()
        
        darkInnerShadowLayer.path = createInnerShadowPath()
        darkInnerShadowLayer.mask = createInnerShadowMask()
        
        lightInnerShadowLayer.path = createInnerShadowPath()
        lightInnerShadowLayer.mask = createInnerShadowMask()
    }
    
    func updateBackColor() {
        backgroundLayer.backgroundColor = backColor.cgColor
        darkOuterShadowLayer.fillColor = backColor.cgColor
        lightOuterShadowLayer.fillColor = backColor.cgColor
        darkInnerShadowLayer.fillColor = backColor.cgColor
        lightInnerShadowLayer.fillColor = backColor.cgColor
    }
    
    func updateDarkShadowColor() {
        darkOuterShadowLayer.shadowColor = darkShadowColor.cgColor
        darkInnerShadowLayer.shadowColor = darkShadowColor.cgColor
    }
    
    func updateLightShadowColor() {
        lightOuterShadowLayer.shadowColor = lightShadowColor.cgColor
        lightInnerShadowLayer.shadowColor = lightShadowColor.cgColor
    }
    
    func updateShadowOffset() {
        darkOuterShadowLayer.shadowOffset = shadowOffset
        lightOuterShadowLayer.shadowOffset = shadowOffset.inverse
        darkInnerShadowLayer.shadowOffset = shadowOffset
        lightInnerShadowLayer.shadowOffset = shadowOffset.inverse
    }
    
    func updateShadowOpacity() {
        darkOuterShadowLayer.shadowOpacity = shadowOpacity
        lightOuterShadowLayer.shadowOpacity = shadowOpacity
        darkInnerShadowLayer.shadowOpacity = shadowOpacity
        lightInnerShadowLayer.shadowOpacity = shadowOpacity
    }
    
    func updateShadowRadius() {
        darkOuterShadowLayer.shadowRadius = shadowRadius
        lightOuterShadowLayer.shadowRadius = shadowRadius
        darkInnerShadowLayer.shadowRadius = shadowRadius
        lightInnerShadowLayer.shadowRadius = shadowRadius
    }
    
    func updateShadowLayers() {
        darkOuterShadowLayer.isHidden = isSelected
        lightOuterShadowLayer.isHidden = isSelected
        darkInnerShadowLayer.isHidden = !isSelected
        lightInnerShadowLayer.isHidden = !isSelected
    }
    
}

extension CGSize {
    
    var inverse: CGSize {
        .init(width: -1 * width, height: -1 * height)
    }
    
}
