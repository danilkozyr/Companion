//
//  UserInfoViewController.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var poolLabel: UILabel!
    @IBOutlet weak var clusterPlaceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private func connectOutlets() {
        guard let user = user else {
            return
        }
        self.navigationController?.navigationBar.tintColor = .white
        self.title = user.firstName + " " + user.lastName
        imageView.downloaded(from: URL(string: user.imageUrl)!)
        imageView.setRounded()
        
        loginLabel.text = user.login
        fullName.text = user.firstName + " " + user.lastName
//        location.text =
        phoneLabel.text = user.phone
        wallet.text = "Wallet: \(user.wallet)"
        correctionLabel.text = "Corrections: \(user.correctionPoints)"
        poolLabel.text = user.poolDate
        clusterPlaceLabel.text = user.place
        
        var level = user.level.split(separator: ".")
        levelLabel.text = "Level \(level[0]) - \(level[1])%"
        
        level[1] = "0." + level[1]
        progressBar.progress = Float(level[1])!
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 5)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        connectOutlets()
    }

}
