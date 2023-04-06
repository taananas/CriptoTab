//
//  PopoverViewModel.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import Foundation
import Combine
import SwiftUI

final class PopoverViewModel: ObservableObject{

    @Published private(set) var selectedCoin: CoinModel?
    @Published private(set) var topCoins = [CoinModel]()
    @AppStorage("selectedCoinId") var selectedCoinId: String = "bitcoin"
    @Published var isLoading: Bool = true
    
    private let wsService: CoinWebSocketService
    private let coinDataService: CoinDataService
    private var cancellable = Set<AnyCancellable>()
    
    
    init(
        wsService: CoinWebSocketService = .init(),
        coinDataService: CoinDataService = .init()) {
            self.wsService = wsService
            self.coinDataService = coinDataService
        }
    
    func subscribeToWebSocket(){
        wsService.coinDictionarySubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.updateSelectedCoin()
            }
            .store(in: &cancellable)
    }
    
    func selectCoin(_ coin: CoinModel){
        selectedCoinId = coin.id
        selectedCoin = coin
        wsService.setCoinAndConnect(with: coin)
    }
    
   private func updateSelectedCoin(){
        guard let selectedCoin else { return }
        let coin = self.wsService.coinDictionary[selectedCoin.id]
        if let coin{
            self.selectedCoin?.currentPrice = coin.value
        }
    }
}

extension PopoverViewModel{
    
    func startCoinDataSubscription(){
        coinDataService.$allCoins
            .sink {[weak self] coins in
                guard let self = self else {return}
                self.selectedCoin = coins.first(where: {$0.id == self.selectedCoinId})
                self.topCoins = coins
                self.isLoading = false
            }
            .store(in: &cancellable)
    }
}
