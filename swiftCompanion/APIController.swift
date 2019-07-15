//
//  APIController.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/15/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation


//class APIController {
//    
//    typealias TokenReturnableHandler = (_ token: String) -> Void
//    
//    func authorizeApplication(handler: @escaping TokenReturnableHandler) {
//        var token: String = ""
//        let url = URL(string: "https://api.intra.42.fr/oauth/token")!
//        let grant_type = "grant_type=client_credentials"
//        let uid = "client_id=\(client_id)"
//        let secret = "client_secret=\(client_secret)"
//        let requestString = grant_type + "&" + uid + "&" + secret
//        var request = URLRequest(url: url)
//        
//        request.httpMethod = "POST"
//        request.httpBody = requestString.data(using: String.Encoding.utf8)
//        
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print("authorizeApplication Error")
//                return
//            }
//            
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                token = json["access_token"] as! String
//                handler(token)
//            } else {
//                print("authorizeApplication JSON fail")
//            }
//            
//            }.resume()
//    }
//    
//    
//    
//}
