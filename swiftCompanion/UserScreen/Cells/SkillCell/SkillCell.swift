import UIKit

class SkillCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var skillName: UILabel!
    @IBOutlet private weak var skillProgress: UIProgressView! {
        didSet {
            skillProgress.transform = CGAffineTransform(scaleX: 1, y: 2)
        }
    }

    // MARK: Configuration
        
    func configureCell(with skill: SkillViewState) {
        skillName.text = skill.name + Constants.Labels.levelCustom + skill.level
        skillProgress.progress = skill.levelProgress
    }
    
}
