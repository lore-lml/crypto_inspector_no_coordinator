//
//  TopGainerTableViewCell.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 25/11/21.
//

import UIKit

class TopGainerTableViewCell: UITableViewCell, CoinTableViewCellProtocol {

    static let nibId: String = "TopGainerTableViewCell"
    static let cellId: String = "topGainerCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var gain24h: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var alert: UIImageView!
}
