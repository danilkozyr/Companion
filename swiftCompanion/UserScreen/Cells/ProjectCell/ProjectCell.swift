import UIKit

class ProjectCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var projectName: UILabel!
    @IBOutlet private weak var projectGrade: UILabel!

    // MARK: Configuration

    func configureCell(with viewState: ProjectViewState) {
        projectName.text = viewState.name        
        projectGrade.text = viewState.grade
        projectGrade.textColor = viewState.gradeColor
    }
    
}
