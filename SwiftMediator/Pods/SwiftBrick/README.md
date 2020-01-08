# SwiftBrick
工具类集合，方便快速搭建UI各种视图
包括：
  * 1：需要继承的BaseVC，提供JHViewController，JHTableViewController，JHCollectionViewController，JHWebViewController，方便快速搭建
  * 2：宏，UI固定数据，字体，log输出
  * 3：工具视图，提供需要继承的JHTableViewCell，JHTableViewHeaderFooterView，JHCollectionViewCell，JHCollectionReusableView，内含注册以及复用方法，重写布局方法和传递Model方法即可
  * 4：SnapKit工具类，方便快速创建平时开发所使用的各种控件，一行代码创建view并布局

依赖  SnapKit 

代码示例请参考Demo

##  安装
### .CocoaPods:<br>
*   1.在 Podfile 中添加 pod 'SwiftBrick'<br>
*   2.执行 pod install 或 pod update<br>
*   3.导入 #import SwiftBrick
