//
//  MenuBarViewModel.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import Foundation
import SwiftUI
import Combine

final class MenuBarCoinViewModel: ObservableObject{
    
    @Published private(set) var name: String
    @Published private(set) var value: String
    @Published private(set) var color: Color
    @AppStorage("selectedCoinId") private(set) var selectedCoinId: String = "bitcoin"
    
    private let service: CoinWebSocketService
    private var cancellable = Set<AnyCancellable>()
    
    
    init(name: String = "", value: String = "", color: Color = .green, service: CoinWebSocketService = .init()) {
        self.name = name
        self.value = value
        self.color = color
        self.service = service
        
        subscribeToService()
    }
    
    
    private func subscribeToService(){
        service.coinDictionarySubject
            .combineLatest(service.connectionStateSubject)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.updateView()
            }
            .store(in: &cancellable)
    }
    
    
    func updateView(){
        let coin = self.service.coinDictionary[selectedCoinId]
        self.name = coin?.name ?? ""
        if service.isConnected{
            if let coin{
                self.value = coin.value.asCurrencyWith2Decimals()
            }else{
                self.value = "Updating..."
            }
        }else{
            self.value = "Offline"
        }
        self.color = service.isConnected ? .green : .red
    }
}
