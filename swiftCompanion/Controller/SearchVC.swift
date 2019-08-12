//
//  SearchVC.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    private var api = APIDownloader()
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
        getAPIToken()
    }
    
    private func getAPIToken() {
        api.authorizeApplication(failure: { [unowned self] error in
            DispatchQueue.main.sync {
                let alert = UIAlertController().returnAlert(title: "You are not connected to the Internet", message: error, action: "OK")
                self.present(alert, animated: true)
            }
        })
    }
}


extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard APIData.token != "" else {
            return false
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        var login = textField.text?.replacingOccurrences(of: " ", with: "")
        login = login?.lowercased()
        api.downloadUser(with: login!) { [unowned self] result in
            switch result {
            case .success(let get):
                DispatchQueue.main.async {
                    let user = get as! User
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "UserVCID") as! UserVC
                    nextVC.user = user
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            case .error(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController().returnAlert(title: "Error", message: error, action: "OK")
                    self.activityIndicator.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.present(alert, animated: true)
                }

            }
        }
        
        return true
    }
}
