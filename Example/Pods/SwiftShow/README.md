

![](Image/logo.png)

[![Version](https://img.shields.io/cocoapods/v/SwiftShow.svg?style=flat)](http://cocoapods.org/pods/SwiftShow)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg)
![iOS 11.0+](https://img.shields.io/badge/iOS-11.0%2B-blue.svg)
![Swift 4.2+](https://img.shields.io/badge/Swift-4.2%2B-orange.svg)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)](https://developer.apple.com/swift/)

各种弹出窗口，主要包含Toast，Loading，Alert等HUD，以及各个方向的弹出式窗口。

用法详见demo。

## 安装

### cocoapods

1.在 Podfile 中添加 `pod ‘SwiftShow’`

2.执行 `pod install 或 pod update`

3.导入 `import SwiftShow`

### Swift Package Manager

从 Xcode 11 开始，集成了 Swift Package Manager，使用起来非常方便。SwiftShow 也支持通过 Swift Package Manager 集成。

在 Xcode 的菜单栏中选择 `File > Swift Packages > Add Pacakage Dependency`，然后在搜索栏输入

`https://github.com/jackiehu/SwiftShow`，即可完成集成

### 手动集成

SwiftShow 也支持手动集成，只需把Sources文件夹中的SwiftShow文件夹拖进需要集成的项目即可



### 使用

基本弹窗API全部都在Show.swift，其中包括多个种类

1. Toast

   ```
   
   ```

   |                       |                       |                       |
   | --------------------- | --------------------- | --------------------- |
   | ![](Image/toast1.png) | ![](Image/toast2.png) | ![](Image/toast3.png) |
   | ![](Image/toast4.png) | ![](Image/toast5.png) |                       |

   ```swift
   ///Toast适配器，主要处理Toast样式
   public class ShowToastConfig {
       ///执行动画时间 默认0.5
       public var animateDuration = 0.5
       ///Toast最大宽度  默认200
       public var maxWidth : Float = 200
       ///Toast最大高度 默认500
       public var maxHeight : Float = 500
       ///Toast默认停留时间 默认2秒
       public var showTime : Double = 2.0
       ///Toast圆角 默认5
       public var cornerRadius : CGFloat = 5
       ///Toast图文间距  默认0
       public var space : Float = 0
       ///Toast字体  默认15
       public var textFont : UIFont = UIFont.systemFont(ofSize: 15)
       ///Toast背景颜色 默认黑色
       public var bgColor : UIColor = UIColor.blackBGColor
       ///阴影颜色 默认clearcolor
       public var shadowColor : CGColor = UIColor.clear.cgColor
       ///阴影Opacity 默认0.5
       public var shadowOpacity : Float = 0.5
       ///阴影Radius 默认5
       public var shadowRadius : CGFloat = 5
       /// Toast文字字体颜色 默认白色
       public var textColor : UIColor = .white
       ///Toast图文混排样式 默认图片在左
       public var imageType : ImageButtonType = .imageButtonTypeLeft
       ///Toast背景与内容之间的内边距 默认10
       public var padding : Float = 10
       ///Toast 在屏幕的位置（左右居中调节上下）默认100
       public var offSet : Float = 100
       ///Toast 在屏幕的位置 默认中间
       public var offSetType : ToastOffset = .center
   }
   ```

   

   ```swift
       /// 展示toast
       /// - Parameters:
       ///   - text: 文本
       ///   - image: 图片 （可选参数）
       ///   - config: toast适配器，不传为默认样式
       public class func showToast(_ text: String, image: UIImage? = nil, config : ConfigToast? = nil)
   ```

2. Loading

   | ![](Image/Loading1.png) | ![](Image/Loading2.png) | ![](Image/Loading3.png) |
   | ----------------------- | ----------------------- | ----------------------- |
   | 默认样式                | 可图文                  | 可添加阴影，遮罩        |

   ```swift
   ///Loading适配器
   public class ShowLoadingConfig {
       /// 是否背景透传点击 默认false
       public var enableEvent: Bool = false
       ///背景蒙版 毛玻璃
       public var effectStyle = UIBlurEffect.Style.light
       ///loading最大宽度 默认130
       public var maxWidth : Float = 130
       ///loading最大高度 默认130
       public var maxHeight : Float = 130
       ///圆角大小 默认5
       public var cornerRadius : CGFloat = 5
       ///加载框主体颜色 默认黑色
       public var tintColor : UIColor = UIColor.blackBGColor
       ///文字字体大小 默认系统字体15
       public var textFont : UIFont = UIFont.systemFont(ofSize: 15)
       ///文字字体颜色 默认白色
       public var textColor : UIColor = .white
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
       public var imageType : ImageButtonType = .imageButtonTypeTop
       ///loading背景与内容之间的上下边距 默认20
       public var verticalPadding : Float = 20
       ///loading背景与内容之间的左右边距 默认20
       public var horizontalPadding : Float = 20
       ///loading文字与图片之间的距 默认0
       public var space : Float = 0
   }
   ```

   ```swift
       /// 在当前VC中展示loading
       /// - Parameters:
       ///   - text: 文本
       ///   - config: loading适配器
       public class func showLoading(_ text : String? = nil, config : ConfigLoading? = nil) 
       
       /// 隐藏上层VC中的loading
       public class func hiddenLoading() 
       
       /// 在window中展示loading
       /// - Parameters:
       ///   - text: 文本
       ///   - config: 配置
       public class func showLoadingOnWindow(_ text : String? = nil, config : ConfigLoading? = nil)
       
       /// 隐藏window中loading
       public class func hiddenLoadingOnWindow() 
       
       /// 在指定view中添加loading
       /// - Parameters:
       ///   - onView: view
       ///   - text: 文本
       ///   - config: 配置
       public class func showLoadingOnView(_ onView: UIView, text : String? = nil, config : ConfigLoading? = nil)
       
       /// 隐藏指定view中loading
       /// - Parameter onView: view
       public class func hiddenLoadingOnView(_ onView: UIView)
   ```

3. Alert

   | ![](Image/Alert1.png) | ![](Image/Alert2.png) | ![](Image/Alert3.png) |
   | --------------------- | --------------------- | --------------------- |
   | 默认弹窗              | 可修改弹窗遮罩、阴影  | 可使用富文本          |

   ```swift
   ///Alert适配器
   public class ShowAlertConfig {
       ///背景蒙版 毛玻璃
       public var effectStyle = UIBlurEffect.Style.light
       ///执行动画时间
       public var animateDuration = 0.5
       ///alert宽度
       public var width : Float = 280
       ///alert最大高度
       public var maxHeight : Float = 500
       ///alert按钮高度
       public var buttonHeight : Float = 50
       ///alert圆角
       public var cornerRadius : CGFloat = 5
       ///alert图文混排样式
       public var imageType : ImageButtonType = .imageButtonTypeTop
       ///alert图文间距
       public var space : Float = 0
       ///alert标题字体
       public var titleFont : UIFont = UIFont.systemFont(ofSize: 21)
       /// alert标题字体颜色
       public var titleColor : UIColor = UIColor.textColor
       ///alert信息字体
       public var textFont : UIFont = UIFont.systemFont(ofSize: 14)
       /// alert信息字体颜色
       public var textColor : UIColor = UIColor.textColor
       ///alert按钮字体
       public var buttonFont : UIFont = UIFont.systemFont(ofSize: 15)
       /// alert按钮字体颜色
       public var leftColor : UIColor = UIColor.textColor
       public var rightColor : UIColor = UIColor.textColor
       ///alert主体颜色 默认
       public var tintColor : UIColor = UIColor.whiteBGColor
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
   }
   ```

   ```swift
       /// 默认样式Alert
       /// - Parameters:
       ///   - title: 标题
       ///   - message: 信息
       ///   - leftBtnTitle: 左侧按钮标题
       ///   - rightBtnTitle: 右侧按钮标题
       ///   - leftBlock: 左侧按钮回调
       ///   - rightBlock: 右侧按钮回调
       public class func showAlert(title: String? = nil,
                                   message: String?  = nil,
                                   leftBtnTitle: String? = nil,
                                   rightBtnTitle: String? = nil,
                                   leftBlock: LeftCallBack? = nil,
                                   rightBlock: RightCallback? = nil) 
                                   
       /// 富文本样式Alert
       /// - Parameters:
       ///   - attributedTitle: 富文本标题
       ///   - attributedMessage: 富文本信息
       ///   - leftBtnAttributedTitle: 富文本左侧按钮标题
       ///   - rightBtnAttributedTitle: 富文本右侧按钮标题
       ///   - leftBlock: 左侧按钮回调
       ///   - rightBlock: 右侧按钮回调
       public class func showAttributedAlert(attributedTitle : NSAttributedString? = nil,
                                             attributedMessage : NSAttributedString? = nil,
                                             leftBtnAttributedTitle: NSAttributedString? = nil,
                                             rightBtnAttributedTitle: NSAttributedString? = nil,
                                             leftBlock: LeftCallBack? = nil,
                                             rightBlock: RightCallback? = nil)
                                             
                                                 /// 自定义Alert
       /// - Parameters:
       ///   - title: 标题
       ///   - attributedTitle: 富文本标题
       ///   - titleImage: 顶图
       ///   - message: 信息
       ///   - attributedMessage: 富文本信息
       ///   - leftBtnTitle: 左侧按钮标题
       ///   - leftBtnAttributedTitle: 富文本左侧按钮标题
       ///   - rightBtnTitle: 右侧按钮标题
       ///   - rightBtnAttributedTitle: 富文本右侧按钮标题
       ///   - leftBlock:  左侧按钮回调
       ///   - rightBlock: 右侧按钮回调
       ///   - config: Alert适配器，不传为默认样式
       public class func showCustomAlert(title: String? = nil,
                                         attributedTitle : NSAttributedString? = nil,
                                         titleImage: UIImage? = nil,
                                         message: String?  = nil,
                                         attributedMessage : NSAttributedString? = nil,
                                         leftBtnTitle: String? = nil,
                                         leftBtnAttributedTitle: NSAttributedString? = nil,
                                         rightBtnTitle: String? = nil,
                                         rightBtnAttributedTitle: NSAttributedString? = nil,
                                         leftBlock: LeftCallBack? = nil,
                                         rightBlock: RightCallback? = nil,
                                         config : ConfigAlert? = nil)
   ```

4. pop

   | ![](Image/Pop1.gif) | ![](Image/Pop2.gif) |
   | ------------------- | ------------------- |
   |                     |                     |

   ```swift
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
   ```

   ```swift
       /// 弹出view
       /// - Parameters:
       ///   - contentView: 被弹出的View
       ///   - config: popview适配器
       ///   - showClosure: 弹出回调
       ///   - hideClosure: 收起回调
       public class func showPopView(contentView: UIView,
                                     config : ConfigPop? = nil,
                                     showClosure: CallBack? = nil,
                                     hideClosure: CallBack? = nil)
                                     
       /// 收起popview
       /// - Parameter complete: 完成回调
       public class func hidenPopView(_ complete : (() -> Void)? = nil )
   ```

5. DropDown

   ![](Image/DropDown.gif)

   ```swift
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
   ```

   ```swift
       /// 从NavBar或VC的view中弹出下拉视图,可以盖住Tabbar，但不遮挡NavBar
       /// - Parameters:
       ///   - contentView: 被弹出的view
       ///   - config: 适配器回调
       ///   - showClosure: 展示回调
       ///   - hideClosure: 隐藏回调
       ///   - willShowClosure: 即将展示回调
       ///   - willHideClosure: 即将收起回调
       public class func showCoverTabbarView(contentView: UIView,
                                             config: ((_ config : ShowDropDownConfig) -> Void)? = nil,
                                             showClosure: CallBack? = nil,
                                             hideClosure: CallBack? = nil,
                                             willShowClosure: CallBack? = nil,
                                             willHideClosure: CallBack? = nil) 
                                             
       /// 当前是否正在展示DropDown
       /// - Returns: true/false
       public class func isHaveCoverTabbarView() -> Bool
       
       /// 手动隐藏DropDown
       /// - Parameter complete: 完成回调
       public class func hidenCoverTabbarView(_ complete : (() -> Void)? = nil )
   ```

6. 通用工具

   ```swift
   		/// 获取顶层VC
       public class func currentViewController() -> UIViewController?
   ```

## 更多砖块工具加速APP开发

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftBrick&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftBrick)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMediator&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftLog&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftLog)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftyForm&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftyForm)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftEmptyData&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftEmptyData)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftPageView&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftPageView)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=JHTabBarController&theme=radical&locale=cn)](https://github.com/jackiehu/JHTabBarController)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMesh&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNotification&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNotification)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNetSwitch&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNetSwitch)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftButton&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftButton)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftDatePicker&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftDatePicker)
