import Foundation
import UIKit

struct UserViewState {
    let id: Int
    let fullName: String
    let displayName: String
    let login: String
    let imageURL: URL?
    var image: UIImage? = nil
    let email: String
    let wallet: String
    let corrections: String
    let poolDate: String
    var location: String?
    let campusPlace: String
    let poolLevel: String
    let poolLevelProgress: Float
    let studyLevel: String
    let studyLevelProgress: Float
    let studyProjects: [ProjectViewState]
    let poolProjects: [ProjectViewState]
    let studySkills: [SkillViewState]
    let poolSkills: [SkillViewState]
}

struct ProjectViewState {
    let name: String
    let grade: String
    let gradeColor: UIColor
}

struct SkillViewState {
    let name: String
    let level: String
    let levelProgress: Float
}
