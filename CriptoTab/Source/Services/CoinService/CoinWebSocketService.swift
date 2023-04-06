//
//  CoinWebSocketService.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import Combine
import Foundation
import Network

final class CoinWebSocketService: NSObject{
    
    
    let coinDictionarySubject = CurrentValueSubject<[String: WsCoin], Never>([:])
    var coinDictionary: [String: WsCoin] { coinDictionarySubject.value }
    let connectionStateSubject = CurrentValueSubject<Bool, Never>(false)
    var isConnected: Bool { connectionStateSubject.value }
    var lastCoinId: String?
    
    private let session = URLSession(configuration: .default)
    private var wsTask: URLSessionWebSocketTask?
    private var pingTryCount = 0
    private let monitor = NWPathMonitor()
    

    
    deinit{
        connectionStateSubject.send(completion: .finished)
        coinDictionarySubject.send(completion: .finished)
    }
}


extension CoinWebSocketService{
    
    func connect(with id: String){
        let url = URL(string: "wss://ws.coincap.io/prices?assets=\(id)")!
        lastCoinId = id
        wsTask = session.webSocketTask(with: url)
        wsTask?.delegate = self
        wsTask?.resume()
        receivMessage()
        shedulePing()
    }
    
    func setCoinAndConnect(with coin: CoinModel){
        clearConnection()
        coinDictionarySubject.send([coin.id: .init(name: coin.symbol, value: coin.currentPrice)])
        connect(with: coin.id)
    }
    
    
    func receivMessage(){
        wsTask?.receive{[weak self] result in
            guard let self = self else {return}
            switch result{
                
            case .success(let message):
                
                switch message{
                case .data(let data):
                    print("data message \(data)")
                    self.onReceiveData(data)
                case .string(let text):
                    print("text message \(text)")
                    if let data = text.data(using: .utf8){
                        self.onReceiveData(data)
                    }
                @unknown default: break
                }
                
                self.receivMessage()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func startNetworkMonitor(){
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            if let lastCoinId = self.lastCoinId, path.status == .satisfied, self.wsTask == nil{
                self.connect(with: lastCoinId)
            }
            
            if path.status != .satisfied{
                self.clearConnection()
            }
        }
        monitor.start(queue: DispatchQueue(label: "CriptoTab.NWPathMonitor"))
    }
    
    private func onReceiveData(_ data: Data){
        guard let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            return
        }
        var newDictionary = [String: WsCoin]()
        dictionary.forEach { (key, value) in
            let value = Double(value) ?? 0
            newDictionary[key] = WsCoin(name: key.capitalized, value: value)
        }
        
        let mergeDictionary = coinDictionary.merging(newDictionary){ $1 }
        coinDictionarySubject.send(mergeDictionary)
    }
    
    func clearConnection(){
        wsTask?.cancel()
        wsTask = nil
        pingTryCount = 0
        self.connectionStateSubject.send(false)
    }
}




extension CoinWebSocketService{
    private func shedulePing(){
        let taskId = self.wsTask?.taskIdentifier ?? -1
        DispatchQueue.main.asyncAfter(deadline: .now() + 10){ [weak self] in
            guard let self = self, let task = self.wsTask, task.taskIdentifier == taskId else {return}
            if task.state == .running, self.pingTryCount < 2{
                self.pingTryCount += 1
                print("Send ping \(self.pingTryCount)")
                task.sendPing {[weak self] error in
                    guard let self = self else {return}
                    if let error{
                        print("ping failed", error.localizedDescription)
                    }else if self.wsTask?.taskIdentifier == taskId{
                        self.pingTryCount = 0
                    }
                }
                self.shedulePing()
            }else{
                self.reconnect()
            }
        }
    }
    
    private func reconnect(){
        clearConnection()
        if let lastCoinId{
            connect(with: lastCoinId)
        }
    }    
}

