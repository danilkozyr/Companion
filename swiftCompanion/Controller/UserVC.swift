//
//  UserVC.swift
//  swiftCompanion
//
//  Created by Ксения on 8/9/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    private struct SectionNames {
        static let skills = "Skills"
        static let projects = "Projects"
    }
    
    private struct NibNames {
        static let project = "ProjectCell"
        static let profile = "ProfileCell"
        static let skill = "SkillCell"
        static let section = "SectionCell"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.dataSource = self
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(UINib(nibName: NibNames.project, bundle: nil), forCellReuseIdentifier: ProjectCell.identifier)
            tableView.register(UINib(nibName: NibNames.profile, bundle: nil), forCellReuseIdentifier: ProfileCell.identifier)
            tableView.register(UINib(nibName: NibNames.skill, bundle: nil), forCellReuseIdentifier: SkillCell.identifier)
            tableView.register(UINib(nibName: NibNames.section, bundle: nil), forCellReuseIdentifier: SectionCell.identifier)

        }
    }
    
    var user: User!
    var projectUsers: [ProjectUsers] = []
    var token: String!
    
    lazy var fortyTwoProjects: [ProjectUsers] = {
        let projects = user.projectsUsers.filter( {  $0.cursusIds.contains(1) && $0.project.parentId == nil && $0.project.name != "Rushes" } )
        
        if projects.isEmpty {
            return user.projectsUsers.filter { $0.cursusIds.contains(4) && $0.project.parentId == nil }
        }
        
        return projects
    }()
    
    lazy var fortyTwoSkills: [Skill] = {
        let schoolCursuses = user.cursusUsers.filter ( { $0.cursusId == 1 } )
        
        if schoolCursuses.isEmpty {
            let poolCursuses = user.cursusUsers.filter ( { $0.cursusId == 4 } )
            
            guard let poolCursus = poolCursuses.first else {
                return []
            }
            return poolCursus.skills
        }
        
        guard let schoolCursus = schoolCursuses.first else {
            return []
        }
        
        return schoolCursus.skills
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user.login + "'s profile"

        view.setGradientColor(colorOne: UIColor(red: 4/255, green: 4/255, blue: 9/255, alpha: 1.0),
                              colorTwo: UIColor(red: 48/255, green: 43/255, blue: 99/255, alpha: 1.0),
                              startPosition: CGPoint(x: 0, y: 0))
    }
    
    private func downloadLastLocation() {
        DataFetcherService().fetchLocations(user: user, token: token, completion: { [weak self] (locations, error) in
            guard let locations = locations, error == nil else {
                return
            }
            
            let location = locations.first
            let date = location?.endAt!.transformToDate()
            let lastLoc = date?.timeAgoDisplay()
            self?.user.location = lastLoc!
            
        })
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
            return fortyTwoProjects.isEmpty ? 0 : fortyTwoProjects.count + 1
        } else {
            return fortyTwoSkills.isEmpty ? 0 : fortyTwoSkills.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as! ProfileCell
            cell.configureCell(user: user)
            
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SectionCell.identifier) as! SectionCell
                cell.sectionName.text = SectionNames.projects
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCell.identifier) as! ProjectCell
            let projectUser = fortyTwoProjects[indexPath.row - 1]
            cell.configureCell(projectUser: projectUser)
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SectionCell.identifier) as! SectionCell
                cell.sectionName.text = SectionNames.skills
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillCell.identifier) as! SkillCell
            let skill = fortyTwoSkills[indexPath.row - 1]
            cell.configureCell(skill: skill)
        
            return cell
        }
    }
}
