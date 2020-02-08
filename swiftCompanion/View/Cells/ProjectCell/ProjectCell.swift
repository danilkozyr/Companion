//
//  ProjectCell.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/15/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    
    @IBOutlet private weak var projectName: UILabel!
    @IBOutlet private weak var projectGrade: UILabel!
    
    static let identifier = "projectCell"
    
    func configureCell(projectUser: ProjectUsers) {
        self.projectName.text = projectUser.project.name
        guard projectUser.finalMark != nil else {
            self.projectGrade.text = ""
            self.projectName.textColor = .white
            self.projectGrade.textColor = .white
            return
        }
        
        self.projectGrade.text = "\(projectUser.finalMark!)"
        
        if projectUser.finalMark! >= 75 {
            self.projectGrade.textColor = UIColor(red: 80/255, green: 220/255, blue: 100/255, alpha: 1.0)
        } else {
            self.projectGrade.textColor = UIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 1.0)
        }
        
    }
    
}
