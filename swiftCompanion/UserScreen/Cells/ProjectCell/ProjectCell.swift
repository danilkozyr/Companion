import UIKit

class ProjectCell: UITableViewCell {
    
    @IBOutlet private weak var projectName: UILabel!
    @IBOutlet private weak var projectGrade: UILabel!
    
    static let identifier = "projectCell"
    
    func configureCell(with viewState: ProjectViewState) {
        projectName.text = viewState.name        
        projectGrade.text = viewState.grade
        projectGrade.textColor = viewState.gradeColor
    }
    
}
