//
//  Coin.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 24/11/21.
//

import Foundation

public struct Coin{
    public var name: String
    public var ticker: String
    public var price: Double
    public var gain24h: Double
    
    public init(name: String, ticker: String, price: Double, gain24h: Double){
        self.name = name.capitalized
        self.ticker = ticker.uppercased()
        self.price = price
        self.gain24h = gain24h
    }
}
