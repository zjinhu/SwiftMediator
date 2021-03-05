# SwiftButton
swift砖块系列：一个样式多变的Button，支持点击时动态改变大小，边框颜色等等

iOS图文自定义按钮，继承与UIControl，基于SnapKit实现。
可以实现各种各样的按钮，点击也可以实现根据图片自动适应按钮大小，详见demo。


![1.gif](https://github.com/jackiehu/JHButton/blob/master/Image/1.gif)


##样式

Swift
```swift
public enum JHImageButtonType {
        ///按钮图片居左 文案居右 可以影响父布局的大小
        case imageButtonTypeLeft
        ///按钮图片居右 文案居左 可以影响父布局的大小
        case imageButtonTypeRight
        ///按钮图片居上 文案居下 可以影响父布局的大小
        case imageButtonTypeTop
        ///按钮图片居下 文案居上 可以影响父布局的大小
        case imageButtonTypeBottom
}
```
##属性

Swift
```swift
	  ///标题
	  public var title : String?
    ///图片
    public var image : UIImage?    ///背景图片
    public var backImage : UIImage?
    ///内容文字视图
    public var titleLabel = UILabel()
    ///图片视图
    public var imageView = UIImageView()
    ///背景图片视图
    public var backImageView = UIImageView()
    ///是否反转
    public var isNeedRotation : Bool = false
    ///是否可用
    public override var isEnabled: Bool
    ///是否选中
    public override var isSelected: Bool
    ///当前按钮状态
    public var currentState : JHButtonState
```
##API

Swift 
```swift
/// 创建按钮
    /// - Parameters:
    ///   - type: 图文混排类型
    ///   - marginArr: 从左到右或者从上到下的间距数组
public convenience init(_ type : JHImageButtonType = .imageButtonTypeLeft, marginArr : [Float]? = [5])

///触发点击
public func handleControlEvent(_ event : UIControl.Event , action : @escaping ActionBlock) 
/// 设置背景颜色
    /// - Parameters:
    ///   - normalColor: 普通状态
    ///   - highLightColor: 点击状态
    ///   - selectedColor: 选中状态
    ///   - disableColor: 不可用状态
 public func setBackColor(normalColor : UIColor,
                          highLightColor : UIColor?,
                          selectedColor : UIColor?,
                          disableColor  : UIColor?)
///设置图片
public func setImage(normalImage : UIImage,
                     highLightImage : UIImage? = nil,
                     selectedImage : UIImage? = nil,
                     disableImage  : UIImage? = nil )
/// 设置标题字体颜色
public func setTitleColor(normalTitleColor : UIColor,
                          highLightTitleColor : UIColor?,
							selectedTitleColor : UIColor,
							disableTitleColor  : UIColor?)
 /// 设置边框颜色   
public func setLayerColor(normalLayerColor : UIColor,
                          highLightLayerColor : UIColor?,
							selectedLayerColor : UIColor?,
							disableLayerColor  : UIColor?)
 /// 设置背景图片   
public func setBackImage(normalBackImage : UIImage,
                         highLightBackImage : UIImage?,
							selectedBackImage : UIImage?,
							disableBackImage  : UIImage?)
```

## 使用方法

swift
```swift
let but = JHButton.init(.imageButtonTypeTop)
        but.backgroundColor = .orange
        but.title = “按钮1按钮1按钮1按钮1按钮1按钮1按钮1按钮1按钮1”
        but.image = UIImage.init(named: "image1")
        but.titleLabel.textColor = .cyan
        but.titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(but)
        but.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(80)
        }
        
        let btn2 = JHButton.init(.imageButtonTypeLeft)
        btn2.backgroundColor = .yellow
        btn2.image = UIImage.init(named: "image3")
        btn2.title = "按钮2";
        btn2.titleLabel.textColor = .red
        btn2.titleLabel.font = UIFont.systemFont(ofSize: 13)
        btn2.titleLabel.textAlignment = .left
        self.view.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.top.equalTo(but.snp.bottom).offset(20)
            make.left.equalTo(but.snp.left).offset(0)
        }
        
        let btn3 = JHButton.init(.imageButtonTypeLeft,marginArr: [0])
        btn3.backgroundColor = .cyan
        btn3.title = "按钮3"
        btn3.titleLabel.textColor = .red
        btn3.titleLabel.font = UIFont.systemFont(ofSize: 13)
        btn3.titleLabel.textAlignment = .left
        self.view.addSubview(btn3)
        btn3.snp.makeConstraints { (make) in
            make.top.equalTo(but.snp.bottom).offset(20)
            make.left.equalTo(btn2.snp.right).offset(20)
        }
        
        let btn4 = JHButton.init(.imageButtonTypeLeft,marginArr: [0])
        btn4.backgroundColor = .gray
        btn4.image = UIImage.init(named: "image3")
        self.view.addSubview(btn4)
        btn4.snp.makeConstraints { (make) in
            make.top.equalTo(but.snp.bottom).offset(20)
            make.left.equalTo(btn3.snp.right).offset(20)
        }
        
        let btn5 = JHButton.init(.imageButtonTypeLeft,marginArr: [10,20,5])
        btn5.setImage(normalImage: UIImage.init(named: "image1")!, highLightImage: UIImage.init(named: "image3")!)
        btn5.setTitleColor(normalTitleColor: .red, highLightTitleColor: .green)
        btn5.setLayerColor(normalLayerColor: .purple, highLightLayerColor: .black)
        btn5.title = "123123"
        btn5.titleLabel.textColor = .red
        btn5.titleLabel.font = UIFont.systemFont(ofSize: 13)
        btn5.titleLabel.textAlignment = .left
        btn5.layer.borderWidth = 2
        
        self.view.addSubview(btn5)
        btn5.snp.makeConstraints { (make) in
            make.top.equalTo(btn2.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        let btn6 = JHButton.init(.imageButtonTypeLeft,marginArr: [5,10])
        btn6.backgroundColor = .gray
        btn6.image = UIImage.init(named: "image3")
        btn6.title = "123123"
        btn6.titleLabel.textColor = .red
        btn6.titleLabel.font = UIFont.systemFont(ofSize: 13)
        btn6.titleLabel.textAlignment = .left
        self.view.addSubview(btn6)
        btn6.snp.makeConstraints { (make) in
            make.top.equalTo(btn5.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(100);
        }

        btn6.handleControlEvent(.touchUpInside) { (btn) in
            print(btn.title as Any)
        }
```


##  许可证
SwiftButton 使用 MIT 许可证，详情见 LICENSE 文件

