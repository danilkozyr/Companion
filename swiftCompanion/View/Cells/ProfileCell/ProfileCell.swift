//
//  ProfileCell.swift
//  swiftCompanion
//
//  Created by Ксения on 8/10/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var phone: UILabel!
    @IBOutlet private weak var place: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var pool: UILabel!
    @IBOutlet private weak var corrections: UILabel!
    @IBOutlet private weak var wallet: UILabel!
    @IBOutlet private weak var level: UILabel!
    
    static let identifier = "profileCell"
    
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
        
        let levelFloat: Float
        
        if let level = user.cursusUsers.filter( { $0.cursusId == 1 } ).first?.level {
            levelFloat = level
        } else if let level = user.cursusUsers.filter( { $0.cursusId == 4 } ).first?.level {
            levelFloat = level
        } else {
            levelFloat = 0.0
        }
        
        var levelString = String(levelFloat).split(separator: ".")
        
        self.level.text = "Level \(levelString[0]) - \(levelString[1])%"
        levelString[1] = "0." + levelString[1]
        self.levelProgress.progress = Float(levelString[1])!
    }
    
    
}
