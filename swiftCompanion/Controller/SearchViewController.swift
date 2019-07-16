//
//  ViewController.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//
// "

import UIKit

class SearchViewController: UIViewController {

    var api = APIDownloader()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
//    @IBAction func searchButtonClicked(_ sender: UIButton?) {

//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        api.authorizeApplication(failure: { (error) in
            DispatchQueue.main.sync {
                let alert = UIAlertController().returnAlert(title: "You are not connected to the Internet", message: error, action: "OK")
                self.present(alert, animated: true)
            }
        })
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard APIData.token != "" else {
            return false
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var login = textField.text?.replacingOccurrences(of: " ", with: "")
        login = login?.lowercased()
        api.downloadUser(with: login!, success: { (user) in
            DispatchQueue.main.sync {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewControllerID") as! UserInfoViewController
                nextVC.user = user
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }) { (error) in
            DispatchQueue.main.sync {
                let alert = UIAlertController().returnAlert(title: "Error", message: error, action: "OK")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.present(alert, animated: true)
            }
        }
        
        
//        self.searchButtonClicked(nil)
        return true
    }
}
