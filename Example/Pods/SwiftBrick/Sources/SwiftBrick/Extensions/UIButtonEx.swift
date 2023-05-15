//
//  UIButtonEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/1/15.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================扩展: UIButton扩展图文=========================================
public enum ImagePosition {
    case imagePositionLeft
    case imagePositionRight
    case imagePositionTop
    case imagePositionBottom
}

public extension UIButton{
    
    /// UIButton 图文布局 外观大小不固定 固定间距
    /// - Parameters:
    ///   - postion: 布局样式
    ///   - space: 图文间距
    func layoutButton(_ postion: ImagePosition, space: CGFloat) {
        
        guard
            let imageSize = imageView?.image?.size,
            let text = titleLabel?.text,
            let font = titleLabel?.font else { return }
        
        let titleSize = text.size(withAttributes: [.font: font])
        
        let imageOffsetX = (imageSize.width + titleSize.width) / 2 - imageSize.width / 2//image中心移动的x距离
        let imageOffsetY = imageSize.height / 2 + space / 2//image中心移动的y距离
        let labelOffsetX = (imageSize.width + titleSize.width / 2) - (imageSize.width + titleSize.width) / 2//label中心移动的x距离
        let labelOffsetY = titleSize.height / 2 + space / 2//label中心移动的y距离
        
        let tempWidth = max(titleSize.width, imageSize.width)
        let changedWidth = titleSize.width + imageSize.width - tempWidth
        let tempHeight = max(titleSize.height, imageSize.height);
        let changedHeight = titleSize.height + imageSize.height + space - tempHeight

        switch postion {
        case .imagePositionTop:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -0.5 * changedWidth, bottom: changedHeight-imageOffsetY, right: -0.5 * changedWidth)
            
        case .imagePositionBottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom:labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedHeight-imageOffsetY, left: -0.5 * changedWidth, bottom: imageOffsetY, right: -0.5 * changedWidth)
            
        case .imagePositionRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + 0.5 * space, bottom: 0, right: -(titleSize.width + 0.5 * space))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + 0.5 * space), bottom: 0, right: imageSize.width + space * 0.5)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0.5*space)
            
        default:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -0.5 * space, bottom: 0, right: 0.5 * space)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: -0.5 * space)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0.5 * space)
        }

    }
    
    /// UIButton 图文布局 外观大小固定
    /// - Parameters:
    ///   - postion: 布局样式
    ///   - margin: 图文距离左右两边
    func layoutButton(_ postion: ImagePosition, margin: CGFloat) {

        guard
            let imageSize = imageView?.image?.size,
            let text = titleLabel?.text,
            let font = titleLabel?.font else { return }
        
        let titleSize = text.size(withAttributes: [.font: font])
        
        let space = bounds.size.width - imageSize.width - titleSize.width - 2 * margin
        layoutButton(postion, space: space)
    }
}

public typealias ButtonClosure = (_ sender: UIButton) -> Void

public extension UIButton {
    
    struct AssociatedKeys {
        static var buttonTouchUpKey: String = "ButtonTouchUpKey"
    }

    @objc internal var actionClosure: ButtonClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.buttonTouchUpKey) as? ButtonClosure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.buttonTouchUpKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    func addTouchUpInSideBtnAction(touchUp: ButtonClosure?){
        
        removeTarget(self, action: #selector(touchUpInSideBtnAction), for: .touchUpInside)
        guard let ges = touchUp else {
            return
        }
        actionClosure = ges
        addTarget(self, action: #selector(touchUpInSideBtnAction), for: .touchUpInside)
    }
    
    @objc func touchUpInSideBtnAction() {
        if let action = actionClosure  {
            action(self)
        }
    }
}

public extension UIButton {
    @IBInspectable
    var imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }

    @IBInspectable
    var imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }

    @IBInspectable
    var imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }

    @IBInspectable
    var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }

    @IBInspectable
    var titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }

    @IBInspectable
    var titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }

    @IBInspectable
    var titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }

    @IBInspectable
    var titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }

    @IBInspectable
    var titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }

    @IBInspectable
    var titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }

    @IBInspectable
    var titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }

    @IBInspectable
    var titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }
    
    @IBInspectable
    var backImageForNormal: UIImage? {
        get {
            return backgroundImage(for: .normal)
        }
        set {
            setBackgroundImage(newValue, for: .normal)
        }
    }
    
    @IBInspectable
    var backImageForHighlighted: UIImage? {
        get {
            return backgroundImage(for: .highlighted)
        }
        set {
            setBackgroundImage(newValue, for: .highlighted)
        }
    }
    
    @IBInspectable
    var backImageForSelected: UIImage? {
        get {
            return backgroundImage(for: .selected)
        }
        set {
            setBackgroundImage(newValue, for: .selected)
        }
    }
    
    @IBInspectable
    var backImageForDisabled: UIImage? {
        get {
            return backgroundImage(for: .disabled)
        }
        set {
            setBackgroundImage(newValue, for: .disabled)
        }
    }

}

public extension UIButton {
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}

@available(iOS 14.0, *)
public extension UIControl {
    func addAction(for event: UIControl.Event, handler: @escaping UIActionHandler) {
            addAction(UIAction(handler:handler), for:event)
    }
}
