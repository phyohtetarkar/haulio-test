//
//  HButton.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import UIKit

class HButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 3
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.2
    @IBInspectable var shadowRadius: CGFloat = 1

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private lazy var shadowLayer: CAShapeLayer = {
        let shadowShapeLayer = CAShapeLayer()
        shadowShapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowShapeLayer.fillColor = backgroundColor?.cgColor
        
        shadowShapeLayer.shadowColor = shadowColor?.cgColor
        shadowShapeLayer.shadowPath = shadowShapeLayer.path
        shadowShapeLayer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        shadowShapeLayer.shadowOpacity = shadowOpacity
        shadowShapeLayer.shadowRadius = shadowRadius
        shadowShapeLayer.shouldRasterize = true
        shadowShapeLayer.rasterizationScale = UIScreen.main.scale
        
        return shadowShapeLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = cornerRadius
        
        if let sl = layer.sublayers, !sl.contains(shadowLayer) {
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
    }

}
