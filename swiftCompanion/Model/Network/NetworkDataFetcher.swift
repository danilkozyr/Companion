//
//  NetworkDataFetcher.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 9/12/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias DataFetchHandler<T> = (T?, Error?) -> Void
typealias Parameters = [String: Any]

class NetworkDataFetcher {
    
    var networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchData<T: Decodable>(urlString: String, token: String, completion: @escaping DataFetchHandler<T>) {
        networkService.request(urlString: urlString, token: token) { (data, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            let decoded = DecoderJSON().decode(type: T.self, data: data)
            completion(decoded, nil)
        }
    }
    
    func fetchToken(urlString: String, parameters: [String: Any], completion: @escaping (Token?, Error?) -> Void) {
        
        networkService.authorize(urlString: urlString, parameters: parameters) { (data, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            let decoded = DecoderJSON().decode(type: Token.self, data: data)
            completion(decoded, nil)

        }
    }
}
