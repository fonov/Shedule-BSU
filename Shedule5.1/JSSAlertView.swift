//
//  JSSAlertView.swift
//  Shedule5.1
//
//  Created by CSergey on 14.03.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import Foundation
import UIKit

class JSSAlertView: UIViewController {
    
    var containerView:UIView!
    var alertBackgroundView:UIView!
    var dismissButton:UIButton!
    var cancelButton:UIButton!
    var buttonLabel:UILabel!
    var cancelButtonLabel:UILabel!
    var titleLabel:UILabel!
    var textView:UITextView!
    weak var rootViewController:UIViewController!
    var iconImage:UIImage!
    var iconImageView:UIImageView!
    var closeAction:(()->Void)!
    var cancelAction:(()->Void)!
    var isAlertOpen:Bool = false
    
    enum FontType {
        case title, text, button
    }
    var titleFont = "HelveticaNeue-Light"
    var textFont = "HelveticaNeue"
    var buttonFont = "HelveticaNeue-Bold"
    
    var defaultColor = UIColorFromHex(0xF2F4F4, alpha: 1)
    
    enum TextColorTheme {
        case dark, light
    }
    var darkTextColor = UIColorFromHex(0x000000, alpha: 0.75)
    var lightTextColor = UIColorFromHex(0xffffff, alpha: 0.9)
    
    enum ActionType {
        case close, cancel
    }
    
    let baseHeight:CGFloat = 160.0
    var alertWidth:CGFloat = 290.0
    let buttonHeight:CGFloat = 70.0
    let padding:CGFloat = 20.0
    
    var viewWidth:CGFloat?
    var viewHeight:CGFloat?
    
    // Allow alerts to be closed/renamed in a chainable manner
    class JSSAlertViewResponder {
        let alertview: JSSAlertView
        
        init(alertview: JSSAlertView) {
            self.alertview = alertview
        }
        
        func addAction(_ action: @escaping ()->Void) {
            self.alertview.addAction(action)
        }
        
        func addCancelAction(_ action: @escaping ()->Void) {
            self.alertview.addCancelAction(action)
        }
        
        func setTitleFont(_ fontStr: String) {
            self.alertview.setFont(fontStr, type: .title)
        }
        
        func setTextFont(_ fontStr: String) {
            self.alertview.setFont(fontStr, type: .text)
        }
        
        func setButtonFont(_ fontStr: String) {
            self.alertview.setFont(fontStr, type: .button)
        }
        
        func setTextTheme(_ theme: TextColorTheme) {
            self.alertview.setTextTheme(theme)
        }
        
        @objc func close() {
            self.alertview.closeView(false)
        }
    }
    
    func setFont(_ fontStr: String, type: FontType) {
        switch type {
        case .title:
            self.titleFont = fontStr
            if let font = UIFont(name: self.titleFont, size: 24) {
                self.titleLabel.font = font
            } else {
                self.titleLabel.font = UIFont.systemFont(ofSize: 24)
            }
        case .text:
            if self.textView != nil {
                self.textFont = fontStr
                if let font = UIFont(name: self.textFont, size: 16) {
                    self.textView.font = font
                } else {
                    self.textView.font = UIFont.systemFont(ofSize: 16)
                }
            }
        case .button:
            self.buttonFont = fontStr
            if let font = UIFont(name: self.buttonFont, size: 24) {
                self.buttonLabel.font = font
            } else {
                self.buttonLabel.font = UIFont.systemFont(ofSize: 24)
            }
        }
        // relayout to account for size changes
        self.viewDidLayoutSubviews()
    }
    
    func setTextTheme(_ theme: TextColorTheme) {
        switch theme {
        case .light:
            recolorText(lightTextColor)
        case .dark:
            recolorText(darkTextColor)
        }
    }
    
    func recolorText(_ color: UIColor) {
        titleLabel.textColor = color
        if textView != nil {
            textView.textColor = color
        }
        buttonLabel.textColor = color
        if cancelButtonLabel != nil {
            cancelButtonLabel.textColor = color
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let size = self.screenSize()
        self.viewWidth = size.width
        self.viewHeight = size.height
        
        var yPos:CGFloat = 0.0
        let contentWidth:CGFloat = self.alertWidth - (self.padding*2)
        
        // position the icon image view, if there is one
        if self.iconImageView != nil {
            yPos += iconImageView.frame.height
            let centerX = (self.alertWidth-self.iconImageView.frame.width)/2
            self.iconImageView.frame.origin = CGPoint(x: centerX, y: self.padding)
            yPos += padding
        }
        
        // position the title
        let titleString = titleLabel.text! as NSString
        let titleAttr = [NSFontAttributeName:titleLabel.font]
        let titleSize = CGSize(width: contentWidth, height: 90)
        let titleRect = titleString.boundingRect(with: titleSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: titleAttr, context: nil)
        yPos += padding
        self.titleLabel.frame = CGRect(x: self.padding, y: yPos, width: self.alertWidth - (self.padding*2), height: ceil(titleRect.size.height))
        yPos += ceil(titleRect.size.height)
        
        
        // position text
        if self.textView != nil {
            let textString = textView.text! as NSString
            let textAttr = [NSFontAttributeName:textView.font as AnyObject]
            let realSize = textView.sizeThatFits(CGSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude))
            let textSize = CGSize(width: contentWidth, height: CGFloat(fmaxf(Float(90.0), Float(realSize.height))))
            let textRect = textString.boundingRect(with: textSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: textAttr, context: nil)
            self.textView.frame = CGRect(x: self.padding, y: yPos, width: self.alertWidth - (self.padding*2), height: ceil(textRect.size.height)*2)
            yPos += ceil(textRect.size.height) + padding/2
        }
        
        // position the buttons
        yPos += self.padding
        
        var buttonWidth = self.alertWidth
        if self.cancelButton != nil {
            buttonWidth = self.alertWidth/2
            self.cancelButton.frame = CGRect(x: 0, y: yPos, width: buttonWidth-0.5, height: self.buttonHeight)
            if self.cancelButtonLabel != nil {
                self.cancelButtonLabel.frame = CGRect(x: self.padding, y: (self.buttonHeight/2) - 15, width: buttonWidth - (self.padding*2), height: 30)
            }
        }
        
        let buttonX = buttonWidth == self.alertWidth ? 0 : buttonWidth
        self.dismissButton.frame = CGRect(x: buttonX, y: yPos, width: buttonWidth, height: self.buttonHeight)
        if self.buttonLabel != nil {
            self.buttonLabel.frame = CGRect(x: self.padding, y: (self.buttonHeight/2) - 15, width: buttonWidth - (self.padding*2), height: 30)
        }
        
        // set button fonts
        if self.buttonLabel != nil {
            buttonLabel.font = UIFont(name: self.buttonFont, size: 20)
        }
        if self.cancelButtonLabel != nil {
            cancelButtonLabel.font = UIFont(name: self.buttonFont, size: 20)
        }
        
        yPos += self.buttonHeight
        
        // size the background view
        self.alertBackgroundView.frame = CGRect(x: 0, y: 0, width: self.alertWidth, height: yPos)
        
        // size the container that holds everything together
        self.containerView.frame = CGRect(x: (self.viewWidth!-self.alertWidth)/2, y: (self.viewHeight! - yPos)/2, width: self.alertWidth, height: yPos)
    }
    
    
    
    func info(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        let alertview = self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x3498db, alpha: 1))
        alertview.setTextTheme(.light)
        return alertview
    }
    
    func success(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        return self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0x2ecc71, alpha: 1))
    }
    
    func warning(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        return self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xf1c40f, alpha: 1))
    }
    
    func danger(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil) -> JSSAlertViewResponder {
        let alertview = self.show(viewController, title: title, text: text, buttonText: buttonText, cancelButtonText: cancelButtonText, color: UIColorFromHex(0xe74c3c, alpha: 1))
        alertview.setTextTheme(.light)
        return alertview
    }
    
    func show(_ viewController: UIViewController, title: String, text: String?=nil, buttonText: String?=nil, cancelButtonText: String?=nil, color: UIColor?=nil, iconImage: UIImage?=nil) -> JSSAlertViewResponder {
        
        self.rootViewController = viewController.view.window!.rootViewController
        self.rootViewController.addChildViewController(self)
        self.rootViewController.view.addSubview(view)
        
        self.view.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)
        
        var baseColor:UIColor?
        if let customColor = color {
            baseColor = customColor
        } else {
            baseColor = self.defaultColor
        }
        let textColor = self.darkTextColor
        
        let sz = self.screenSize()
        self.viewWidth = sz.width
        self.viewHeight = sz.height
        
        self.view.frame.size = sz
        
        // Container for the entire alert modal contents
        self.containerView = UIView()
        self.view.addSubview(self.containerView!)
        
        // Background view/main color
        self.alertBackgroundView = UIView()
        alertBackgroundView.backgroundColor = baseColor
        alertBackgroundView.layer.cornerRadius = 4
        alertBackgroundView.layer.masksToBounds = true
        self.containerView.addSubview(alertBackgroundView!)
        
        // Icon
        self.iconImage = iconImage
        if self.iconImage != nil {
            self.iconImageView = UIImageView(image: self.iconImage)
            self.containerView.addSubview(iconImageView)
        }
        
        // Title
        self.titleLabel = UILabel()
        titleLabel.textColor = textColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: self.titleFont, size: 24)
        titleLabel.text = title
        self.containerView.addSubview(titleLabel)
        
        // View text
        if let text = text {
            self.textView = UITextView()
            self.textView.isUserInteractionEnabled = false
            textView.isEditable = false
            textView.textColor = textColor
            textView.textAlignment = .center
            textView.font = UIFont(name: self.textFont, size: 16)
            textView.backgroundColor = UIColor.clear
            textView.text = text
            self.containerView.addSubview(textView)
        }
        
        // Button
        self.dismissButton = UIButton()
        let buttonColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.8))
        let buttonHighlightColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.9))
        dismissButton.setBackgroundImage(buttonColor, for: UIControlState())
        dismissButton.setBackgroundImage(buttonHighlightColor, for: .highlighted)
        dismissButton.addTarget(self, action: #selector(JSSAlertView.buttonTap), for: .touchUpInside)
        alertBackgroundView!.addSubview(dismissButton)
        // Button text
        self.buttonLabel = UILabel()
        buttonLabel.textColor = textColor
        buttonLabel.numberOfLines = 1
        buttonLabel.textAlignment = .center
        if let text = buttonText {
            buttonLabel.text = text
        } else {
            buttonLabel.text = "OK"
        }
        dismissButton.addSubview(buttonLabel)
        
        // Second cancel button
        if let _ = cancelButtonText {
            self.cancelButton = UIButton()
            let buttonColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.8))
            let buttonHighlightColor = UIImage.withColor(adjustBrightness(baseColor!, amount: 0.9))
            cancelButton.setBackgroundImage(buttonColor, for: UIControlState())
            cancelButton.setBackgroundImage(buttonHighlightColor, for: .highlighted)
            cancelButton.addTarget(self, action: #selector(JSSAlertView.cancelButtonTap), for: .touchUpInside)
            alertBackgroundView!.addSubview(cancelButton)
            // Button text
            self.cancelButtonLabel = UILabel()
            cancelButtonLabel.alpha = 0.7
            cancelButtonLabel.textColor = textColor
            cancelButtonLabel.numberOfLines = 1
            cancelButtonLabel.textAlignment = .center
            if let text = cancelButtonText {
                cancelButtonLabel.text = text
            }
            
            cancelButton.addSubview(cancelButtonLabel)
        }
        
        // Animate it in
        self.view.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1
        })
        self.containerView.frame.origin.x = self.view.center.x
        self.containerView.center.y = -500
        UIView.animate(withDuration: 0.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.containerView.center = self.view.center
            }, completion: { finished in
                
        })
        
        isAlertOpen = true
        return JSSAlertViewResponder(alertview: self)
    }
    
    func addAction(_ action: @escaping ()->Void) {
        self.closeAction = action
    }
    
    func buttonTap() {
        closeView(true, source: .close);
    }
    
    func addCancelAction(_ action: @escaping ()->Void) {
        self.cancelAction = action
    }
    
    func cancelButtonTap() {
        closeView(true, source: .cancel);
    }
    
    func closeView(_ withCallback:Bool, source:ActionType = .close) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.containerView.center.y = self.view.center.y + self.viewHeight!
            }, completion: { finished in
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.alpha = 0
                    }, completion: { finished in
                        if withCallback {
                            if let action = self.closeAction, source == .close {
                                action()
                            }
                            else if let action = self.cancelAction, source == .cancel {
                                action()
                            }
                        }
                        self.removeView()
                })
                
        })
    }
    
    func removeView() {
        isAlertOpen = false
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    
    func screenSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return CGSize(width: screenSize.height, height: screenSize.width)
        }
        return screenSize
    }
    
}





// Utility methods + extensions

// Extend UIImage with a method to create
// a UIImage from a solid color
//
// See: http://stackoverflow.com/questions/20300766/how-to-change-the-highlighted-color-of-a-uibutton
extension UIImage {
    class func withColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// For any hex code 0xXXXXXX and alpha value,
// return a matching UIColor
func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

// For any UIColor and brightness value where darker <1
// and lighter (>1) return an altered UIColor.
//
// See: http://a2apps.com.au/lighten-or-darken-a-uicolor/
func adjustBrightness(_ color:UIColor, amount:CGFloat) -> UIColor {
    var hue:CGFloat = 0
    var saturation:CGFloat = 0
    var brightness:CGFloat = 0
    var alpha:CGFloat = 0
    if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
        brightness += (amount-1.0)
        brightness = max(min(brightness, 1.0), 0.0)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    return color
}
