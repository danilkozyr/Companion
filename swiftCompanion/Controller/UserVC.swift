//
//  UserVC.swift
//  swiftCompanion
//
//  Created by Ксения on 8/9/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

// TODO: Last Location

import UIKit

class UserVC: UIViewController {

    var user: User!
    var projectUsers: [ProjectUsers] = []
    var token: String!
    
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
        self.title = user.login + "'s profile"

        view.setGradientColor(colorOne: UIColor(red: 4/255, green: 4/255, blue: 9/255, alpha: 1.0),
                            colorTwo: UIColor(red: 48/255, green: 43/255, blue: 99/255, alpha: 1.0),
                            startPosition: CGPoint(x: 0, y: 0))
        downloadProjects()
    }
    
    private func downloadProjects() {
        
        let fetcher = DataFetcherService()
        
        fetcher.fetchProjects(user: user, token: token) { [weak self] (projects, error) in
            guard let projects = projects, error == nil else {
                return
            }

            let new = self?.getProjects(projects: projects)
            self?.projectUsers = new!
            self?.tableView.reloadData()
        }
        
    }
    
    private func getProjects(projects: [ProjectUsers]) -> [ProjectUsers] {
        
        let schoolProjects = projects.filter( {  $0.cursusIds.contains(1) && $0.project.parentId == nil && $0.project.name != "Rushes" } )
        
        if schoolProjects.isEmpty {
            return projects.filter( { $0.cursusIds.contains(4) && $0.project.parentId == nil })
        }
    
        return schoolProjects
    }
    
    deinit {
        print("UserVC is deinited")
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
            return projectUsers.isEmpty ? 0 : projectUsers.count + 1
        } else {
            return user.cursusUsers.first!.skills.isEmpty ? 0 : user.cursusUsers.first!.skills.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileCell

            cell.configureCell(user: user)
            
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! SectionCell
                cell.sectionName.text = "Projects"
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectCell
            let projectUser = projectUsers[indexPath.row - 1]
            cell.configureCell(projectUser: projectUser)
            
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! SectionCell
                cell.sectionName.text = "Skills"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillCell

            let skill = (user.cursusUsers.first?.skills[indexPath.row - 1])!
            cell.configureCell(skill: skill)
            
            return cell

        }
    }
}
