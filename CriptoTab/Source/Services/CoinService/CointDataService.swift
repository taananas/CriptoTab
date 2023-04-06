//
//  CointDataService.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 13.03.2023.
//

import Foundation
import Combine

class CoinDataService{
    
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }
    
    func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=true&price_change_percentage=24h") else {return}
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handlingCompletion, receiveValue: { [weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
            })
    }
    
    
    func fetchMarketData(for id: String) -> AnyPublisher<MarketChart, Error>{
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)/market_chart?vs_currency=usd&days=1") else{return Fail(error: NetworkingManager.NetworkingError.unknow).eraseToAnyPublisher()}
       return NetworkingManager.download(url: url)
            .decode(type: MarketChart.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
