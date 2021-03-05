//
//  JHButton.swift
//  JHButton_Swift
//
//  Created by iOS on 2020/1/14.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit

public enum ImageButtonType {
    ///按钮图片居左 文案居右 可以影响父布局的大小
    case imageButtonTypeLeft
    ///按钮图片居右 文案居左 可以影响父布局的大小
    case imageButtonTypeRight
    ///按钮图片居上 文案居下 可以影响父布局的大小
    case imageButtonTypeTop
    ///按钮图片居下 文案居上 可以影响父布局的大小
    case imageButtonTypeBottom
}

public enum ButtonState {
    ///按钮状态 正常
    case buttonStateNormal
    ///按钮状态 高亮
    case buttonStateHighLight
    ///按钮状态 选中
    case buttonStateSelected
    ///按钮状态 不可用
    case buttonStateDisable
}


public class SwiftButton: UIControl {
    
    ///按钮的闭包回调
    public typealias ActionBlock = (_ sender: SwiftButton) -> Void
    ///title字符串
    public var title : String?{
        didSet{
            titleLabel.text = title
        }
    }
    ///图片
    public var image : UIImage?{
        didSet{
            imageView.image = image
        }
    }
    ///背景图片
    public var backImage : UIImage?{
        didSet{
            backImageView.image = backImage
        }
    }
    ///内容文字视图
    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        return titleLabel
    }()
    ///图片视图
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    ///背景图片视图
    public lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    ///是否反转
    public var isNeedRotation : Bool = false{
        didSet{
            if isNeedRotation{
                UIView.animate(withDuration: 0.3) {
                    self.imageView.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi*180))
                }
            }else{
                UIView.animate(withDuration: 0.3) {
                    self.imageView.transform = CGAffineTransform.identity
                }
            }
        }
    }
    ///是否可用
    public override var isEnabled: Bool{
        didSet{
            if isEnabled {
                setNormal()
            }else{
                setDisable()
            }
        }
    }
    ///是否选中
    public override var isSelected: Bool{
        didSet{
            if isSelected{
                setSelected()
            }else{
                setNormal()
            }
        }
    }
    ///当前按钮状态
    public var currentState : ButtonState = .buttonStateNormal
    
    //MARK: -- 以下内部参数
    ///默认间距
    static let imageButtonDefaultMargin : Float? = 0
    static let imageButtonDefaultUnsetMargin : Float? = -1001
    /**
     *  间距
     */
    private var marginArray : [Float]?
    /**
     *  背景颜色
     */
    private var normalColor : UIColor?
    private var highLightColor : UIColor?
    private var selectedColor : UIColor?
    private var disableColor : UIColor?
    /**
     *  图片
     */
    private var normalImage : UIImage?
    private var highLightImage : UIImage?
    private var selectedImage : UIImage?
    private var disableImage : UIImage?
    /**
     *  文本颜色
     */
    private var normalTitleColor : UIColor?
    private var highLightTitleColor : UIColor?
    private var selectedTitleColor : UIColor?
    private var disableTitleColor : UIColor?
    /**
     *  layer颜色
     */
    private var normalLayerColor : UIColor?
    private var highLightLayerColor : UIColor?
    private var selectedLayerColor : UIColor?
    private var disableLayerColor : UIColor?
    /**
     *  背景图片
     */
    private var normalBackImage : UIImage?
    private var highLightBackImage : UIImage?
    private var selectedBackImage : UIImage?
    private var disableBackImage : UIImage?
    /**
     *  间距
     */
    private var marginTopOrLeft : Float? = 0.0
    private var marginBottomOrRight : Float? = 0.0
    private var marginMiddle : Float? = 0.0
    /**
     *  填充
     */
    private var topOrLeftView = UIView()
    private var bottomOrRightView = UIView()
    /**
     *  按钮类型
     */
    private var buttonType : ImageButtonType = .imageButtonTypeLeft
    
    private var actionBlock : ActionBlock?
    
}

extension SwiftButton{
    
    /// 创建按钮
    /// - Parameters:
    ///   - type: 图文混排类型
    ///   - marginArr: 从左到右或者从上到下的间距数组
    public convenience init(_ type : ImageButtonType = .imageButtonTypeLeft, marginArr : [Float]? = [5]) {
        self.init()
        marginArray = marginArr
        buttonType = type
        
        setRootSubView()
    }
    
    ///触发点击
    public func handleControlEvent(_ event : UIControl.Event , action : @escaping ActionBlock) {
        addTarget(self, action: #selector(callActionBlock), for: event)
        actionBlock = action
    }
    ///点击闭包
    @objc
    func callActionBlock(_ sender: SwiftButton) {
        guard let action = actionBlock else {
            return
        }
        action(sender)
    }
    //MARK:--布局
    func setRootSubView() {
        
        backImageView.image = image
        addSubview(backImageView)
        
        topOrLeftView.isUserInteractionEnabled = false
        addSubview(topOrLeftView)
        
        bottomOrRightView.isUserInteractionEnabled = false
        addSubview(bottomOrRightView)
        
        titleLabel.text = title
        addSubview(titleLabel)
        
        imageView.image = image
        addSubview(imageView)
        
        switch marginArray?.count {
        case 0:
            marginMiddle = SwiftButton.imageButtonDefaultMargin
            marginTopOrLeft = SwiftButton.imageButtonDefaultUnsetMargin
            marginBottomOrRight = SwiftButton.imageButtonDefaultUnsetMargin
        case 1:
            marginMiddle = marginArray?[0]
            marginTopOrLeft = SwiftButton.imageButtonDefaultUnsetMargin
            marginBottomOrRight = SwiftButton.imageButtonDefaultUnsetMargin
        case 2:
            marginTopOrLeft = marginArray?[0]
            marginMiddle = marginArray?[1]
            marginBottomOrRight = SwiftButton.imageButtonDefaultUnsetMargin
        case 3:
            marginTopOrLeft = marginArray?[0]
            marginMiddle = marginArray?[1]
            marginBottomOrRight = marginArray?[2]
        default:
            debugPrint("")
        }
        
        updateLayout()
    }
    
    func updateLayout() {
        
        switch buttonType {
        case .imageButtonTypeTop:
            setTop()
        case .imageButtonTypeLeft:
            setLeft()
        case .imageButtonTypeBottom:
            setBottom()
        case .imageButtonTypeRight:
            setRight()
        }
        
        backImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    func setTop() {
        
        topOrLeftView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(imageView.snp.top)
            if marginTopOrLeft != SwiftButton.imageButtonDefaultUnsetMargin{
                make.height.equalTo(marginTopOrLeft ?? 0)
            }
            if marginTopOrLeft == marginBottomOrRight{
                make.height.equalTo(bottomOrRightView.snp.height)
            }
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-(marginMiddle ?? 0))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomOrRightView.snp.top)
            make.height.lessThanOrEqualToSuperview()
        }
        
        bottomOrRightView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            if marginBottomOrRight != SwiftButton.imageButtonDefaultUnsetMargin{
                make.height.equalTo(marginBottomOrRight ?? 0)
            }
        }
        
        snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(imageView.snp.width)
            make.width.greaterThanOrEqualTo(titleLabel.snp.width)
        }
        
    }
    
    func setLeft() {
        
        topOrLeftView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(imageView.snp.left)
            if marginTopOrLeft != SwiftButton.imageButtonDefaultUnsetMargin{
                make.width.equalTo(marginTopOrLeft ?? 0)
            }
            if marginTopOrLeft == marginBottomOrRight{
                make.width.equalTo(bottomOrRightView.snp.width)
            }
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-(marginMiddle ?? 0))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(bottomOrRightView.snp.left)
            make.width.lessThanOrEqualToSuperview()
        }
        
        bottomOrRightView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            if marginBottomOrRight != SwiftButton.imageButtonDefaultUnsetMargin{
                make.width.equalTo(marginBottomOrRight ?? 0)
            }
        }
        
        snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(imageView.snp.height)
            make.height.greaterThanOrEqualTo(titleLabel.snp.height)
        }
    }
    
    func setBottom() {
        
        topOrLeftView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
            if marginTopOrLeft != SwiftButton.imageButtonDefaultUnsetMargin{
                make.height.equalTo(marginTopOrLeft ?? 0)
            }
            if marginTopOrLeft == marginBottomOrRight{
                make.height.equalTo(bottomOrRightView.snp.height)
            }
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.top).offset(-(marginMiddle ?? 0))
            make.height.lessThanOrEqualToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomOrRightView.snp.top)
        }
        
        bottomOrRightView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            if marginBottomOrRight != SwiftButton.imageButtonDefaultUnsetMargin{
                make.height.equalTo(marginBottomOrRight ?? 0)
            }
        }
        
        snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(imageView.snp.width)
            make.width.greaterThanOrEqualTo(titleLabel.snp.width)
        }
        
    }
    
    func setRight() {
        
        topOrLeftView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left)
            if marginTopOrLeft != SwiftButton.imageButtonDefaultUnsetMargin{
                make.width.equalTo(marginTopOrLeft ?? 0)
            }
            if marginTopOrLeft == marginBottomOrRight{
                make.width.equalTo(bottomOrRightView.snp.width)
            }
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(imageView.snp.left).offset(-(marginMiddle ?? 0))
            make.width.lessThanOrEqualToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(bottomOrRightView.snp.left)
        }
        
        bottomOrRightView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            if marginBottomOrRight != SwiftButton.imageButtonDefaultUnsetMargin{
                make.width.equalTo(marginBottomOrRight ?? 0)
            }
        }
        
        snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(imageView.snp.height)
            make.height.greaterThanOrEqualTo(titleLabel.snp.height)
        }
        
    }
    
    //MARK: --样式设置
    
    /// 设置背景颜色
    /// - Parameters:
    ///   - normal: 普通状态
    ///   - highLight: 点击状态
    ///   - selected: 选中状态
    ///   - disable: 不可用状态
    public func setBackColor(normal : UIColor,
                             highLight : UIColor? = .clear,
                             selected : UIColor? = .clear,
                             disable  : UIColor? = .clear ){
        normalColor = normal
        highLightColor = highLight
        selectedColor = selected
        disableColor = disable
        switch currentState {
        case .buttonStateNormal:
            backgroundColor = normalColor
        case .buttonStateHighLight:
            backgroundColor = highLightColor
        case .buttonStateSelected:
            backgroundColor = selectedColor
        case .buttonStateDisable:
            backgroundColor = disableColor
        }
    }
    
    /// 设置图片
    /// - Parameters:
    ///   - normal: 普通状态
    ///   - highLight: 点击状态
    ///   - selected: 选中状态
    ///   - disable: 不可用状态
    public func setImage(normal : UIImage,
                         highLight : UIImage? = nil,
                         selected : UIImage? = nil,
                         disable  : UIImage? = nil ){
        normalImage = normal
        highLightImage = highLight
        selectedImage = selected
        disableImage = disable
        switch currentState {
        case .buttonStateNormal:
            image = normalImage
        case .buttonStateHighLight:
            image = highLightImage
        case .buttonStateSelected:
            image = selectedImage
        case .buttonStateDisable:
            image = disableImage
        }
    }
    
    /// 设置标题字体颜色
    /// - Parameters:
    ///   - normal: 普通状态
    ///   - highLight: 点击状态
    ///   - selected: 选中状态
    ///   - disable: 不可用状态
    public func setTitleColor(normal : UIColor,
                              highLight : UIColor? = .clear,
                              selected : UIColor? = .clear,
                              disable  : UIColor? = .clear ){
        normalTitleColor = normal
        highLightTitleColor = highLight
        selectedTitleColor = selected
        disableTitleColor = disable
        switch currentState {
        case .buttonStateNormal:
            titleLabel.textColor = normalTitleColor
        case .buttonStateHighLight:
            titleLabel.textColor = highLightTitleColor
        case .buttonStateSelected:
            titleLabel.textColor = selectedTitleColor
        case .buttonStateDisable:
            titleLabel.textColor = disableTitleColor
        }
    }
    
    /// 设置边框颜色
    /// - Parameters:
    ///   - normal: 普通状态
    ///   - highLight: 点击状态
    ///   - selected: 选中状态
    ///   - disable: 不可用状态
    public func setLayerColor(normal : UIColor,
                              highLight : UIColor? = .clear,
                              selected : UIColor? = .clear,
                              disable  : UIColor? = .clear ){
        normalLayerColor = normal
        highLightLayerColor = highLight
        selectedLayerColor = selected
        disableLayerColor = disable
        switch currentState {
        case .buttonStateNormal:
            layer.borderColor = normalLayerColor?.cgColor
        case .buttonStateHighLight:
            layer.borderColor = highLightLayerColor?.cgColor
        case .buttonStateSelected:
            layer.borderColor = selectedLayerColor?.cgColor
        case .buttonStateDisable:
            layer.borderColor = disableLayerColor?.cgColor
        }
    }
    
    /// 设置背景图片
    /// - Parameters:
    ///   - normal: 普通状态
    ///   - highLight: 点击状态
    ///   - selected: 选中状态
    ///   - disable: 不可用状态
    public func setBackImage(normal : UIImage,
                             highLight : UIImage? = nil,
                             selected : UIImage? = nil,
                             disable  : UIImage? = nil ){
        normalBackImage = normal
        highLightBackImage = highLight
        selectedBackImage = selected
        disableBackImage = disable
        switch currentState {
        case .buttonStateNormal:
            backImage = normalBackImage
        case .buttonStateHighLight:
            backImage = highLightBackImage
        case .buttonStateSelected:
            backImage = selectedBackImage
        case .buttonStateDisable:
            backImage = disableBackImage
        }
    }
    
    //MARK: --状态设置
    func setNormal() {
        guard currentState != .buttonStateNormal else { return }
        
        currentState = .buttonStateNormal
        
        if let color = normalColor{
            backgroundColor = color
        }
        if let image = normalImage{
            imageView.image = image
        }
        if let titleColor = normalTitleColor{
            titleLabel.textColor = titleColor
        }
        if let layerColor = normalLayerColor{
            layer.borderColor = layerColor.cgColor
        }
        if let backImage = normalBackImage{
            backImageView.image = backImage
        }
    }
    
    func setHighLight() {
        guard currentState != .buttonStateHighLight else { return }
        
        currentState = .buttonStateHighLight
        
        if let color = highLightColor{
            backgroundColor = color
        }
        if let image = highLightImage{
            imageView.image = image
        }
        if let titleColor = highLightTitleColor{
            titleLabel.textColor = titleColor
        }
        if let layerColor = highLightLayerColor{
            layer.borderColor = layerColor.cgColor
        }
        if let backImage = highLightBackImage{
            backImageView.image = backImage
        }
        
    }
    
    func setSelected() {
        guard currentState != .buttonStateSelected else { return }
        
        currentState = .buttonStateSelected
        if let color = selectedColor{
            backgroundColor = color
        }
        if let image = selectedImage{
            imageView.image = image
        }
        if let titleColor = selectedTitleColor{
            titleLabel.textColor = titleColor
        }
        if let layerColor = selectedLayerColor{
            layer.borderColor = layerColor.cgColor
        }
        if let backImage = selectedBackImage{
            backImageView.image = backImage
        }
    }
    
    func setDisable() {
        guard currentState != .buttonStateDisable else { return }
        
        currentState = .buttonStateDisable        
        if let color = disableColor{
            backgroundColor = color
        }
        if let image = disableImage{
            imageView.image = image
        }
        if let titleColor = disableTitleColor{
            titleLabel.textColor = titleColor
        }
        if let layerColor = disableLayerColor{
            layer.borderColor = layerColor.cgColor
        }
        if let backImage = disableBackImage{
            backImageView.image = backImage
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: --Touch事件监听
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setHighLight()
        return true
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setHighLight()
        return true
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        setNormal()
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        setNormal()
    }
}
