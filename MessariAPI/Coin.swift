//
//  Coin.swift
//  CryptoInspectorNoCoordinator
//
//  Created by Lorenzo Limoli on 24/11/21.
//

import Foundation

public struct Coin: Codable{
    public var name: String
    public var ticker: String
    public var price: Double
    public var gain24h: Double
    
    public init(name: String, ticker: String, price: Double, gain24h: Double){
        self.name = name.capitalized.replacingOccurrences(of: "-", with: " ")
        self.ticker = ticker.uppercased()
        self.price = price
        self.gain24h = gain24h
    }
    
    public var priceString: String{
        let precision = price < 1 ? 4:2
        var doubleString = String(format: "%.\(precision)f", price).replacingOccurrences(of: ".", with: ",")
        let numberOfIntegerDigit: Int = doubleString.count - (precision+1)
        if numberOfIntegerDigit < 3{
            return "$ \(doubleString)"
        }
//        let additionalSeparator = numberOfIntegerDigit % 3 == 0 ? 0:1
//        var numberOfSeparator: Int = (numberOfIntegerDigit / 3) - 1 + (additionalSeparator)
        
        for index in stride(from: 3, to: numberOfIntegerDigit, by: 3){
            let stringIndex = doubleString.index(doubleString.endIndex, offsetBy: -(index+3))
            doubleString.insert(".", at: stringIndex)
        }
        
        return "$ \(doubleString)"
    }
    
    public var gain24hString: String{
        let doubleString = String(format: "%.2f", gain24h).replacingOccurrences(of: ".", with: ",")
        let sign = gain24h > 0 ? "+":""
        return "\(sign)\(doubleString) %"
    }
}


