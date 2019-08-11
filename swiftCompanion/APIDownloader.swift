//
//  APIDownloader.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/15/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIDownloader {

    enum Response {
        case success(Any)
        case error(String)
    }
    
    func authorizeApplication(failure: @escaping (String) -> Void ) {
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else {
            failure("Error")
            return
        }
        
        let parameters =  ["grant_type" : "client_credentials",
                           "client_id" : APIData.client_id,
                           "client_secret" : APIData.client_secret]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            if response.error != nil {
                failure("Check Internet Connection")
                return
            }
            
            switch response.result {
            case .success(let responseDictionary):
                let json = JSON(responseDictionary)
                APIData.token = json["access_token"].string!
            case .failure(_):
                failure("Error Occured")
                return
            }
        })
    }

    func downloadUser(with login: String, completion: @escaping (Response) -> Void) {
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/" + login) else {
            completion(.error("You have used restricted symbols/language!"))
            return
        }
        let header: HTTPHeaders = ["Authorization":  "Bearer " + APIData.token]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.error != nil {
                completion(.error("Check Internet Connection"))
                return
            }
            
            switch response.result {
            case .success(let dictionary):
                
                let json = JSON(dictionary)
                guard json != [:] else {
                    completion(.error("Invalid login. Try again later"))
                    return
                }


                if var user = self.unparseJSON(json: json, with: login) {
        
                    self.downloadProjects(with: user.id, completion: { (response) in
                        switch response {
                        case .success(let downloadedData):
                            let projects = downloadedData as! [Project]
                            user.projects = projects
                            completion(.success(user))
                        case .error(let error):
                            completion(.error(error))
                            return
                        }
                    })
                    
                } else {
                    completion(.error("User did not pass the pool"))
                }
                
            case .failure(_):
                completion(.error("Error Occured"))
                return
            }
        }
        
    }

    
    private func downloadProjects(with userId: Int, completion: @escaping (Response) -> Void) {

        guard let url = URL(string: "https://api.intra.42.fr/v2/projects_users?user_id=\(userId)&page[size]=100") else {
            completion(.error("You have used restricted symbols/language!"))
            return
        }
        let header: HTTPHeaders = ["Authorization":  "Bearer " + APIData.token]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.error != nil {
                completion(.error("Check Internet Connection"))
                return
            }
            
            var projects: [Project] = []
            switch response.result {
            case .success(let data):
                guard let json = JSON(data).array else { return }
                for item in json {
                    guard let cursus_ids = item["cursus_ids"].array else { return }
                    if cursus_ids.contains(1) {
                        guard let name = item["project"]["name"].string else { return }
                        
                        if name != "Rushes" && item["project"]["parent_id"].null != nil {
                            let grade = item["final_mark"].number?.stringValue
                            projects.append(Project(name: name, grade: grade))
                        }
                    }
                }
                completion(.success(projects))
            case .failure(_):
                completion(.error("Error Occured"))
                return
            }
        }

    }

    private func unparseJSON(json: JSON, with login: String) -> User? {
        guard let id = json["id"].int else { return nil }
        guard let firstName = json["first_name"].string else { return nil }
        guard let lastName = json["last_name"].string  else { return nil }
        
        
        guard let email = json["email"].string  else { return nil }
        guard let image_url = json["image_url"].string  else { return nil }

        guard let correction_point = json["correction_point"].int  else { return nil }
        guard let wallet = json["wallet"].int  else { return nil }

        var poolDate: String = ""

        guard let poolMonth = json["pool_month"].string, let poolYear = json["pool_year"].string else { return nil }
        
        poolDate = poolMonth + " " + poolYear

        var phone = json["phone"].string
        if phone == nil {
            phone = "Unknown"
        }
        
        var place = json["location"].string

        guard let city = json["campus"][0]["city"].string, let country = json["campus"][0]["country"].string else {
            return nil
        }
        let location = city + " " + country

        guard let cursus_users = json["cursus_users"].array else { return nil }
        var level = ""
        var skills: [Skill] = []
        for cursus in cursus_users {
            if (cursus["cursus_id"].int == 1) {
                guard let skillsFromJson = cursus["skills"].array else { return nil }
                for skill in skillsFromJson {
                    guard let name = skill["name"].string else { return nil }
                    guard let level = skill["level"].number?.doubleValue.roundDouble else { return nil }
                    guard let id = skill["id"].number?.intValue else { return nil }
                    skills.append(Skill(id: id, name: name, level: level))
                }
                level = cursus["level"].number!.doubleValue.roundDouble
            }
        }

        if skills.isEmpty {
            return nil
        }

        if place == nil {
            // TODO: Download last location
            //            downloadLastLocation(with id: id, )
            place = "Unavailable"
        }

        let user = User(id: id,
                         login: login,
                         firstName: firstName,
                         lastName: lastName,
                         email: email,
                         imageUrl: image_url,
                         poolDate: poolDate,
                         phone: phone!,
                         place: place!,
                         level: level,
                         correctionPoints: correction_point,
                         wallet: wallet,
                         location: location,
                         skills: skills,
                         projects: nil)

        return user
    }
    
}
