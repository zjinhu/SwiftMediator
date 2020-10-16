
import UIKit

public class ShadowsButton: UIButton {
    
    struct Params {
        ///触感反馈
        static var hapticLevel = [String:Int]()        //0: disabled; 1: light; 2: medium; 3: heavy light; 4: soft; 5: rigid (4 - 5 only iOS 13)
        ///是否可选中
        static var isToggle = [String:Bool]()
        ///非选中模式背景色
        static var backColor = [String:UIColor]()
        ///选中模式背景色
        static var selectedBackColor = [String:UIColor]()
        ///阴影开关
        static var shadowActive = [String:Bool]()
        ///圆角
        static var cornerRadius = [String:CGFloat]()
        ///左侧圆角
        static var cornersLeft = [String:Bool]()
        ///右侧圆角
        static var cornersRight = [String:Bool]()
        ///反转阴影
        static var shadowReverse = [String:Bool]()
        
        static var shadowNormalColor = [String:UIColor]()
        static var shadowHighlightedShadowColor = [String:UIColor]()
        
        static var shadowNormalOffsetX = [String:CGFloat]()
        static var shadowNormalOffsetY = [String:CGFloat]()
        static var shadowHighlightedOffsetX = [String:CGFloat]()
        static var shadowHighlightedOffsetY = [String:CGFloat]()
    }
    ///阴影开关--shadow工具
    public var shadowActive: Bool {
        set (active) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowActive[tmpAddress] = active
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowActive[tmpAddress] ?? true
        }
    }
    ///圆角--shadow工具
    public var cornerRadius: CGFloat {
        set (radius) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.cornerRadius[tmpAddress] = radius
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.cornerRadius[tmpAddress] ?? 0.0
        }
    }
    
    ///左侧圆角--shadow工具
    public var cornersLeft: Bool {
        set (cornersLeft) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.cornersLeft[tmpAddress] = cornersLeft
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.cornersLeft[tmpAddress] ?? true
        }
    }
    
    ///右侧圆角--shadow工具
    public var cornersRight: Bool {
        set (cornersRight) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.cornersRight[tmpAddress] = cornersRight
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.cornersRight[tmpAddress] ?? true
        }
    }
    
    ///反转阴影，反转未按下与按下的阴影位置--shadow工具
    public var shadowReverse: Bool {
        set (reverse) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowReverse[tmpAddress] = reverse
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowReverse[tmpAddress] ?? false
        }
    }
    
    /// 阴影偏转幅度--shadow工具
    public var shadowNormalOffsetX: CGFloat {
        set (shadowNormalOffsetX) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowNormalOffsetX[tmpAddress] = shadowNormalOffsetX
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowNormalOffsetX[tmpAddress] ?? 2.0
        }
    }
    
    /// 阴影偏转幅度--shadow工具
    public var shadowNormalOffsetY: CGFloat {
        set (shadowNormalOffsetY) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowNormalOffsetY[tmpAddress] = shadowNormalOffsetY
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowNormalOffsetY[tmpAddress] ?? 2.0
        }
    }
    
    /// 阴影偏转幅度--shadow工具
    public var shadowHighlightedOffsetX: CGFloat {
        set (shadowHighlightedOffsetX) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowHighlightedOffsetX[tmpAddress] = shadowHighlightedOffsetX
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowHighlightedOffsetX[tmpAddress] ?? 2.0
        }
    }
    
    /// 阴影偏转幅度--shadow工具
    public var shadowHighlightedOffsetY: CGFloat {
        set (shadowHighlightedOffsetY) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowHighlightedOffsetY[tmpAddress] = shadowHighlightedOffsetY
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowHighlightedOffsetY[tmpAddress] ?? 2.0
        }
    }
    
    /// 阴影颜色--shadow工具
    public var shadowNormalColor: UIColor {
        set (shadowNormalColor) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowNormalColor[tmpAddress] = shadowNormalColor
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowNormalColor[tmpAddress] ?? UIColor.black
        }
    }
    
    /// 阴影颜色--shadow工具
    public var shadowHighlightedShadowColor: UIColor {
        set (shadowHighlightedShadowColor) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.shadowHighlightedShadowColor[tmpAddress] = shadowHighlightedShadowColor
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.shadowHighlightedShadowColor[tmpAddress] ?? UIColor.black
        }
    }
    
    ///触感反馈--shadow工具
    public var hapticLevel: Int {
        set (hapticLevel) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.hapticLevel[tmpAddress] = hapticLevel
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.hapticLevel[tmpAddress] ?? 0
        }
    }
    
    ///是否可选中--shadow工具
    public var isToggle: Bool {
        set (isToggle) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.isToggle[tmpAddress] = isToggle
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.isToggle[tmpAddress] ?? true
        }
    }
    
    /// 阴影模式下按钮普通模式背景色--shadow工具
    public var backColor: UIColor {
        set (backColor) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.backColor[tmpAddress] = backColor
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.backColor[tmpAddress] ?? UIColor.black
        }
    }
    
    /// 阴影模式下按钮选中背景色--shadow工具
    public var selectedBackColor: UIColor {
        set (selectedBackColor) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            Params.selectedBackColor[tmpAddress] = selectedBackColor
        }
        
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return Params.selectedBackColor[tmpAddress] ?? UIColor.black
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        if(Params.shadowActive[tmpAddress] == true){
            setupShadows()
        }
        self.backgroundColor = UIColor.clear
    }
    
    func setupShadows() {
        var shadowLayerDark: CAShapeLayer = CAShapeLayer()
        var shadowLayerLight: CAShapeLayer = CAShapeLayer()
        var hasDark = false
        var hasLight = false
        for item in self.layer.sublayers! {
            if item.name == "shadowDark" {
                shadowLayerDark = item as! CAShapeLayer
                hasDark = true
            }
            if item.name == "shadowLight" {
                shadowLayerLight = item as! CAShapeLayer
                hasLight = true
            }
        }
        
        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        
        var corners: UIRectCorner = UIRectCorner()
        
        if(Params.cornersLeft[tmpAddress] != nil) {
            if(Params.cornersLeft[tmpAddress] == true){
                corners.insert(.topLeft)
                corners.insert(.bottomLeft)
            }
        }else{
            corners.insert(.topLeft)
            corners.insert(.bottomLeft)
        }
        
        if(Params.cornersRight[tmpAddress] != nil) {
            if(Params.cornersRight[tmpAddress] == true){
                corners.insert(.topRight)
                corners.insert(.bottomRight)
            }
        }else{
            corners.insert(.topRight)
            corners.insert(.bottomRight)
        }
        
        var bgColor: UIColor? = self.backgroundColor
        
        if(Params.backColor[tmpAddress] != nil) {
            bgColor = Params.backColor[tmpAddress]!
        }
        
        if(!hasDark) {
            shadowLayerDark.name = "shadowDark"
            self.layer.insertSublayer(shadowLayerDark, at: 0)
            let content:CAShapeLayer = CAShapeLayer()
            content.frame = bounds
            content.backgroundColor = bgColor?.cgColor
            roundCorners(layer:content, corners: corners, radius: Params.cornerRadius[tmpAddress]!)
            content.masksToBounds = true
            shadowLayerDark.addSublayer(content)
        }
        shadowLayerDark.frame = bounds
        shadowLayerDark.shadowRadius = 4
        shadowLayerDark.shadowOpacity = 1
        
        var reverse: CGFloat = 1.0
        if(Params.shadowReverse[tmpAddress] != nil){
            reverse = (Params.shadowReverse[tmpAddress]!) ? -1.0 : 1.0
        }else{
            reverse = 1.0
        }
        
        let darkOffsetX: CGFloat = (Params.shadowNormalOffsetX[tmpAddress] != nil) ? Params.shadowNormalOffsetX[tmpAddress]! : 2.0
        let darkOffsetY: CGFloat = (Params.shadowNormalOffsetY[tmpAddress] != nil) ? Params.shadowNormalOffsetY[tmpAddress]! : 2.0
        shadowLayerDark.shadowOffset = CGSize( width: reverse*darkOffsetX, height: reverse*darkOffsetY)
        if(self.isEnabled){
            shadowLayerDark.shadowColor = (Params.shadowNormalColor[tmpAddress] != nil) ? Params.shadowNormalColor[tmpAddress]?.cgColor : UIColor(red: 8/255, green: 8/255, blue: 33/255, alpha: 0.12).cgColor
        }else{
            shadowLayerDark.shadowColor = UIColor.clear.cgColor
        }
        
        if(!hasLight) {
            shadowLayerLight.name = "shadowLight"
            self.layer.insertSublayer(shadowLayerLight, at: 0)
            let content:CAShapeLayer = CAShapeLayer()
            content.frame = bounds
            content.backgroundColor = bgColor?.cgColor
            
            roundCorners(layer:content, corners: corners, radius: Params.cornerRadius[tmpAddress]!)
            content.masksToBounds = true
            shadowLayerLight.addSublayer(content)
        }
        shadowLayerLight.frame = bounds
        shadowLayerLight.shadowRadius = 4
        shadowLayerLight.shadowOpacity = 1
        
        let lightOffsetX:CGFloat = (Params.shadowHighlightedOffsetX[tmpAddress] != nil) ? Params.shadowHighlightedOffsetX[tmpAddress]! : 2.0
        let lightOffsetY:CGFloat = (Params.shadowHighlightedOffsetY[tmpAddress] != nil) ? Params.shadowHighlightedOffsetY[tmpAddress]! : 2.0
        shadowLayerLight.shadowOffset = CGSize( width: reverse*lightOffsetX, height: reverse*lightOffsetY)
        if(self.isEnabled){
            shadowLayerLight.shadowColor = (Params.shadowHighlightedShadowColor[tmpAddress] != nil) ? Params.shadowHighlightedShadowColor[tmpAddress]?.cgColor : UIColor.black.withAlphaComponent(0.5).cgColor
        }else{
            shadowLayerLight.shadowColor = UIColor.clear.cgColor
        }
        
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        if(Params.shadowActive[tmpAddress] == true){
            Params.shadowReverse[tmpAddress] = (Params.shadowReverse[tmpAddress] != nil) ? !Params.shadowReverse[tmpAddress]! : true
            setupShadows()
        }
        
        var bgColor: UIColor = self.backgroundColor!
        if(Params.backColor[tmpAddress] != nil) {
            bgColor = Params.backColor[tmpAddress]!
        }
        
        var fgColor: UIColor = self.backgroundColor!
        if(Params.selectedBackColor[tmpAddress] != nil) {
            fgColor = Params.selectedBackColor[tmpAddress]!
        }
        
        var isToggle = false
        if(Params.isToggle[tmpAddress] != nil){
            isToggle = (Params.isToggle[tmpAddress] != nil) ? Params.isToggle[tmpAddress]! : false
        }
        
        if(isToggle){
            self.isSelected = !self.isSelected
            if(self.isSelected){
                for item in self.layer.sublayers! {
                    if item.name == "shadowDark" {
                        item.sublayers![0].backgroundColor = fgColor.cgColor
                    }
                    if item.name == "shadowLight" {
                        item.sublayers![0].backgroundColor = fgColor.cgColor
                    }
                }
            }else{
                for item in self.layer.sublayers! {
                    if item.name == "shadowDark" {
                        item.sublayers![0].backgroundColor = bgColor.cgColor
                    }
                    if item.name == "shadowLight" {
                        item.sublayers![0].backgroundColor = bgColor.cgColor
                    }
                }
            }
        }
        
        if(Params.hapticLevel[tmpAddress] != nil) {
            if(Params.hapticLevel[tmpAddress] != 0) {
                let force:UIImpactFeedbackGenerator.FeedbackStyle = UIImpactFeedbackGenerator.FeedbackStyle(rawValue: Params.hapticLevel[tmpAddress]!-1)!
                UIImpactFeedbackGenerator(style: force).impactOccurred()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        
        var isToggle = false
        if(Params.isToggle[tmpAddress] != nil){
            isToggle = (Params.isToggle[tmpAddress] != nil) ? Params.isToggle[tmpAddress]! : false
        }
        
        if(Params.shadowActive[tmpAddress] == true){
            if(!isToggle){
                Params.shadowReverse[tmpAddress] = (Params.shadowReverse[tmpAddress] != nil) ? !Params.shadowReverse[tmpAddress]! : false
                setupShadows()
            }
        }
        
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
        
        var isToggle = false
        if(Params.isToggle[tmpAddress] != nil){
            isToggle = (Params.isToggle[tmpAddress] != nil) ? Params.isToggle[tmpAddress]! : false
        }
        
        if(Params.shadowActive[tmpAddress] == true){
            if(!isToggle){
                Params.shadowReverse[tmpAddress] = (Params.shadowReverse[tmpAddress] != nil) ? !Params.shadowReverse[tmpAddress]! : false
                setupShadows()
            }
        }
        
        super.touchesCancelled(touches, with: event)
    }
    
    func roundCorners(layer: CALayer, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: layer.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.backgroundColor = UIColor.red.cgColor
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}
