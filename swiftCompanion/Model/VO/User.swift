//
//  File.swift
//  swiftCompanion
//
//  Created by Daniil KOZYR on 7/14/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

struct User: Decodable {
    let id: Int
    let email: String?
    let firstName: String
    let lastName: String
    let login: String
    let phone: String?
    let displayname: String
    let imageUrl: String
    let staff: Bool?
    let correctionPoint: Int
    let poolMonth: String
    let poolYear: String
    var location: String?
    let wallet: Int
    let campus: [Campus]
    let cursusUsers: [CursusUsers]

    lazy var poolDate: String = {
        return "\(self.poolMonth), \(self.poolYear)"
    }()
       
}

struct Campus: Decodable {
    let name: String
    let city: String
    let country: String
    
    func campusLocation() -> String {
        return "\(self.city), \(self.country)"
    }
}

struct CursusUsers: Decodable {
    let cursusId: Int
    let level: Float
    let skills: [Skill]
}

struct Skill: Decodable {
    let level: Float
    let name: String
}

struct ProjectUsers: Decodable {
    let id: Int
    let finalMark: Int?
    let cursusIds: [Int]
    let project: Project
}

struct Project: Decodable {
    let name: String
    let slug: String
    let parentId: Int?
}

struct Location: Decodable {
    let endAt: String?
    let beginAt: String
 
}

