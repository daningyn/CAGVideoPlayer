//
//  UIKitExtension.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/13/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientBackground(from colorOne: UIColor, to colorTwo: UIColor) {
        if self.layer.sublayers?.first as? CAGradientLayer != nil {
            self.layer.sublayers?.first?.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    
    convenience init(absoluteRed red: Int, green: Int, blue: Int, alpha: Int = 255) {
        let normalizedRed = CGFloat(red) / 255.0
        let normalizedGreen = CGFloat(green) / 255.0
        let normalizedBlue = CGFloat(blue) / 255.0
        let normalizedAlpha = CGFloat(alpha) / 255.0
        
        self.init(
            red: normalizedRed,
            green: normalizedGreen,
            blue: normalizedBlue,
            alpha: normalizedAlpha
        )
    }
    
    convenience init(hex: Int) {
        self.init(
            absoluteRed: (hex >> 16) & 0xff,
            green: (hex >> 8) & 0xff,
            blue: hex & 0xff
        )
    }
    
    convenience init(hexString: String) {
        var normalizedHexString = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        if normalizedHexString.hasPrefix("#") {
            normalizedHexString.remove(at: normalizedHexString.startIndex)
        }
        
        // Convert to hexadecimal integer
        var hexValue: UInt32 = 0
        Scanner(string: normalizedHexString).scanHexInt32(&hexValue)
        
        self.init(
            hex: Int(hexValue)
        )
    }
}
