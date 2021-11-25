//
//  CoinTableViewCellProtocol.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 25/11/21.
//

import Foundation
import UIKit

protocol CoinTableViewCellProtocol{
    var name: UILabel! {get set}
    var ticker: UILabel! {get set}
    var price: UILabel! {get set}
    var gain24h: UILabel! {get set}
    var icon: UIImageView! {get set}
}


extension TopGainerTableViewCell{
    func set(from coin: Coin){
        name.text = coin.name
        ticker.text = coin.ticker
        price.text = coin.priceString
        gain24h.text = coin.gain24hString
        gain24h.textColor = getColor(for: coin.gain24h)
        icon.image = coin.icon
    }
    
    private func getColor(for gain24h: Double) -> UIColor?{
        return gain24h > 0 ? UIColor(named: "Success") : UIColor(named: "Danger")
    }
}
