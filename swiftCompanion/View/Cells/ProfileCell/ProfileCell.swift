//
//  ProfileCell.swift
//  swiftCompanion
//
//  Created by Ксения on 8/10/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.setGradientColor(colorOne: .clear,
                                          colorTwo: .black,
                                          startPosition: CGPoint(x: 0, y: 0.4))
        }
    }
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
//            levelProgress.layer.cornerRadius = 10
//            levelProgress.clipsToBounds = true
//            levelProgress.layer.borderWidth = 1
//            levelProgress.layer.borderColor = UIColor.white.cgColor
            levelProgress.transform = CGAffineTransform(scaleX: 1, y: 5)
        }
    }
    
}
