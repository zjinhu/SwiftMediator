

![](Image/logo.png)


[![Version](https://img.shields.io/cocoapods/v/SwiftMediator.svg?style=flat)](http://cocoapods.org/pods/SwiftMediator)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg)
![iOS 11.0+](https://img.shields.io/badge/iOS-11.0%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)

Swift 路由和模块通信解耦工具。

采用 target-action 方案的组件化路由中间件。

支持使用字符串类名反射创建对象，通过传递字典参数利用 Mirror 反射属性并赋值，实现通过字符串方式解耦，支持页面跳转和函数方法执行调用。

支持 OpenURL 方式跳转页面并传递参数。

可实现模块间无耦合地调用服务、页面跳转。无需注册，不需要协议，只需知道目标 VC 的类名和模块名称。

AppDelegate、SceneDelegate 解耦工具，只需在主工程留下钩子即可，用法详见 Demo。

| ![](Image/1.png) | ![](Image/2.png) |
| ---------------- | ---------------- |
|                  |                  |



## 安装

### CocoaPods

1. 在 Podfile 中添加 `pod 'SwiftMediator'`

2. 执行 `pod install` 或 `pod update`

3. 导入 `import SwiftMediator`

### Swift Package Manager

从 Xcode 11 开始，集成了 Swift Package Manager，使用起来非常方便。SwiftMediator 也支持通过 Swift Package Manager 集成。

在 Xcode 的菜单栏中选择 `File > Swift Packages > Add Package Dependency`，然后在搜索栏输入

`https://github.com/zjinhu/SwiftMediator`，即可完成集成

### 手动集成

SwiftMediator 也支持手动集成，只需把 Sources 文件夹中的 SwiftMediator 文件夹拖进需要集成的项目即可



## 使用

### 原生 Push / Present
```swift
// 模态弹出页面
SwiftMediator.shared.present("TestVC", moduleName: "SwiftMediator", paramsDic: ["str":"123123", "titleName":"23452345", "num":13, "dic":["a":12, "b":"100"]])

// Push 页面
SwiftMediator.shared.push("TestVC", moduleName: "SwiftMediator", paramsDic: ["str":"123123", "titleName":"23452345", "num":13, "dic":["a":12, "b":"100"]])
```

### URL 路由跳转
```swift
SwiftMediator.shared.openUrl("app://push/SwiftMediator/TestVC?str=123&titleName=456&num=111")
```

### SwiftUI 导航
```swift
// Push SwiftUI 视图
SwiftMediator.shared.push(MySwiftUIView(), title: "我的页面")
```



## API 参考

### URL 路由跳转

URL 路由跳转自动区分 Push、Present、全屏模态，根据拆分 URL 的 scheme、host、path、query 获取参数。

* **scheme**：APP 标记 scheme，区分 APP 跳转，APP 内使用可传任意值

* **host**：可传递 `push`、`present`、`fullScreen` 用于区分跳转样式

* **path**：`/modulename/vcname`，用于获取组件名和 VC 名

* **query**：采用 `key=value&key=value` 方式拼接，可自动转换成字典

```swift
/// URL 路由跳转，自动区分 Push、Present、全屏模态
/// - Parameter urlString: URL 格式: scheme://push|present|fullScreen/moduleName/vcName?queryParams
public func openUrl(_ urlString: String?)
```

### Push 导航
```swift
/// 通过类名 Push（自动实例化 VC）
/// - Parameters:
///   - vcName: 目标 VC 类名
///   - moduleName: 组件 Bundle 名称（不传则使用默认主 Bundle）
///   - fromVC: 起始页面 VC（不传则默认取最顶层 VC）
///   - paramsDic: 参数字典，通过 KVC 赋值
///   - animated: 是否有动画
public func push(_ vcName: String,
                 moduleName: String? = nil,
                 fromVC: UIViewController? = nil,
                 paramsDic: [String: Any]? = nil,
                 animated: Bool = true)

/// 使用已初始化的 VC 进行 Push
/// - Parameters:
///   - vc: 已初始化好的 VC 对象
///   - fromVC: 起始页面 VC（不传则路由选择最顶层 VC）
///   - animated: 是否有动画
public func push(_ vc: UIViewController?,
                 fromVC: UIViewController? = nil,
                 animated: Bool = true)
```

### Pop 导航
```swift
/// 返回上一页
public func pop(animated: Bool = true)

/// 返回根页面
public func popToRoot(animated: Bool = true)

/// 跳转到指定页面
public func popTo(_ vc: UIViewController) -> Bool

/// 跳转到指定索引页面
public func popTo(_ index: Int) -> Bool

/// 跳转到指定标题页面
public func popTo(_ navigationBarTitle: String) -> Bool
```

### 模态弹出
```swift
/// 通过类名弹出（自动实例化 VC）
/// - Parameters:
///   - vcName: 目标 VC 类名
///   - moduleName: 组件 Bundle 名称（不传则使用默认主 Bundle）
///   - paramsDic: 参数字典，通过 KVC 赋值
///   - fromVC: 起始页面 VC（不传则默认取最顶层 VC）
///   - needNav: 是否需要导航栏
///   - modelStyle: 模态样式
///   - animated: 是否有动画
public func present(_ vcName: String,
                    moduleName: String? = nil,
                    paramsDic: [String: Any]? = nil,
                    fromVC: UIViewController? = nil,
                    needNav: Bool = false,
                    modelStyle: UIModalPresentationStyle = .fullScreen,
                    animated: Bool = true)

/// 使用已初始化的 VC 进行弹出
public func present(_ vc: UIViewController?,
                    fromVC: UIViewController? = nil,
                    needNav: Bool = false,
                    modelStyle: UIModalPresentationStyle = .fullScreen,
                    animated: Bool = true)

/// 退出当前页面（自动判断 pop 或 dismiss）
public func dismissVC(animated: Bool = true)
```

### 获取最顶层 VC
```swift
/// 获取当前顶层的 UINavigationController
public static func currentNavigationController() -> UINavigationController?

/// 获取当前顶层的 UIViewController
public static func currentViewController() -> UIViewController?
```

### 对象初始化
```swift
/// 反射初始化 UIViewController 并赋值
/// - Parameters:
///   - vcName: VC 类名
///   - moduleName: 组件 Bundle 名称（不传则为默认命名空间）
///   - dic: 参数字典（由于是 KVC 赋值，属性必须标记 @objc）
/// - Returns: 初始化后的 VC，失败时返回 nil
@discardableResult
public func initVC(_ vcName: String,
                   moduleName: String? = nil,
                   dic: [String: Any]? = nil) -> UIViewController?

/// 反射初始化 UIView 并赋值
@discardableResult
public func initView(_ viewName: String,
                     moduleName: String? = nil,
                     dic: [String: Any]? = nil) -> UIView?

/// 反射初始化 NSObject 子类并赋值
@discardableResult
public func initObjc(_ objcName: String,
                     moduleName: String? = nil,
                     dic: [String: Any]? = nil) -> NSObject?
```

### 方法调用
```swift
/// 路由调用实例对象方法
/// - 注意: 方法必须标记 @objc，例如: @objc func myMethod(_ param: Any)
/// - Parameters:
///   - objc: 已初始化好的对象
///   - selName: 方法名
///   - param: 参数 1
///   - otherParam: 参数 2
/// - Returns: 方法执行结果，方法不存在时返回 nil
@discardableResult
public func callObjcMethod(objc: AnyObject,
                           selName: String,
                           param: Any? = nil,
                           otherParam: Any? = nil) -> Unmanaged<AnyObject>?

/// 路由调用类方法
/// - 注意: 方法必须标记 @objc，例如: @objc class func myMethod(_ param: Any)
/// - Parameters:
///   - className: 类名
///   - selName: 方法名
///   - moduleName: 组件名称
///   - param: 参数 1
///   - otherParam: 参数 2
/// - Returns: 方法执行结果，类或方法不存在时返回 nil
@discardableResult
public func callClassMethod(className: String,
                            selName: String,
                            moduleName: String? = nil,
                            param: Any? = nil,
                            otherParam: Any? = nil) -> Unmanaged<AnyObject>?
```

### SwiftUI 集成
```swift
/// Push SwiftUI View 到导航栈
/// - Parameters:
///   - view: SwiftUI 视图
///   - title: 导航栏标题
public func push<V: View>(_ view: V, title: String? = nil)

/// 跳转到指定标题页面
public func popToTitle(_ navigationBarTitle: String) -> Bool

/// 将 SwiftUI View 转换为 UIViewController（View 扩展）
public func getVC() -> UIViewController
```

### URL 编解码工具
```swift
/// 将字符串编码为安全的 URL 格式
public func urlEncoded() -> String

/// 将 URL 编码的字符串解码回原始格式
public func urlDecoded() -> String
```

### 获取模块命名空间
```swift
/// 获取对象所在的模块命名空间
public func getModuleName() -> String
```



## AppDelegateMediator 解耦

用于 AppDelegate 解耦，可创建多个钩子分别用于各种第三方初始化。

用法：

```swift
/// 创建一个或多个钩子
class AppDe: AppDelegateMediator {
    var window: UIWindow?
    init(_ win: UIWindow?) {
        window = win
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        print("UIApplication 在这启动")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("UIApplication 在这将要进入后台")
    }
}
```

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// 在 AppDelegate 初始化管理器，并且传递钩子的数组
    lazy var manager: AppDelegateManager = {
        return AppDelegateManager(delegates: [AppDe(window)])
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// 把代理执行交给管理器
        manager.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        manager.applicationWillResignActive(application)
    }
}
```



## SceneDelegateMediator 解耦

用于 SceneDelegate 解耦，iOS 13 后可使用。可创建多个钩子分别用于各种第三方初始化。

用法：

```swift
@available(iOS 13.0, *)
/// 创建一个或多个钩子
class SceneDe: SceneDelegateMediator {
  
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("UIScene 在这启动")
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("UIScene 在这将要进入后台")
    }
}
```

```swift
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    /// 在 SceneDelegate 初始化管理器，并且传递钩子的数组
    lazy var manager: SceneDelegateManager = {
        return SceneDelegateManager(delegates: [SceneDe()])
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /// 把代理执行交给管理器
        manager.scene(scene, willConnectTo: session, options: connectionOptions)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        manager.sceneWillResignActive(scene)
    }
}
```



## AI Skills 使用指南

SwiftMediator 包含一个 `SKILLS.md` 文件，专为 AI 助手（如 Cursor、GitHub Copilot、Claude 等）设计，帮助它们快速理解并正确使用本框架。

### 什么是 SKILLS.md？

`SKILLS.md` 是一份完整的参考文档，包含：
- 完整的 API 文档和代码示例
- 架构概述和文件结构说明
- 常用模式和最佳实践
- 重要注意事项（如 KVC 需要 `@objc` 标记）
- 可直接复制的代码片段，供 AI 助手使用

### 如何在 AI 助手里使用

#### 方式一：在对话中引用

向 AI 助手提问 SwiftMediator 相关问题时，只需说明：

> "使用 SwiftMediator 框架，参考 SKILLS.md 获取 API 详情"

AI 会读取 `SKILLS.md` 并提供准确的代码建议。

#### 方式二：添加到 AI 上下文

对于 IDE 内置的 AI 助手（Cursor、Copilot Chat 等）：

1. **Cursor**: 在聊天中添加 `@SKILLS.md` 到上下文，或将其加入 `.cursor/rules/`
2. **GitHub Copilot**: 在提示词中引用该文件，或添加到工作区上下文
3. **Claude/ChatGPT**: 在会话开始时上传或粘贴 `SKILLS.md` 的内容

#### 方式三：项目级配置

Cursor 用户可创建 `.cursor/rules/swiftmediator.mdc`：

```markdown
---
description: SwiftMediator 路由与解耦框架
alwaysApply: false
---

使用 SwiftMediator 路由时：
- 参考 @SKILLS.md 获取完整 API 文档
- 注意：KVC 属性必须标记 @objc
- 注意：动态方法必须标记 @objc
- 所有路由操作使用 SwiftMediator.shared
```

### 快速示例

#### 让 AI 添加导航跳转

> "添加一个按钮，跳转到 ModuleB 的 DetailVC，传递 itemId 参数"

AI 会生成：
```swift
SwiftMediator.shared.push("DetailVC", moduleName: "ModuleB", paramsDic: ["itemId": "12345"])
```

#### 让 AI 配置 AppDelegate 钩子

> "使用 AppDelegateMediator 添加 Firebase 和 Analytics 初始化"

AI 会生成正确的钩子类和 AppDelegate 配置代码。

#### 让 AI 处理 DeepLink

> "使用 SwiftMediator URL 路由处理传入的 URL"

AI 会生成：
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    SwiftMediator.shared.openUrl(url.absoluteString)
    return true
}
```

---

## 更多砖块工具加速 APP 开发

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftBrick&theme=radical)](https://github.com/zjinhu/SwiftBrick)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftShow&theme=radical)](https://github.com/zjinhu/SwiftShow)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftLog&theme=radical)](https://github.com/zjinhu/SwiftLog)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=jackiehu&repo=SwiftyForm&theme=radical)](https://github.com/zjinhu/SwiftyForm)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftEmptyData&theme=radical)](https://github.com/zjinhu/SwiftEmptyData)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftPageView&theme=radical)](https://github.com/zjinhu/SwiftPageView)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=JHTabBarController&theme=radical)](https://github.com/zjinhu/JHTabBarController)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftMesh&theme=radical)](https://github.com/zjinhu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftNotification&theme=radical)](https://github.com/zjinhu/SwiftNotification)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftNetSwitch&theme=radical)](https://github.com/zjinhu/SwiftNetSwitch)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftButton&theme=radical)](https://github.com/zjinhu/SwiftButton)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftDatePicker&theme=radical)](https://github.com/zjinhu/SwiftDatePicker)
