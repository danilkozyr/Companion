//
//  SkillCell.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/15/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class SkillCell: UITableViewCell {

    @IBOutlet private weak var skillName: UILabel!
    @IBOutlet private weak var skillProgress: UIProgressView!
    
    static let identifier = "skillCell"
    
    func configureCell(skill: Skill) {
        self.skillName.text = "\(skill.name) - level: \(skill.level)"
        self.skillProgress.transform = CGAffineTransform(scaleX: 1, y: 2)
        self.skillProgress.progress = skill.level / 10.0
    }
    
}
