//
//  SearchVC.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        view.setGradientColor(colorOne: UIColor(red: 4/255, green: 4/255, blue: 9/255, alpha: 1.0),
                              colorTwo: UIColor(red: 48/255, green: 43/255, blue: 99/255, alpha: 1.0),
                              startPosition: CGPoint(x: 0, y: 0))
    }

    private func searchUser(with login: String, with token: String) {
        APIDownloader.downloadUser(with: login, token: token) { [weak self] result in
            switch result {
            case .success(let get):
                let user = get as! User
                DispatchQueue.main.async {
                    self?.showUser(user: user)
                }
            case .error(let error):
                DispatchQueue.main.async {
                    self?.showError(message: error)
                }
            }
        }
    }
    
    private func showUser(user: User) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        view.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "UserVCID") as! UserVC
        nextVC.user = user
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController().returnAlert(title: "Error", message: message, action: "OK")
        if UserDefaults.standard.string(forKey: LocalKeys.topicKey) != nil {
            UserDefaults.standard.removeObject(forKey: LocalKeys.topicKey)
        }
        activityIndicator.isHidden = true
        view.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
        present(alert, animated: true)
    }
    
    private func checkIfLocalDataExpired() {
        let defaults = UserDefaults.standard
        let date = Date()
        if let dateExpired = defaults.object(forKey: LocalKeys.dateExpired) as? Date {
            if date > dateExpired {
                defaults.removeObject(forKey: LocalKeys.dateExpired)
                defaults.removeObject(forKey: LocalKeys.topicKey)
            }
        }
    }
    
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        checkIfLocalDataExpired()
        let login = textField.text?.replacingOccurrences(of: " ", with: "").lowercased()
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: LocalKeys.topicKey) {
            searchUser(with: login!, with: token)
        } else {
            
            APIDownloader.authorizeApplication { [weak self] result in
                switch result {
                case .success(let token):
                    let dateExpired = Date(timeIntervalSinceNow: TimeInterval(exactly: 7200)!)
                    defaults.set(token, forKey: LocalKeys.topicKey)
                    defaults.set(dateExpired, forKey: LocalKeys.dateExpired)
                    self?.searchUser(with: login!, with: token as! String)
                case .error(let error):
                    let alert = UIAlertController().returnAlert(title: "You are not connected to the Internet", message: error, action: "OK")
                    self?.present(alert, animated: true)
                }
            }
            
        }
        
        return true
    }
}
