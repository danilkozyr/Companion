//
//  File.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

class User {
    let id: Int
    let login: String
    let firstName: String
    let lastName: String
    let email: String
    let imageUrl : String
    let poolDate: String
    let phone: String?
    let place: String?
    let level: String
    let correctionPoints: Int
    let wallet: Int
    var location: String
    
    var skills: [Skill]
    var projects: [Project]?
    
    init(id: Int,
        login: String,
        firstName: String,
        lastName: String,
        email: String,
        imageUrl : String,
        poolDate: String,
        phone: String?,
        place: String?,
        level: String,
        correctionPoints: Int,
        wallet: Int,
        location: String,
        skills: [Skill],
        projects: [Project]?) {
        self.id = id
        self.login = login
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.imageUrl = imageUrl
        self.poolDate = poolDate
        self.phone = phone
        self.place = place
        self.level = level
        self.correctionPoints = correctionPoints
        self.wallet = wallet
        self.location = location
        self.skills = skills
        self.projects = projects
    }
    
    deinit {
        print("user deinited")
    }
    
}
