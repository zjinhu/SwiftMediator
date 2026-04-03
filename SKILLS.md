# SwiftMediator AI Skills

> A comprehensive AI skill reference for the SwiftMediator iOS routing and module decoupling framework.
> This file is designed to help AI assistants quickly understand and correctly use SwiftMediator APIs.

---

## Overview

**SwiftMediator** is a Swift routing and module communication decoupling tool using the Target-Action pattern.

**Key Features:**
- String-based class name reflection for object creation
- Dictionary parameter passing via Mirror reflection and KVC
- URL-based routing (OpenURL) with automatic Push/Present detection
- Page navigation without inter-module coupling
- No registration or protocol agreements needed
- AppDelegate/SceneDelegate lifecycle decoupling

**Requirements:** iOS 11.0+, Swift 5.0+, Xcode 11.0+

---

## Core Architecture

```
SwiftMediator/
├── Target-Action/          # Core routing logic
│   ├── SwiftMediator.swift     # Singleton entry point
│   ├── Init++.swift            # Object reflection & initialization
│   ├── Method++.swift          # Dynamic method invocation
│   ├── Model++.swift           # Modal presentation (present/dismiss)
│   ├── Navigation++.swift      # Navigation operations (push/pop)
│   ├── Property++.swift        # Property inspection & KVC assignment
│   ├── SwiftUI++.swift         # SwiftUI View integration
│   └── URL++.swift             # URL routing & encoding
├── Delegate/               # Lifecycle decoupling
│   ├── AppDelegateMediator.swift   # AppDelegate proxy distribution
│   └── SceneDelegateMediator.swift # SceneDelegate proxy distribution (iOS 13+)
└── Tools/                  # Utilities
    ├── ViewController++.swift      # Top VC traversal
    └── Window++.swift              # KeyWindow & UIWindowScene access
```

---

## API Quick Reference

### Entry Point

```swift
// All routing operations go through the shared singleton
let mediator = SwiftMediator.shared
```

### Navigation - Push

```swift
// Push by class name (auto-instantiates VC, assigns params via KVC)
SwiftMediator.shared.push("TargetVC", moduleName: "MyModule", paramsDic: ["key": "value"])

// Push with source VC
SwiftMediator.shared.push("TargetVC", moduleName: "MyModule", fromVC: self, paramsDic: ["key": "value"])

// Push pre-initialized VC
let vc = TargetVC()
vc.someProperty = "value"
SwiftMediator.shared.push(vc, fromVC: self)
```

### Navigation - Pop

```swift
// Pop to previous page
SwiftMediator.shared.pop()

// Pop to root
SwiftMediator.shared.popToRoot()

// Pop to specific VC
SwiftMediator.shared.popTo(targetVC)

// Pop to index
SwiftMediator.shared.popTo(2)

// Pop to title
SwiftMediator.shared.popTo("Settings")
```

### Modal Presentation - Present

```swift
// Present by class name (auto-instantiates VC)
SwiftMediator.shared.present("TargetVC", moduleName: "MyModule", paramsDic: ["key": "value"])

// Present with navigation wrapper
SwiftMediator.shared.present("TargetVC", moduleName: "MyModule", needNav: true)

// Present with custom modal style
SwiftMediator.shared.present("TargetVC", moduleName: "MyModule", modelStyle: .pageSheet)

// Present pre-initialized VC
SwiftMediator.shared.present(vc, fromVC: self, needNav: true)
```

### Dismiss

```swift
// Dismiss current page (auto-detects pop vs dismiss)
SwiftMediator.shared.dismissVC()
```

### URL Routing

```swift
// URL format: scheme://host/moduleName/vcName?key=value&key2=value2
// host options: "push", "fullScreen", or any other (default modal)

// Push via URL
SwiftMediator.shared.openUrl("app://push/ModuleName/TargetVC?param1=value1&param2=value2")

// Present via URL
SwiftMediator.shared.openUrl("app://present/ModuleName/TargetVC?param1=value1")

// Fullscreen modal via URL
SwiftMediator.shared.openUrl("app://fullScreen/ModuleName/TargetVC?param1=value1")
```

### URL Encoding Utilities

```swift
let encoded = "hello world".urlEncoded()    // "hello%20world"
let decoded = "hello%20world".urlDecoded()  // "hello world"
```

### Object Initialization

```swift
// Initialize UIViewController via reflection
let vc = SwiftMediator.shared.initVC("TargetVC", moduleName: "MyModule", dic: ["title": "Hello"])

// Initialize NSObject subclass via reflection
let obj = SwiftMediator.shared.initObjc("MyManager", moduleName: "MyModule", dic: ["config": value])

// Initialize UIView via reflection
let view = SwiftMediator.shared.initView("CustomView", moduleName: "MyModule", dic: ["title": "Hello"])
```

### Method Invocation

```swift
// Call instance method (method MUST be marked @objc)
// @objc func myMethod(_ param: Any, _ other: Any)
let result = SwiftMediator.shared.callObjcMethod(objc: myObject, selName: "myMethod:", param: value1, otherParam: value2)

// Call class method (method MUST be marked @objc)
// @objc class func myClassMethod(_ param: Any, _ other: Any)
let result = SwiftMediator.shared.callClassMethod(className: "MyClass", selName: "myClassMethod:", moduleName: "MyModule", param: value1)
```

### SwiftUI Integration (iOS 13+)

```swift
// Push a SwiftUI View
SwiftMediator.shared.push(MySwiftUIView(), title: "My View")

// Pop to title (same as UIKit)
SwiftMediator.shared.popToTitle("Home")

// Convert any View to UIViewController
let hostingVC = myView.getVC()  // Returns UIHostingController
```

### Get Top View Controller

```swift
// Get current top UINavigationController
let nav = UIViewController.currentNavigationController()

// Get current top UIViewController (handles TabBar, Nav, Modal, SplitView)
let topVC = UIViewController.currentViewController()
```

### Get Module Namespace

```swift
// Get the module namespace where an object resides
let module = myObject.getModuleName()
```

---

## AppDelegateMediator Usage

### Step 1: Create Hook Classes

```swift
class AnalyticsHook: AppDelegateMediator {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize analytics SDK
        AnalyticsSDK.start()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AnalyticsSDK.trackAppOpened()
    }
}

class PushNotificationHook: AppDelegateMediator {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Send token to server
    }
}
```

### Step 2: Setup in AppDelegate

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var manager: AppDelegateManager = {
        AppDelegateManager(delegates: [
            AnalyticsHook(),
            PushNotificationHook(),
            // Add more hooks as needed
        ])
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        manager.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        manager.applicationDidBecomeActive(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        manager.applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        manager.applicationDidEnterBackground(application)
    }
}
```

---

## SceneDelegateMediator Usage (iOS 13+)

### Step 1: Create Hook Classes

```swift
@available(iOS 13.0, *)
class SceneAnalyticsHook: SceneDelegateMediator {
    func sceneDidBecomeActive(_ scene: UIScene) {
        AnalyticsSDK.trackSceneActivated()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        AnalyticsSDK.trackSceneDeactivated()
    }
}
```

### Step 2: Setup in SceneDelegate

```swift
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    lazy var manager: SceneDelegateManager = {
        SceneDelegateManager(delegates: [
            SceneAnalyticsHook(),
            // Add more hooks as needed
        ])
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        manager.scene(scene, willConnectTo: session, options: connectionOptions)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        manager.sceneDidBecomeActive(scene)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        manager.sceneWillResignActive(scene)
    }
}
```

---

## Important Notes & Gotchas

### KVC Property Assignment
- Properties receiving params via `dic` parameter **MUST** be marked `@objc`
- Property names in the dictionary must exactly match the Swift property names
- Only properties that exist on the object will be set (safe, no crashes for missing keys)

```swift
class TargetVC: UIViewController {
    @objc var titleText: String?    // MUST be @objc for KVC
    @objc var userId: Int = 0       // MUST be @objc for KVC
    
    // This will NOT receive the value (not marked @objc)
    var internalFlag: Bool = false
}
```

### Method Invocation
- Methods called via `callObjcMethod` or `callClassMethod` **MUST** be marked `@objc`
- Selector name format: `"methodName:"` (include colon for parameters)
- Only supports up to 2 parameters via the built-in methods

```swift
class MyClass: NSObject {
    @objc func doSomething(_ param: Any) { }           // selector: "doSomething:"
    @objc func doMore(_ p1: Any, _ p2: Any) { }        // selector: "doMore:with:"
    @objc class func classMethod(_ param: Any) { }     // selector: "classMethod:"
}
```

### URL Routing Limitations
- URL query parameters cannot contain special characters without encoding
- Does not support nested URL parameters (e.g., URLs within query strings)
- For complex scenarios (like token handling), intercept the URL and use code-based routing instead

### Module Name Resolution
- If `moduleName` is nil, defaults to the main bundle's `CFBundleExecutable`
- For frameworks/Swift Packages, always specify the module name explicitly
- Use `object.getModuleName()` to programmatically determine an object's module

### Top VC Traversal
The `currentViewController()` method handles:
- Modal presentations (presentedViewController chain)
- UITabBarController (selected tab)
- UINavigationController (visibleViewController)
- UISplitViewController (last child)

---

## Common Patterns

### Pattern 1: Cross-Module Navigation
```swift
// Module A wants to show Module B's detail page
// No import needed, just use strings
SwiftMediator.shared.push("DetailViewController", moduleName: "ModuleB", paramsDic: ["itemId": "12345"])
```

### Pattern 2: Deeplink Handling
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    // Let SwiftMediator handle the routing
    SwiftMediator.shared.openUrl(url.absoluteString)
    return true
}
```

### Pattern 3: Dynamic Method Call with Closure
```swift
// Define method with closure parameter
class MyHandler: NSObject {
    @objc func fetchData(_ completion: @escaping (Result<Data, Error>) -> Void) {
        // Fetch data and call completion
    }
}

// Call it
let handler = MyHandler()
SwiftMediator.shared.callObjcMethod(objc: handler, selName: "fetchData:", param: { (result: Any) in
    // Handle result
})
```

### Pattern 4: Modular AppDelegate
```swift
// Each feature module provides its own AppDelegate hook
// Main app just collects them all
let hooks: [AppDelegateMediator] = [
    AnalyticsHook(),
    CrashReportingHook(),
    PushNotificationHook(),
    DeepLinkHook(),
    InAppPurchaseHook()
]
let manager = AppDelegateManager(delegates: hooks)
```

---

## File Structure for AI Reference

| File | Purpose | Key APIs |
|------|---------|----------|
| `SwiftMediator.swift` | Core singleton | `SwiftMediator.shared` |
| `Init++.swift` | Object creation | `initVC()`, `initObjc()`, `initView()` |
| `Method++.swift` | Method calls | `callObjcMethod()`, `callClassMethod()` |
| `Model++.swift` | Modal presentation | `present()`, `dismissVC()` |
| `Navigation++.swift` | Navigation ops | `push()`, `pop()`, `popTo()`, `popToRoot()`, `getModuleName()` |
| `Property++.swift` | KVC assignment | Internal: `setObjectParams()`, `getTypeOfProperty()` |
| `SwiftUI++.swift` | SwiftUI support | `push(view:)`, `popToTitle()`, `View.getVC()` |
| `URL++.swift` | URL routing | `openUrl()`, `URL.parameters`, `String.urlEncoded()`, `String.urlDecoded()` |
| `AppDelegateMediator.swift` | Lifecycle hooks | `AppDelegateManager`, all UIApplicationDelegate methods |
| `SceneDelegateMediator.swift` | Scene hooks | `SceneDelegateManager`, all UIWindowSceneDelegate methods |
| `ViewController++.swift` | VC utilities | `UIViewController.currentViewController()`, `currentNavigationController()` |
| `Window++.swift` | Window utilities | `UIWindow.keyWindow`, `UIWindowScene.currentWindowScene` |
