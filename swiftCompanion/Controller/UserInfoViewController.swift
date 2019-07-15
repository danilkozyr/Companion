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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var poolLabel: UILabel!
    @IBOutlet weak var clusterPlaceLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var projectTableView: UITableView! {
        didSet {
            projectTableView.layer.borderWidth = 2.0
            projectTableView.layer.borderColor = UIColor.white.cgColor
            projectTableView.layer.cornerRadius = 10
            projectTableView.dataSource = self
            projectTableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "projectCellIdentifier")
            projectTableView.estimatedRowHeight = 60
        }
    }
    
    @IBOutlet weak var skillTableView: UITableView! {
        didSet {
            skillTableView.layer.borderWidth = 2.0
            skillTableView.layer.borderColor = UIColor.white.cgColor
            skillTableView.layer.cornerRadius = 10
            skillTableView.dataSource = self
            skillTableView.register(UINib(nibName: "SkillCell", bundle: nil), forCellReuseIdentifier: "skillCellIdentifier")
            skillTableView.estimatedRowHeight = 60
        }
    }
    
    private func connectOutlets(with user: User) {

        self.title = user.firstName + " " + user.lastName
       
        loginLabel.text = user.login
        location.text = user.location
        phoneLabel.text = user.phone
        wallet.text = "Wallet: \(user.wallet)"
        correctionLabel.text = "Corrections: \(user.correctionPoints)"
        poolLabel.text = user.poolDate
        clusterPlaceLabel.text = user.place
        var level = user.level.split(separator: ".")
        levelLabel.text = "Level \(level[0]) - \(level[1])%"
        
        level[1] = "0." + level[1]
        progressBar.progress = Float(level[1])!
    }
    
    private func designImprovements(with user: User) {
        self.navigationController?.navigationBar.tintColor = .white
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 5)
        imageView.downloaded(from: URL(string: user.imageUrl)!)
        imageView.setRounded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {
            return
        }
        connectOutlets(with: user)
        designImprovements(with: user)
    }

}

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == skillTableView {
            return (user?.skills.count)!
        } else {
            return (user?.projects.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == skillTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCellIdentifier") as! SkillCell
            
            let skill = (user?.skills[indexPath.row])!
            cell.nameLabel.text = "\(skill.name) - level: \(skill.level)"
            cell.progressBar.transform = CGAffineTransform(scaleX: 1, y: 2)
            cell.progressBar.progress = Float(skill.level)! / 10.0

            return cell
        } else if tableView == projectTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCellIdentifier") as! ProjectCell
            let project = (user?.projects[indexPath.row])!
            
            cell.projectNameLabel.text = project.name
            guard project.grade != nil else {
                cell.projectGradeLabel.text = ""
                cell.projectNameLabel.textColor = .white
                cell.projectGradeLabel.textColor = .white

                return cell
            }
            
    
            cell.projectGradeLabel.text = project.grade
            
            if (Int(cell.projectGradeLabel.text!)! >= 75) {
                cell.projectGradeLabel.textColor = UIColor(red:0.36, green:0.72, blue:0.36, alpha:1.0)
                cell.projectNameLabel.textColor = UIColor(red:0.36, green:0.72, blue:0.36, alpha:1.0)
            } else {
                cell.projectNameLabel.textColor = UIColor(red:0.85, green:0.39, blue:0.44, alpha: 1.0)
                cell.projectGradeLabel.textColor = UIColor(red:0.85, green:0.39, blue:0.44, alpha: 1.0)
            }
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    
}





