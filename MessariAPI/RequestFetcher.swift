//
//  RequestFetcher.swift
//  MessariAPI
//
//  Created by Lorenzo Limoli on 25/11/21.
//

import Foundation
import UIKit

private struct CoinMarketData: Decodable{
    var price_usd: Double?
    var percent_change_usd_last_24_hours: Double?
}

private struct CoinMetrics: Decodable{
    var market_data: CoinMarketData
}

private struct MessariCoin: Decodable{
    var slug: String?
    var symbol: String?
    var metrics: CoinMetrics?
    
    var plainCoin: Coin?{
        guard let name = slug,
              let ticker = symbol,
              let price = metrics?.market_data.price_usd,
              let gain24h = metrics?.market_data.percent_change_usd_last_24_hours
        else{
            return nil
        }
        
        return Coin(name: name, ticker: ticker, price: price, gain24h: gain24h)
    }
}

private struct MessariApiResponse: Decodable{
    var data: [MessariCoin]
}

public class CoinFetcher{
    
    private var logos: [String:Data]
    private var coins: [Coin]
    private var lastFetchingTime: Int?
    
    private init(){
        logos = [:]
        coins = []
    }
    
    public static let shared = CoinFetcher()
    
    
    public func fetchLogo(ofCoin coin: Coin, completion: @escaping (Data?) -> ()){
        
        if let logo = logos[coin.ticker]{
            DispatchQueue.global().async {
                completion(logo)
            }
            return
        }
        
        let coinName = coin.name.lowercased().replacingOccurrences(of: "\\s+", with: "-")
        guard let url = URL(string: "https://cryptologos.cc/logos/\(coinName)-\(coin.ticker.lowercased())-logo.png") else{
            fatalError("Wrong URL")
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else{
                completion(nil)
                return
            }
            self?.logos[coin.ticker] = data
            completion(data)
        }.resume()
    }
    
    public func fetchCoinInfo(limit: Int?, completion: @escaping ([Coin]) -> ()){
        
        if !coins.isEmpty {
            var trueLimit: Int
            if let limit = limit, limit < coins.count{
                trueLimit = limit
            }else{
                trueLimit = coins.count
            }
            
            DispatchQueue.global().async { [weak self] in
                guard let coins = self?.coins else{
                    return
                }
                if trueLimit == self?.coins.count{
                    completion(coins)
                    return
                }
                completion(Array(coins[0..<trueLimit]))
            }
            return
        }
        
        guard let url = URL(string: "https://data.messari.io/api/v2/assets?fields=slug,symbol,metrics/market_data&limit=200") else{
            fatalError("Wrong URL")
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do{
                
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MessariApiResponse.self, from: data)
        
                let coins: [Coin] = jsonData.data.compactMap{$0.plainCoin}
                    .sorted{$0.gain24h > $1.gain24h}
                
                if let limit = limit, limit < coins.count{
                    completion(Array(coins[0..<limit]))
                    self?.coins = coins
                    self?.lastFetchingTime = Int(Date().timeIntervalSince1970)
                    return
                }
                
                completion(coins)

            }catch let e{
                print("DECODING JSON COINS")
                print(e)
                completion([])
            }
        }
        
        task.resume()
    }
}
