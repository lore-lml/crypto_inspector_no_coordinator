//
//  CoinTableViewCell.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 24/11/21.
//

import UIKit

class WatchListTableViewCell: UITableViewCell, CoinTableViewCellProtocol {
    
    static let nibId: String = "WatchListTableViewCell"
    static let cellId: String = "watchlistCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var gain24h: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
}

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
}
