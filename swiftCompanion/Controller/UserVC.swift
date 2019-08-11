//
//  UserVC.swift
//  swiftCompanion
//
//  Created by Ксения on 8/9/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

// TODO: Check bugs
// TODO: Rewrite Downloader a little bit
// TODO: Fix console
// TODO: Last Location

import UIKit

class UserVC: UIViewController {

    var user: User?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.dataSource = self
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "projectCell")
            tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
            tableView.register(UINib(nibName: "SkillCell", bundle: nil), forCellReuseIdentifier: "skillCell")
            tableView.register(UINib(nibName: "SectionCell", bundle: nil), forCellReuseIdentifier: "sectionCell")

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user!.login + "'s profile"

        view.setGradientColor(colorOne: UIColor(red: 4/255, green: 4/255, blue: 9/255, alpha: 1.0),
                            colorTwo: UIColor(red: 48/255, green: 43/255, blue: 99/255, alpha: 1.0),
                            startPosition: CGPoint(x: 0, y: 0))
        
    }
}

extension UserVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return user!.projects!.count + 1
        } else {
            return user!.skills.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileCell
            
            cell.backgroundColor = .clear
            cell.profileImage.downloaded(from: URL(string: user!.imageUrl)!)
            cell.fullName.text = user!.firstName + " " + user!.lastName
            cell.location.text = user!.location
            cell.phone.text = user!.email
            cell.wallet.text = "Wallet: \(user!.wallet)"
            cell.corrections.text = "Corrections: \(user!.correctionPoints)"
            cell.pool.text = user!.poolDate
            cell.place.text = user!.place
            var level = user!.level.split(separator: ".")
            cell.level.text = "Level \(level[0]) - \(level[1])%"
            
            level[1] = "0." + level[1]
            cell.levelProgress.progress = Float(level[1])!
            
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! SectionCell
                cell.sectionName.text = "Projects"
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectCell
            let project = user?.projects![indexPath.row - 1]
            cell.projectName.text = project?.name
            guard project?.grade != nil else {
                cell.projectGrade.text = ""
                cell.projectName.textColor = .white
                cell.projectGrade.textColor = .white
                
                return cell
            }
            
            cell.projectGrade.text = project?.grade
            
            if (Int(cell.projectGrade.text!)! >= 75) {
                cell.projectGrade.textColor = UIColor(red: 80/255, green: 220/255, blue: 100/255, alpha: 1.0)
            } else {
                cell.projectGrade.textColor = UIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 1.0)
            }
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! SectionCell
                cell.sectionName.text = "Skills"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillCell

            let skill = (user?.skills[indexPath.row - 1])!
            cell.skillName.text = "\(skill.name) - level: \(skill.level)"
            cell.skillProgress.transform = CGAffineTransform(scaleX: 1, y: 2)
            cell.skillProgress.progress = Float(skill.level)! / 10.0

            return cell

        }
    }
    
    
    
}
