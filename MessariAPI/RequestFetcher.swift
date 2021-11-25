//
//  RequestFetcher.swift
//  MessariAPI
//
//  Created by Lorenzo Limoli on 25/11/21.
//

import Foundation

private struct CoinMarketData: Decodable{
    var price_usd: Double
    var percent_change_usd_last_24_hours: Double
}

private struct CoinMetrics: Decodable{
    var market_data: CoinMarketData
}

private struct MessariCoin: Decodable{
    var slug: String
    var symbol: String
    var metrics: CoinMetrics
}

private struct MessariApiResponse: Decodable{
    var data: [MessariCoin]
}

public class RequestFetcher{
    
    public static func fetchLogo(ofCoin coin: Coin, completion: @escaping (Data?, URLResponse?, Error?) -> ()){
        let coinName = coin.name.lowercased().replacingOccurrences(of: "\\s+", with: "-")
        guard let url = URL(string: "https://cryptologos.cc/logos/\(coinName)-\(coin.ticker.lowercased())-logo.png") else{
            fatalError("Wrong URL")
        }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public static func fetchTopGainers(completion: @escaping ([Coin]) -> ()){
        guard let url = URL(string: "https://data.messari.io/api/v2/assets?fields=slug,symbol,metrics/market_data&limit=5") else{
            fatalError("Wrong URL")
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            if let jsonData = try? JSONDecoder().decode(MessariApiResponse.self, from: data){
                let coins: [Coin] = jsonData.data.map{Coin(name: $0.slug, ticker: $0.symbol, price: $0.metrics.market_data.price_usd, gain24h: $0.metrics.market_data.percent_change_usd_last_24_hours)}
                    .sorted{$0.gain24h > $1.gain24h}
                completion(coins)
                return
            }
            
            completion([])
            
        }
        
        task.resume()
    }
}
