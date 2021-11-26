//
//  RoundedImageView.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 26/11/21.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {
    
    @IBInspectable var borderWidth: CGFloat = 0.05
    @IBInspectable var borderColor: UIColor = UIColor.black

    override func layoutSubviews() {
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }

}
