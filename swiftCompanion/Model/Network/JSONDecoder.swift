//
//  JSONDecoder.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 9/12/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

class DecoderJSON {
    
    func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(T.self, from: data)
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
}

