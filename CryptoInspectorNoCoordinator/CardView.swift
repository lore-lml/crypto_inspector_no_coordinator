//
//  CardView.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 26/11/21.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var shadowOffsetWidth: CGFloat = 0
    @IBInspectable var shadowOffsetHeight: CGFloat = 5
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOpacity: CGFloat = 0.5
    @IBInspectable var isRounded: Bool = false
    
    override func layoutSubviews() {
        let cRadius = isRounded ? frame.height/2 : cornerRadius
        layer.cornerRadius = cRadius
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cRadius)
        layer.shadowPath = shadowPath.cgPath
        
    }

}
