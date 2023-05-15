![](Image/logo.png)



[![Version](https://img.shields.io/cocoapods/v/Swift_Form.svg?style=flat)](http://cocoapods.org/pods/Swift_Form)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg)
![iOS 11.0+](https://img.shields.io/badge/iOS-11.0%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)



快速集成表单列表。创建多变的表格样式，无需继承特定的VC，只需要有一个UITableView绑定下数据源即可。

| ![](Image/1.png) | ![](Image/2.png) | ![](Image/3.png) |
| ---------------- | ---------------- | ---------------- |
| ![](Image/4.png) | ![](Image/5.png) |                  |
|                  |                  |                  |



## 安装

### Cocoapods

1.在 Podfile 中添加 `pod ‘Swift_Form’`

2.执行 `pod install 或 pod update`

3.导入 `import Swift_Form`

### Swift Package Manager

从 Xcode 11 开始，集成了 Swift Package Manager，使用起来非常方便。SwiftyForm 也支持通过 Swift Package Manager 集成。

在 Xcode 的菜单栏中选择 `File > Swift Packages > Add Pacakage Dependency`，然后在搜索栏输入

`https://github.com/jackiehu/SwiftyForm`，即可完成集成

### 手动集成

SwiftyForm 也支持手动集成，只需把Sources文件夹中的SwiftyForm文件夹拖进需要集成的项目即可



## 使用

使用自己创建的tableView即可，绑定一下数据源

```
lazy var former = Former(tableView: self.tableView!)
```

然后添加相应的Row，Section。比如：

```
//MARK: 用户头像样式cell
        let user = UserRow()
        user.userName = "用户名"
        user.avatarImage = UIImage.init(named: "icon")
        user.userInfo = "用户简介用户简介用户简介用户简介用户简介用户简介用户简介用户简介用户简介用户简介用户简介"
        user.cell.userInfoLabel.font = .systemFont(ofSize: 11)
        user.cell.addDownLine()
        user.onSelected { (row) in
            print("点击了User的Cell")
        }

let sectionFormer = SectionFormer(user)

former.append(sectionFormer:sectionFormer)
```

也支持增删等操作（需要刷新数据）
```
sectionFormer1.remove(rowFormer: user)
self.former.reload(sectionFormer: sectionFormer1)
```

```
sectionFormer1.insert(rowFormer: user, toIndex: 0)
self.former.reload(sectionFormer: sectionFormer1)
```



## 更多砖块工具加速APP开发

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftBrick&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftBrick)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMediator&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftShow&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftShow)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftLog&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftLog)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftEmptyData&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftEmptyData)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftPageView&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftPageView)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=JHTabBarController&theme=radical&locale=cn)](https://github.com/jackiehu/JHTabBarController)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMesh&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNotification&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNotification)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNetSwitch&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNetSwitch)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftButton&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftButton)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftDatePicker&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftDatePicker)