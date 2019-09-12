//
//  NetworkService.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 9/12/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    
    func request(urlString: String, token: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let header: HTTPHeaders = ["Authorization": "Bearer " + token]
        
        Alamofire.request(url, headers: header).response { response in
            DispatchQueue.main.async {
                completion(response.data, response.error)
            }
        }
    }
    

    
    func authorize(urlString: String, parameters: [String: Any], completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            DispatchQueue.main.async {
                completion(response.data, response.error)
            }
        }
    }
    
    
}
