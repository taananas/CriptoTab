//
//  CoinService+URLSessionWebSocketDelegate.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 12.03.2023.
//

import Foundation
import Network


extension CoinWebSocketService: URLSessionWebSocketDelegate{
    


    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.connectionStateSubject.send(true)
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.connectionStateSubject.send(false)
    }
}
