//
//  NetworkManager.swift
//  CriptoTab
//
//  Created by Bogdan Zykov on 13.03.2023.
//

import Foundation
import Combine


class NetworkingManager{
    
    enum NetworkingError: LocalizedError{
        case badURLResponse(url: URL)
        case unknow
        
        var errorDescription: String?{
            switch self {
            case .badURLResponse(let url):
                return "❌ Bad response from URL \(url)"
            case .unknow:
                return "⚠️ Unknow error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { try handleURLResponse(output: $0, url: url)}
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else{
                  throw NetworkingError.badURLResponse(url: url)
              }
        return output.data
    }
    
    static func handlingCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
