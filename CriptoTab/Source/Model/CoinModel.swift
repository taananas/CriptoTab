//
//  CoinModel.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 13.03.2023.
//

import Foundation


struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    var currentPrice: Double
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let lastUpdated: String?
    var sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
        
    var isIncreasedPrice: Bool{
        (priceChangePercentage24H ?? 0) > 0
    }
    

}

struct SparklineIn7D: Codable {
    var price: [Double]?
}

