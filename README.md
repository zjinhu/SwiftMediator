# SwiftMediator
Swift 路由和模块通信解耦工具。 可以让模块间无耦合的调用服务、页面跳转。无需注册，不需要协议，只需要知道目标VC的类名和module名称。添加AppDelegate、SceneDelegate解耦工具，只需要在主工程留下钩子即可，用法详见Demo。
## 安装
```
pod ‘SwiftMediator’
```
## 使用
### 原生跳转
```
SwiftMediator.shared.present(moduleName: “SwiftMediator”, toVC: “TestVC”,paramsDic: [“str”:”123123","titleName":"23452345”,”num”:13,”dic":["a":12,"b":"100"]])
```
或者
```
SwiftMediator.shared.push(moduleName: “SwiftMediator”, toVC: “TestVC”,paramsDic: [“str”:”123123","titleName":"23452345","num”:13,”dic”:["a":12,"b":"100"]])
```

### URL跳转
```
SwiftMediator.shared.openUrl(“app://present/SwiftMediator/TestVC?str=123&titleName=456&num=111")
```

## 规范
### URL跳转

URL路由跳转 跳转区分Push、present、fullScreen，根据拆分URL的scheme，host，path，query拿到所用的参数

* scheme：APP标记scheme，区分APP跳转，APP内使用可传任意
* host：可传递push、present、fullScreen用于区分跳转样式
* path：/modulename/vcname，用于获取组件名和VC名
* query：采用key=value&key=value方式拼接，可转换成字典

### Push
```
/// 原生路由Push
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳—不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - toVC: 目标VC名称
    ///   - paramsDic: 参数字典
```

### Present
```
    /// 原生路由present
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳—不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - toVC: 目标VC名称
    ///   - paramsDic: 参数字典
    ///   - modelStyle: 0模态样式为默认，1是全屏模态。。。。。
```

### 获取最上层VC
* currentNavigationController
* currentViewController

### 初始化VC
```
    /// 反射VC初始化并且赋值
    /// - Parameters:
    ///   - moduleName: 组件boundle名称
    ///   - vcName: VC名称
    ///   - dic: 参数字典//由于是KVC赋值，必须要在参数上标记@objc
```

详细用法参见Demo **ViewController**
