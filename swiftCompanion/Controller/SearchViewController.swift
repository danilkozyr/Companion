//
//  ViewController.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

let client_id: String = "dbca5241fdb6c9a667455675619a0d57fa51c7ba40b6830809583391331c8531"
let client_secret: String = "dfe4854420649742f35b472bd112a83b1b794b9ebf1611fec4f202825127bd49"
var token: String = ""

class SearchViewController: UIViewController {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func searchButtonClicked(_ sender: UIButton?) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var login = textField.text?.replacingOccurrences(of: " ", with: "")
        login = login?.lowercased()
        downloadUser(with: textField.text!)
    }
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        authorizeApplication()
    }
    
    private func downloadUser(with login: String) {
        let url = URL(string: "https://api.intra.42.fr/v2/users/" + login)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("downloadUser Error")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                guard json != [:] else {
                    DispatchQueue.main.sync {
                        let alert = UIAlertController().returnAlert(title: "No such user", message: "Invalid login. Try again later", action: "OK")
                        self.present(alert, animated: true)
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                    return
                }
                
                let id = json.value(forKey: "id") as! Int
                let firstName = json["first_name"] as! String
                let lastName = json["last_name"] as! String
                let email = json["email"] as! String
                let image_url = json["image_url"] as! String

                let correction_point = json.value(forKey: "correction_point") as! Int
                let wallet = json.value(forKey: "wallet") as! Int

                let poolMonth = json["pool_month"] as! String
                let poolYear = json["pool_year"] as! String
                let poolDate = poolMonth + " " + poolYear
                
                var phone = json["phone"]
                if phone as? String == nil {
                    phone = "Unknown"
                }
                
                var place = json["location"]
                if place as? String == nil {
                    place = "Unavailable"
                }
                
                let cursus_users = json["cursus_users"] as? [NSDictionary]
                var level = ""
                for cursus in cursus_users! {
                    if (cursus["cursus_id"] as! Int == 1) {
                        let skills = cursus["skills"] as? [NSDictionary]
                        for skill in skills! {
                            print(skill.value(forKey: "id"))

                            //                            print(skill.value(forKey: <#T##String#>))
                        }
                        print(skills)
//                        print(cursus)
                        level = (cursus["level"] as! NSNumber).doubleValue.roundDouble

                    }
                }

                self.user = User(id: id,
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
                                 wallet: wallet)
                
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "fromLoginToProfileSegueIdentifier", sender: nil)
                }
            } else {
                print("downloadUser JSON fail")
            }
            
        }.resume()


    }
    
    
    private func authorizeApplication() {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")!
        let grant_type = "grant_type=client_credentials"
        let uid = "client_id=\(client_id)"
        let secret = "client_secret=\(client_secret)"
        let requestString = grant_type + "&" + uid + "&" + secret
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = requestString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("authorizeApplication Error")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                token = json["access_token"] as! String
            } else {
                print("authorizeApplication JSON fail")
            }
            
            }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLoginToProfileSegueIdentifier" {
            if user?.firstName != nil {
                let nextVC = segue.destination as! UserInfoViewController
                nextVC.user = user
            }
        }
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchButtonClicked(nil)
        return true
    }
}
