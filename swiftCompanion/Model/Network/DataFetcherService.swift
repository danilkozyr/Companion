//
//  DataFetcherService.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 9/12/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

class DataFetcherService {
    
    var networkDataFetcher: NetworkDataFetcher!
    
    init(networkDataFetcher: NetworkDataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    func fetchUser(login: String, token: String, completion: @escaping (User?, Error?) -> Void) {
        let url = "https://api.intra.42.fr/v2/users/" + login
        networkDataFetcher.fetchData(urlString: url, token: token, completion: completion)
    }
    
    func fetchLocations(user: User, token: String, completion: @escaping ([Location]?, Error?) -> Void) {
        let url = "https://api.intra.42.fr/v2/users/\(user.id)/locations?sort=-end_at"
        networkDataFetcher.fetchData(urlString: url, token: token, completion: completion)
    }

    
    func fetchToken(completion: @escaping (Token?, Error?) -> Void) {
        let url = "https://api.intra.42.fr/oauth/token"
        let parameters = ["grant_type" : "client_credentials",
                          "client_id" : Token.client_id,
                          "client_secret" : Token.client_secret]
        networkDataFetcher.fetchToken(urlString: url, parameters: parameters, completion: completion)
    }
    
}
