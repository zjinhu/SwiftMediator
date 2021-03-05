# SwiftyForm
快速集成表单

快速创建多变的表格样式，重度参考Former，Eureka。部分改动提高了代码的可读性易用性，基本满足展示需求。
## 使用
使用自己创建的tableView即可，绑定一下数据源
```
lazy var former = Former(tableView: self.tableView!)
```

然后在相应的地方添加相应的Row。比如：
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

