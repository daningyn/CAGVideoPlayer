//
//  RPProgressView.swift
//  RPVideoPlayer
//
//  Created by Rin Pham on 12/14/17.
//  Copyright © 2017 Rin Pham. All rights reserved.
//

import UIKit

class CustomSliderView: UISlider {
    
    open var gradientLayer = CAGradientLayer()
    
    private var gradientColorDefault = [UIColor(hexString:"#4cd964").cgColor, UIColor(hexString:"#5ac8fa").cgColor]
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 6
         self.gradientLayer.frame = newBounds
        return newBounds
    }
    
    
    private func setup() {
        self.setThumbImage(#imageLiteral(resourceName: "thumb_slider"), for: .highlighted)
        self.tintColor = UIColor.clear
        
        self.setupGradientLayer()
        self.layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    private func setupGradientLayer() {
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.frame.size.height = 6
        self.gradientLayer.cornerRadius = 3
        
        self.gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.position = CGPoint(x: 0, y: 0)
        self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        if self.gradientLayer.colors == nil {
            self.gradientLayer.colors = self.gradientColorDefault
        }
    }
}
