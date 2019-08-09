//
//  APIDownloader.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/15/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation


class APIDownloader {

    func authorizeApplication(failure: @escaping (String) -> Void ) {
        var urlComponents = URLComponents(string: "https://api.intra.42.fr/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials"),
            URLQueryItem(name: "client_id", value: APIData.client_id),
            URLQueryItem(name: "client_secret", value: APIData.client_secret)
        ]
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                failure("Settings -> Companion -> Use Cellular Data or connect to wifi and reload the app.")
                return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                failure("Settings -> Companion -> Use Cellular Data or connect to wifi and reload the app.")
                return
            }
            
            APIData.token = json["access_token"] as! String
        }.resume()
    }

    func downloadUser(with login: String, success: @escaping (User) -> Void, failure: @escaping (String) -> Void) {
        let url = URL(string: "https://api.intra.42.fr/v2/users/" + login)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + APIData.token, forHTTPHeaderField: "Authorization")


        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                failure("downloadUser Error")
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                guard json != [:] else {
                    failure("Invalid login. Try again later")
                    return
                }
                
                self.downloadProjects(with: json.value(forKey: "id") as! Int, callBack: { (projects) in
                    let user = self.unparseJSON(json: json, with: login, with: projects!)
                    if user != nil {
                        success(user!)
                    } else {
                        failure("User did not pass the pool")
                    }
                }, failure: { (error) in
                    failure(error)
                })


            } else {
                failure("downloadUser JSON fail")
            }

        }.resume()
    }

    
    private func downloadProjects(with userId: Int, callBack: @escaping ([Project]?) -> (), failure: @escaping (String) -> ()) {
        var projects: [Project] = []
        let url = URL(string: "https://api.intra.42.fr/v2/projects_users?user_id=\(userId)&page[size]=100")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer " + APIData.token, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                failure("downloadProjects error")
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] {
                for item in json {
                    let cursus_ids = item["cursus_ids"] as? NSArray
                    if (cursus_ids?.contains(1))! {
                        let projectDetails = item["project"] as? NSDictionary
                        let name = projectDetails!["name"] as! String

                        if name != "Rushes" && projectDetails!["parent_id"] as? NSNull != nil {
                            let grade = (item["final_mark"] as? NSNumber)?.stringValue

                            projects.append(Project(name: name, grade: grade))
                        }

                    }

                }
                callBack(projects)
            } else {
                failure("downloadPorjects() json fail")
            }
        }.resume()

    }

    private func unparseJSON(json: NSDictionary, with login: String, with projects: [Project]) -> User? {
        let id = json.value(forKey: "id") as! Int
        let firstName = json["first_name"] as! String
        let lastName = json["last_name"] as! String
        let email = json["email"] as! String
        let image_url = json["image_url"] as! String

        let correction_point = json.value(forKey: "correction_point") as! Int
        let wallet = json.value(forKey: "wallet") as! Int

        var poolDate: String = ""
        
        if let poolMonth = json["pool_month"] as? String, let poolYear = json["pool_year"] as? String {
            poolDate = poolMonth + " " + poolYear
        } else {
            poolDate = "Admin"
        }
        

        var phone = json["phone"]
        if phone as? String == nil {
            phone = "Unknown"
        }

        var place = json["location"]
        if place as? String == nil {
            place = "Unavailable"
        }

        let campus = json["campus"] as? [NSDictionary]
        var location = ""
        for camp in campus! {
            let city = camp["city"] as! String
            let country = camp["country"] as! String
            location = city + ", " + country
        }


        let cursus_users = json["cursus_users"] as? [NSDictionary]
        var level = ""
        var skills: [Skill] = []
        for cursus in cursus_users! {
            if (cursus["cursus_id"] as! Int == 1) {
                let skillsFromJson = cursus["skills"] as? [NSDictionary]
                for skill in skillsFromJson! {
                    let name = skill["name"] as! String
                    let level = (skill["level"] as! NSNumber).doubleValue.roundDouble
                    let id = skill["id"] as! NSNumber
                    skills.append(Skill(id: Int(truncating: id), name: name, level: level))
                }
                level = (cursus["level"] as! NSNumber).doubleValue.roundDouble
            }
        }

        if skills.isEmpty {
            return nil
        }
        
        let user = User(id: id,
                         login: login,
                         firstName: firstName,
                         lastName: lastName,
                         email: email,
                         imageUrl: image_url,
                         poolDate: poolDate,
                         phone: phone as! String,
                         place: place as! String,
                         level: level,
                         correctionPoints: correction_point,
                         wallet: wallet,
                         location: location,
                         skills: skills,
                         projects: projects)
        
        return user
    }
    
}
