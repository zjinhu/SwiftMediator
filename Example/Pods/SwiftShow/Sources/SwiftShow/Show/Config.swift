//
//  Config.swift
//  SwiftShow
//
//  Created by iOS on 2020/4/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

public enum MaskType {
    case color
    case effect
}

public enum ToastOffset {
    case top
    case center
    case bottom
}

public enum ImageLayoutType {
    ///按钮图片居左 文案居右
    case left
    ///按钮图片居上 文案居下
    case top
}

public enum PopViewShowType {
    case top
    case left
    case bottom
    case right
    case center
}
//MARK: -- Toast
public class ShowToastConfig {
    ///执行动画时间 默认0.5
    public var animateDuration = 0.5
    ///Toast默认停留时间 默认2秒
    public var showTime : Double = 3.0
    
    
    ///Toast最大宽度  默认200
    public var maxWidth : Float = 200
    ///Toast最大高度 默认500
    public var maxHeight : Float = 500
    ///Toast圆角 默认5
    public var cornerRadius : CGFloat = 5

    
    ///Toast背景颜色 默认黑色
    public var bgColor : UIColor = .blackBGColor
    ///阴影颜色 默认clearcolor
    public var shadowColor : CGColor = UIColor.clear.cgColor
    ///阴影Opacity 默认0.5
    public var shadowOpacity : Float = 0.5
    ///阴影Radius 默认5
    public var shadowRadius : CGFloat = 5


    ///Toast图文混排样式 默认图片在左
    public var imageType : ImageLayoutType = .left
    ///Toast背景与内容之间的内边距 默认10
    public var padding : Float = 10
    ///Toast 在屏幕的位置（左右居中调节上下）默认100
    public var offSet : Float = 100
    ///Toast 在屏幕的位置 默认中间
    public var offSetType : ToastOffset = .center
    
    
    /// Toast title文字字体颜色 默认白色
    public var titleColor : UIColor = .white
    ///Toast title字体  默认15
    public var titleFont : UIFont = UIFont.systemFont(ofSize: 15)
    /// Toast subTitle文字字体颜色 默认白色
    public var subTitleColor : UIColor = .lightGray
    ///Toast subTitle字体  默认15
    public var subTitleFont : UIFont = UIFont.systemFont(ofSize: 12)
    
    ///Toast图文间距  默认0
    public var spaceImage : CGFloat = 5
    ///Toast 文本间距  默认0
    public var spaceText : CGFloat = 5
}

//MARK: --Loading
public class ShowLoadingConfig {
    ///loading最大宽度 默认130
    public var maxWidth : Float = 200
    ///loading最大高度 默认130
    public var maxHeight : Float = 200
    ///圆角大小 默认5
    public var cornerRadius : CGFloat = 5
    

    ///文字字体大小 默认系统字体15
    public var titleFont : UIFont = UIFont.systemFont(ofSize: 15)
    ///文字字体颜色 默认白色
    public var titleColor : UIColor = .white
    ///文字字体大小 默认系统字体15
    public var subTitleFont : UIFont = UIFont.systemFont(ofSize: 12)
    ///文字字体颜色 默认白色
    public var subTitleColor : UIColor = .lightGray
    
    
    /// 是否背景透传点击 默认false
    public var enableEvent: Bool = false
    ///背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    ///加载框主体颜色 默认黑色
    public var tintColor : UIColor = .blackBGColor
    ///背景颜色 默认clear
    public var bgColor : UIColor = .clear
    ///默认蒙版类型 背景色
    public var maskType : MaskType = .color
    ///阴影颜色 默认clearcolor
    public var shadowColor : CGColor = UIColor.clear.cgColor
    ///阴影Opacity 默认0.5
    public var shadowOpacity : Float = 0.5
    ///阴影Radius 默认5
    public var shadowRadius : CGFloat = 5
    
    
    ///图片动画类型 所需要的图片数组
    public var imagesArray : [UIImage]?
    ///菊花颜色 不传递图片数组的时候默认使用菊花
    public var activityColor : UIColor = .white
    ///图片动画时间 默认1.0
    public var animationTime : Double = 1.0
    ///loading图文混排样式  默认图片在上
    public var imageType : ImageLayoutType = .top
    
    
    ///loading背景与内容之间的上下边距 默认20
    public var verticalPadding : Float = 20
    ///loading背景与内容之间的左右边距 默认20
    public var horizontalPadding : Float = 20
    
    ///loading文字与图片之间的距 默认0
    public var spaceImage : CGFloat = 5
    ///loading 文本间距  默认0
    public var spaceText : CGFloat = 5
}
    
//MARK: --Alert
public class ShowAlertConfig {
    ///执行动画时间
    public var animateDuration = 0.5
    ///背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light

    ///alert宽度
    public var width : Float = 280
    ///alert最大高度
    public var maxHeight : Float = 500
    ///alert按钮高度
    public var buttonHeight : Float = 50
    ///alert圆角
    public var cornerRadius : CGFloat = 5
    ///alert图文间距
    public var space : Float = 5
    
    ///alert主体颜色 默认
    public var tintColor : UIColor = .whiteBGColor
    ///alert背景颜色
    public var bgColor : UIColor = UIColor.black.withAlphaComponent(0.5)
    ///alert分割线颜色
    public var lineColor : UIColor = .lightGray
    ///默认蒙版类型
    public var maskType : MaskType = .color
    ///阴影
    public var shadowColor : CGColor = UIColor.clear.cgColor
    public var shadowOpacity : Float = 0.5
    public var shadowRadius : CGFloat = 5
    
    ///alert标题字体
    public var titleFont : UIFont = UIFont.systemFont(ofSize: 21)
    /// alert标题字体颜色
    public var titleColor : UIColor = .textColor
    ///alert信息字体
    public var textFont : UIFont = UIFont.systemFont(ofSize: 14)
    /// alert信息字体颜色
    public var textColor : UIColor = .textColor
    ///alert按钮字体
    public var buttonFont : UIFont = UIFont.systemFont(ofSize: 15)
    /// alert按钮字体颜色
    public var leftColor : UIColor = .textColor
    public var rightColor : UIColor = .textColor

    ///alert背景与内容之间的上下边距 默认10
    public var verticalPadding : Float = 10
    ///alert背景与内容之间的左右边距 默认10
    public var horizontalPadding : Float = 10
}

//MARK: --pop
public class ShowPopViewConfig {
    ///背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    ///点击其他地方是否消失 默认yes
    public var clickOutHidden = true
    ///默认蒙版类型
    public var maskType : MaskType = .color
    ///背景颜色 默认蒙版
    public var bgColor : UIColor = UIColor.black.withAlphaComponent(0.3)
    ///执行动画时间
    public var animateDuration = 0.3
    ///动画是否弹性
    public var animateDamping = true
    ///动画是否弹性
    public var isAnimate = true
    /// 弹出视图样式位置
    public var showAnimateType : PopViewShowType? = .center
}

//MARK: --pop
public class ShowDropDownConfig {
    ///背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    ///点击其他地方是否消失 默认yes
    public var clickOutHidden = true
    ///默认蒙版类型
    public var maskType : MaskType = .color
    ///背景颜色 默认蒙版
    public var bgColor : UIColor = UIColor.black.withAlphaComponent(0.3)
    ///执行动画时间
    public var animateDuration = 0.3
    ///动画是否弹性
    public var animateDamping = true
    ///动画是否弹性
    public var isAnimate = true
    /// 弹出视图位置
    public var fromY : CGFloat = 88
}

extension UIColor {
    
    @available(iOS 13.0, *)
    static let blackChangeColor = UIColor { (trainCollection) -> UIColor in
        if trainCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.110, green: 0.110, blue: 0.110, alpha: 1.0)
        } else {
            return UIColor.black
        }
    }

    @available(iOS 13.0, *)
    static let whiteChangeColor = UIColor { (trainCollection) -> UIColor in
        if trainCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.110, green: 0.110, blue: 0.110, alpha: 1.0)
        } else {
            return UIColor.white
        }
    }

    @available(iOS 13.0, *)
    static let textChangeColor = UIColor { (trainCollection) -> UIColor in
        if trainCollection.userInterfaceStyle == .dark {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    static var blackBGColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.blackChangeColor
        }else{
            return UIColor.black
        }
    }
    
    static var whiteBGColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.whiteChangeColor
        }else{
            return UIColor.white
        }
    }
    
    static var textColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.textChangeColor
        }else{
            return UIColor.black
        }
    }
}
