//
//  CoinTableViewCellProtocol.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 25/11/21.
//

import Foundation
import UIKit
import MessariAPI

protocol CoinTableViewCellProtocol: AnyObject{
    var name: UILabel! {get set}
    var ticker: UILabel! {get set}
    var price: UILabel! {get set}
    var gain24h: UILabel! {get set}
    var icon: UIImageView! {get set}
    
    func downloadIcon(ofCoin coin: Coin)
}


extension CoinTableViewCellProtocol{
    
    func downloadIcon(ofCoin coin: Coin){
        CoinFetcher.shared.fetchLogo(ofCoin: coin) { data in
    
            DispatchQueue.main.async() { [weak self] in
                if let data = data{
                    self?.icon.image = UIImage(data: data) ?? UIImage(systemName: "bitcoinsign.circle.fill")
                }else{
                    self?.icon.image = UIImage(systemName: "bitcoinsign.circle.fill")
                }
                
                self?.icon.isHidden = false
            }
        }
    }
    
    func set(from coin: Coin){
        icon.isHidden = true
        name.text = coin.name
        ticker.text = coin.ticker
        
        downloadIcon(ofCoin: coin)
        
        price.text = coin.priceString
        gain24h.text = coin.gain24hString
        gain24h.textColor = getColor(for: coin.gain24h)
    }
    
    private func getColor(for gain24h: Double) -> UIColor?{
        return gain24h > 0 ? UIColor(named: "Success") : UIColor(named: "Danger")
    }
}
