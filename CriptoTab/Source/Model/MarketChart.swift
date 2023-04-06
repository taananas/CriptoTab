//
//  MarketChart.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 13.03.2023.
//

import Foundation

struct MarketChart: Codable {
    
    var prices: [[Double]]
    
    
    var coinPrices: [Double]{
        prices.compactMap({$0[1]})
    }
    
    var priceChange: Double{
        (coinPrices.last ?? 0) - (coinPrices.first ?? 0)
    }
    
    var isIncreasedPrice: Bool{
        priceChange > 0
    }
}



