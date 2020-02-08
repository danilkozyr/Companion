//
//  SearchVC.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientColor(colorOne: UIColor(red: 4/255, green: 4/255, blue: 9/255, alpha: 1.0),
                              colorTwo: UIColor(red: 48/255, green: 43/255, blue: 99/255, alpha: 1.0),
                              startPosition: CGPoint(x: 0, y: 0))

    }

    private func searchUser(with login: String, with token: String) {
        let fetcher = DataFetcherService()
        
        fetcher.fetchUser(login: login, token: token) { [weak self] (user, error) in
            guard let user = user, error == nil else {
                if error == nil {
                    self?.showError(message: "Incorrect Login")
                } else {
                    self?.showError(message: error!.localizedDescription)
                }
                return
            }
            
            self?.showNextVC(user: user, token: token)
        }
    }
    
    private func showNextVC(user: User, token: String) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        view.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "UserVCID") as! UserVC
        nextVC.user = user
        nextVC.token = token
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController().returnAlert(title: "Error", message: message, action: "OK")
        activityIndicator.isHidden = true
        view.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
        present(alert, animated: true)
    }
    
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        let login = textField.text?.replacingOccurrences(of: " ", with: "").lowercased()

        let fetcher = DataFetcherService()
        fetcher.fetchToken { [weak self] (token, error) in
            guard let token = token, error == nil else {
                return
            }
            
            self?.token = token.accessToken
            self?.searchUser(with: login!, with: token.accessToken)
        }
        return true
    }
}
