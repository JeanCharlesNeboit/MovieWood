//
//  Utilities.swift
//  MovieWood
//
//  Created by Jean-Charles NEBOIT on 29/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

// MARK: - CALayer
extension CALayer {
    
    func colorOfPoint(point:CGPoint) -> UIColor {
        
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        self.render(in: context!)
        
        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0
        
        return UIColor(red:red, green: green, blue:blue, alpha:alpha)
    }
}

// MARK: - UIStatusBarStyle
extension UIStatusBarStyle {
    
    static func adaptiveStyle(with layer: CALayer, completionHandler: @escaping (UIStatusBarStyle) -> Void) {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        DispatchQueue.global().async {
            var pixel: CGFloat = 0
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            for i in stride(from: Int(statusBarFrame.origin.x), to: Int(statusBarFrame.size.width), by: Int(statusBarFrame.size.width)/5) {
                for j in Int(statusBarFrame.origin.y) ..< Int(statusBarFrame.size.height) {
                    let color = layer.colorOfPoint(point: CGPoint(x: i, y: j))
                    pixel = pixel + 1
                    red = red + (color.cgColor.components?[0] ?? 0)
                    green = green + (color.cgColor.components?[1] ?? 0)
                    blue = blue + (color.cgColor.components?[2] ?? 0)
                    alpha = alpha + color.cgColor.alpha
                }
            }
            red = red/pixel
            green = green/pixel
            blue = blue/pixel
            alpha = alpha/pixel
            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            let white: UnsafeMutablePointer<CGFloat>? = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
            color.getWhite(white, alpha: nil)
            var style: UIStatusBarStyle = .default
            if let white = white?.pointee {
                if white < 0.5 {
                    style = .lightContent
                }
            }
            white?.deallocate()
            DispatchQueue.main.async {
                completionHandler(style)
            }
        }
    }
}

// MARK: - UIView
@IBDesignable extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

// MARK: - UINavigationController
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

// MARK: - String
extension String {
    
    var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }
    
    var deletePathComponent: String {
        return NSString(string: self).deletingPathExtension
    }
}


