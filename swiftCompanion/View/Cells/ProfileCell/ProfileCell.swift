//
//  ProfileCell.swift
//  swiftCompanion
//
//  Created by Ксения on 8/10/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var pool: UILabel!
    @IBOutlet weak var corrections: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var level: UILabel!
    
    @IBOutlet weak var levelProgress: UIProgressView! {
        didSet {
            levelProgress.setCorner(with: 10, borderWidth: 0.5, color: .white)
            levelProgress.transform = CGAffineTransform(scaleX: 1, y: 5)
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.setGradientColor(colorOne: .clear, colorTwo: .black, startPosition: CGPoint(x: 0, y: 0.4))
        }
    }
    
    func configureCell(user: User) {
        var user = user
        
        self.backgroundColor = .clear
        self.profileImage.downloaded(from: URL(string: user.imageUrl)!)
        self.fullName.text = user.firstName + " " + user.lastName
        self.location.text = user.campus.first!.campusLocation()
        self.phone.text = user.email
        self.wallet.text = "Wallet: \(user.wallet)"
        self.corrections.text = "Corrections: \(user.correctionPoint)"
        self.pool.text = user.poolDate
        self.place.text = user.location
        
        let levelFloat = user.cursusUsers.first!.level
        var levelString = String(levelFloat).split(separator: ".")
        
        self.level.text = "Level \(levelString[0]) - \(levelString[1])%"
        levelString[1] = "0." + levelString[1]
        self.levelProgress.progress = Float(levelString[1])!
    }
    
    
}
