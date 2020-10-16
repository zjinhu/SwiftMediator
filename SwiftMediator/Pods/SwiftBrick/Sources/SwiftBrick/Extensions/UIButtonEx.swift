//
//  UIButtonEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/1/15.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
public enum ImagePosition {
    case imagePositionLeft
    case imagePositionRight
    case imagePositionTop
    case imagePositionBottom
}
public extension UIButton{
    func layoutButton(_ postion: ImagePosition, space: CGFloat) {
        
        guard let titleL = titleLabel, let imageV = imageView else {
            return
        }
        
        setTitle(currentTitle, for: .normal)
        setImage(currentImage, for: .normal)
        
        let imageWidth = imageV.frame.size.width
        let imageHeight = imageV.frame.size.height
        
        guard
        let labelWidth = titleL.text?.size(withAttributes: [NSAttributedString.Key.font : titleL.font as UIFont]).width,
        let labelHeight = titleL.text?.size(withAttributes: [NSAttributedString.Key.font : titleL.font as UIFont]).height
        else {
            return
        }
        
        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2//image中心移动的x距离
        let imageOffsetY = imageHeight / 2 + space / 2//image中心移动的y距离
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2//label中心移动的x距离
        let labelOffsetY = labelHeight / 2 + space / 2//label中心移动的y距离
        
        let tempWidth = max(labelWidth, imageWidth)
        let changedWidth = labelWidth + imageWidth - tempWidth
        let tempHeight = max(labelHeight, imageHeight);
        let changedHeight = labelHeight + imageHeight + space - tempHeight

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
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + 0.5 * space, bottom: 0, right: -(labelWidth + 0.5 * space))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + 0.5 * space), bottom: 0, right: imageWidth + space * 0.5)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0.5*space)
            
        default:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -0.5 * space, bottom: 0, right: 0.5 * space)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: -0.5 * space)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * space, bottom: 0, right: 0.5 * space)
        }
    }
    
    func layoutButton(_ postion: ImagePosition, margin: CGFloat) {
        
        guard
        let imageWidth = imageView?.image?.size.width,
            let labelWidth = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font : titleLabel?.font ?? UIFont.systemFont(ofSize: 13)]).width
        else {
            return
        }
        let space = bounds.size.width - imageWidth - labelWidth - 2 * margin
        layoutButton(postion, space: space)
    }
}
