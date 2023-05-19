

![](Image/logo.png)


[![Version](https://img.shields.io/cocoapods/v/SwiftBrick.svg?style=flat)](http://cocoapods.org/pods/SwiftBrick)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg)
![iOS 13.0+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)

SwiftBrick是一个简单易用、功能丰富的UI搭建框架，主要目的是为了加速APP开发 。

内含部分颜色资源（都支持暗黑模式）。

## 功能

- [x] VC基类、协议--继承后即可使用，包括处理导航栏左右按钮，TableView、CollectionView、WKWebview等VC封装

- [x] Cell基类、协议-- TableView、CollectionView的Cell以及Header/Footer注册，复用

- [x] UINavigationBar背景色修改，分割线隐藏

- [x] UINavigationController出入栈导航栏隐藏展示的平滑切换

- [x] UIStatusBar样式以及展示隐藏

- [x] View渐变色背景

- [x] UITableViewCell各种样式分割线

- [x] UIButton扩展图文

- [x] 各种View的扩展工厂

- [x] UIColor扩展

- [x] UserDefault、UserDefaultSuite属性包裹器

- [x] iOS系统版本对比判断

- [x] 震动反馈工具

- [x] 各种Swift宏定义

  

## 安装

### cocoapods

几个Group可单独引用也可全体引入
比如 `pod ‘SwiftBrick/ViewFactory’`

1.在 Podfile 中添加 `pod ‘SwiftBrick’`

2.执行 `pod install 或 pod update`

3.导入 `import SwiftBrick`

### Swift Package Manager

从 Xcode 11 开始，集成了 Swift Package Manager，使用起来非常方便。SwiftBrick 也支持通过 Swift Package Manager 集成。

在 Xcode 的菜单栏中选择 `File > Swift Packages > Add Pacakage Dependency`，然后在搜索栏输入

`https://github.com/jackiehu/SwiftBrick`，即可完成集成

### 手动集成

SwiftBrick 也支持手动集成，只需把Sources文件夹中的SwiftBrick文件夹拖进需要集成的项目即可



## 文件目录
### ViewFactory：UI控件工厂

  基于SnapKit封装常用UI控件，一个函数创建UI控件，比如UILabel
```swift
    /// 快速初始化UILabel 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - font: 字体 有默认参数
    ///   - lines: 行数 有默认参数
    ///   - text: 内容 有默认参数
    ///   - textColor: 字体颜色 有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - textAlignment: textAlignment 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func snpLabel(supView: UIView? = nil,
                        backColor: UIColor? = .clear,
                        font: UIFont = UIFont.systemFont(ofSize: 14),
                        lines: Int = 0,
                        text: String = "",
                        textColor: UIColor = .black,
                        textAlignment: NSTextAlignment = .left,
                        snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UILabel 
```

可以根据参数需要更改的做保留，不需要更改的直接使用默认参数，例子：
```swift
UILabel.snpLabel(text: “我是Label”, textColor: .red, supView: self.view, snapKitMaker: { (make) in
     make.center.equalToSuperview()
})
```

对常用的UI控件都做了SnapKit封装、扩展，方便实用，且添加了点击手势闭包以及UIButton点击闭包。

- [x] UITableView

- [x] UILabel

- [x] UITextField

- [x] UIStackView

- [x] UIImageView

- [x] UIImageView

- [x] UICollectionView

- [x] UIView

- [x] UIButton

- [x] UILineView   --画线View，实线、虚线

- [x] ShadowsButton  --圆角、阴影 按钮

- [x] ArrayViewSnapEx  --对数组集合内的View进行排版布局（比如九宫格等等）

- [x] InsetLabel  --支持内边距的UILabel子类

  

### Extensions：常用的扩展

* UIGestureRecognizer        — 添加闭包回调handleAction

* UINavigationBar        —方便修改导航栏背景色以及隐藏分割线

* CALayer        —添加阴影的扩展方法，方便一行代码添加阴影，扩展边框圆角方法

* UIColor         —扩展UIColor，方便字符串类型的色值设置

* UINavigationController        —对Nav做扩展，给VC添加属性，方便设置隐藏导航栏。

  解决多级页面导航栏隐藏显示过程中的动画问题，
  仅需要在VC的viewDidLoad中设置 `self.prefersNavigationBarHidden = true/false`来控制当前页面的导航栏是否隐藏（添加SwizzleNavBar.inits进行方法交换）详细请参考DEMO

* StatusBaEx         --添加状态栏控制工具，添加UIViewController专属参数控制状态栏样式以及显示隐藏，不局限于VC，可在任意位置控制，只要递归到最上层VC即可（参考：https://github.com/jackiehu/SwiftMediator）

* UITableViewCell        -- 分割线快速添加

* UIButton         -- 图文混排按钮扩展



### BaseVC：VC基类

  针对几个常用的VC做了父类化封装。方便开发过程中的VC创建，只需要继承相关父类，调用相关方法执行相应的代理即可
* JHViewController   --继承后方便设置导航栏左右按钮以及可选某些页面关闭滑动返回，统一返回方法

* JHTableViewController  --继承后方便创建列表VC针对数据源做了处理，子类只需要设置mainDatas，代理方法不需要关心个数等等

* JHCollectionViewController  --同上

* JHWebViewController --方便创建WKWebView视图VC，可选择更改UA、注入Cookie等，退出清理缓存
  详细用法参见DEMO

  
### BaseCell：Cell基类

* 泛型封装Table、Collection的Cell以及HeaderView，方便快速注册，复用，传递Model，只需要继承后在setupCellViews()里做相关布局UI即可。



### Util：常量，工具

* Version --iOS系统版本对比工具
* Define --各种Swift常用的宏定义
* AppState --当前APP版本判断
* UserDefault --UserDefault属性包裹器
* TapBuzz --震动反馈
* Then --属性初始化闭包（类似Lazy闭包）
* Loader --用于加载本框架内的资源文件，支持SPM

具体使用代码api详细参见Demo



## 更多砖块工具加速APP开发

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMediator&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftShow&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftShow)

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

