import Foundation
import UIKit

class UserViewStateFactory {
    private enum CourseType {
        case pool
        case study
    }

    // MARK: Internal methods

    func make(from response: UserResponse) -> UserViewState {
        let fullName = response.firstName + " " + response.lastName
        let poolDate = "\(response.poolMonth), \(response.poolYear)"
        let levelFloat: Float

        if let level = response.cursusUsers.filter( { $0.cursusId == 1 } ).first?.level {
            levelFloat = level
        } else if let level = response.cursusUsers.filter( { $0.cursusId == 4 } ).first?.level {
            levelFloat = level
        } else {
            levelFloat = 0.0
        }

        let levelString = String(levelFloat).split(separator: ".")

        let level = "\(levelString[0]) - \(levelString[1])%"
        let levelProgress = Float("0." + levelString[1]) ?? 0.0

        let campusPlace: String

        if let campus = response.campus.first {
            campusPlace = campus.city + ", " + campus.country
        } else {
            campusPlace = Constants.Labels.defaultUsersPlace
        }

        let poolProjects = makeProjects(from: response, course: .pool)
        let studyProjects = makeProjects(from: response, course: .study)

        let poolSkills = makeSkills(from: response, course: .pool)
        let studySkills = makeSkills(from: response, course: .study)

        return UserViewState(id: response.id,
                             fullName: fullName,
                             displayName: response.displayname,
                             login: response.login,
                             imageURL: URL(string: response.imageUrl) ?? nil,
                             email: response.email ?? "",
                             wallet: "\(response.wallet)",
                             corrections: "\(response.correctionPoint)",
                             poolDate: poolDate,
                             location: response.location,
                             campusPlace: campusPlace,
                             level: level,
                             levelProgress: levelProgress,
                             studyProjects: studyProjects,
                             poolProjects: poolProjects,
                             studySkills: studySkills,
                             poolSkills: poolSkills)
    }

    // MARK: Private methods

    private func makeSkills(from user: UserResponse, course: CourseType) -> [SkillViewState] {
        let cursus: CursusUsers?

        switch course {
        case .pool:
            cursus = user.cursusUsers.first(where: { $0.cursusId == 4 } )
        case .study:
            cursus = user.cursusUsers.first(where: { $0.cursusId == 1 } )
        }

        guard let unwrappedCursus = cursus else {
            return []
        }

        var viewStates: [SkillViewState] = []

        unwrappedCursus.skills.forEach { skill in
            let progress = skill.level / 10

            let viewState = SkillViewState(name: skill.name, level: String(skill.level), levelProgress: progress)
            viewStates.append(viewState)
        }

        return viewStates
    }

    private func makeProjects(from user: UserResponse, course: CourseType) -> [ProjectViewState] {
        let projects: [ProjectUsers]

        switch course {
        case .pool:
            projects = user.projectsUsers.filter { $0.cursusIds.contains(4) && $0.project.parentId == nil }
        case .study:
            projects = user.projectsUsers.filter( { $0.cursusIds.contains(1) && $0.project.parentId == nil && $0.project.name !=  Constants.Labels.rushes } )
        }

        var viewStates: [ProjectViewState] = []

        projects.forEach { [weak self] project in
            guard let self = self else {
                return
            }

            let color = self.getProjectColor(project: project, course: course)
            let grade: String

            if let finalMark = project.finalMark {
                grade = String(finalMark)
            } else {
                grade = ""
            }

            let viewState = ProjectViewState(name: project.project.name, grade: grade, gradeColor: color)
            viewStates.append(viewState)
        }

        return viewStates.sorted(by: { $0.name < $1.name })
    }

    private func getProjectColor(project: ProjectUsers, course: CourseType) -> UIColor {
        let minToPassGrade = course == .pool ? 25 : 75

        guard let grade = project.finalMark else {
            return .white
        }

        return grade >= minToPassGrade ? .customGreen : .customRed
    }
}
