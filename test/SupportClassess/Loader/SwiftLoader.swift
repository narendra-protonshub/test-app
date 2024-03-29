//

import UIKit
import QuartzCore
import CoreGraphics

let loaderSpinnerMarginSide : CGFloat = 35.0
let loaderSpinnerMarginTop : CGFloat = 30.0
let loaderTitleMargin : CGFloat = 5.0

public class SwiftLoader: UIView {
    public var coverView : UIView?
    public var titleLabel : UILabel?
    private var loadingView : SwiftLoadingView?
    public var animated : Bool = true
    public var canUpdated = false
    public var title: String?
    public var speed = 1
    public var config : Config = Config() {
        didSet {
             SwiftLoader.sharedInstance.loadingView?.config = config
        }
    }
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: SwiftLoader {
        struct Singleton {
            static let instance = SwiftLoader(frame: CGRect(x: 0, y: 0, width: Config().size, height: Config().size))
            //static let instance = SwiftLoader(frame: CGRectMake(0,0,Config().size,Config().size))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated, topMargin: 0)
    }
    
    public class func show(animated: Bool, topMargin: Int) {
        self.show(title: nil, animated: animated, topMargin: topMargin)
    }
    
    public class func show(title: String?, animated: Bool) {
        self.show(title: title, animated: animated, topMargin: 0)
    }
    
    public class func show(title: String?, animated: Bool, topMargin: Int) {
        
        let currentWindow : UIWindow = UIApplication.shared.keyWindow!
        
        let loader = SwiftLoader.sharedInstance
        loader.canUpdated = true
        loader.animated = animated
        loader.title = title
        loader.update()
        let height : CGFloat = UIScreen.main.bounds.size.height
        let width : CGFloat = UIScreen.main.bounds.size.width
        let center : CGPoint = CGPoint(x: width / 2.0, y:  height / 2.0 - CGFloat(topMargin))
            //CGPointMake(width / 2.0, height / 2.0 - CGFloat(topMargin))
        loader.center = center
        
        if (loader.superview == nil) {
            loader.coverView = UIView(frame: currentWindow.bounds)
            loader.coverView?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
            
            currentWindow.addSubview(loader.coverView!)
            currentWindow.addSubview(loader)
            loader.start()
        }
    }
    
    public class func hide() {
        let loader = SwiftLoader.sharedInstance
        loader.stop()
    }
    
    public class func setConfig(config : Config) {
        let loader = SwiftLoader.sharedInstance
        loader.config = config
        loader.frame = CGRect(x: 0, y: 0, width: loader.config.size, height: loader.config.size)
            //CGRectMake(0, 0, loader.config.size, loader.config.size)
    }
    
    /**
    public methods
    */
    
    public func setup() {
        self.alpha = 0
        self.update()
    }
    
    public func start() {
        self.loadingView?.start()
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
                }, completion: { (finished) -> Void in
                    
            });
        } else {
            self.alpha = 1
        }
    }
    
    public func stop() {
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 0
                }, completion: { (finished) -> Void in
                    self.removeFromSuperview()
                    self.coverView?.removeFromSuperview()
                    self.loadingView?.stop()
            });
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverView?.removeFromSuperview()
            self.loadingView?.stop()
        }
    }
    
    public func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.loadingView == nil) {
            self.loadingView = SwiftLoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = self.frameForSpinner()
        }
        
        if (self.titleLabel == nil) {
            self.titleLabel = UILabel(frame: CGRect(x: loaderTitleMargin, y: loaderSpinnerMarginTop + loadingViewSize, width: self.frame.width - loaderTitleMargin*2, height: 42.0))
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = CGRect(x: loaderTitleMargin, y: loaderSpinnerMarginTop + loadingViewSize, width: self.frame.width - loaderTitleMargin*2, height: 42.0)
                
               // CGRectMake(loaderTitleMargin, loaderSpinnerMarginTop + loadingViewSize, self.frame.width - loaderTitleMargin*2, 42.0)
        }
        
        self.titleLabel?.font = self.config.titleTextFont
      self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.text = self.title
       self.loadingView?.lineTintColor = UIColor.blue
        
        self.titleLabel?.isHidden = self.title == nil
    }
    
    func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(x: loaderSpinnerMarginSide, y: yOffset, width: loadingViewSize, height: loadingViewSize)
                //CGRectMake(loaderSpinnerMarginSide, yOffset, loadingViewSize, loadingViewSize)
        }
        return CGRect(x: loaderSpinnerMarginSide, y: loaderSpinnerMarginTop, width: loadingViewSize, height: loadingViewSize)
            //CGRectMake(loaderSpinnerMarginSide, loaderSpinnerMarginTop, loadingViewSize, loadingViewSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    *  Loader View
    */
    class SwiftLoadingView : UIView {
        
        public var speed : Int?
        public var lineWidth : Float?
        public var lineTintColor : UIColor?
        public var backgroundLayer : CAShapeLayer?
        public var isSpinning : Bool?
        
        public var config : Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        /**
        Setup loading view
        */
        
        public func setup() {
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
            
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = CAShapeLayerLineCap.round
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }

        
        public func update() {
            self.lineWidth = self.config.spinnerLineWidth
            self.speed = self.config.speed
            
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
           // self.backgroundLayer?.strokeColor = UIColor.black.cgColor
        }
        
        /**
        Draw Circle
        */
        
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        public func drawBackgroundCircle(partial : Bool) {
            let startAngle : CGFloat = CGFloat(Double.pi) / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat(Double.pi)) + startAngle
            
            let center : CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            
                //CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
            let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat(Double.pi)) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath;
        }
        
        /**
        Start and stop spinning
        */
        
        public func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = CGFloat(Double.pi)  * 2.0
            rotationAnimation.duration = CFTimeInterval(1);
            rotationAnimation.isCumulative = true;
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        public func stop() {
            self.drawBackgroundCircle(partial: false)
            
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
    
    
    /**
    * Loader config
    */
    public struct Config {
        
        /**
        *  Size of loader
        */
        public var size : CGFloat = 130.0
        
        /**
        *  Color of spinner view
        */
        public var spinnerColor = UIColor.black
        
        /**
         *  Spinner Line Width
         */
        public var spinnerLineWidth :Float = 1.0
        
        /**
        *  Color of title text
        */
        public var titleTextColor = UIColor.white
        
         /**
         *  Speed of the spinner
         */
        public var speed :Int = 1
        
        /**
        *  Font for title text in loader
        */
        public var titleTextFont : UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        /**
        *  Background color for loader
        */
        
        public var backgroundColor = UIColor.clear
        
        /**
        *  Foreground color
        */
        public var foregroundColor = UIColor.clear
        
        /**
        *  Foreground alpha CGFloat, between 0.0 and 1.0
        */
        public var foregroundAlpha:CGFloat = 0.0
        
        /**
        *  Corner radius for loader
        */
        public var cornerRadius : CGFloat = 10.0
        
        public init() {}
        
    }
}
