import UIKit

class SkillCell: UITableViewCell {

    @IBOutlet private weak var skillName: UILabel!
    @IBOutlet private weak var skillProgress: UIProgressView! {
        didSet {
            skillProgress.transform = CGAffineTransform(scaleX: 1, y: 2)
        }
    }
    
    static let identifier = "skillCell"
    
    func configureCell(with skill: SkillViewState) {
        skillName.text = skill.name + " - level: " + skill.level
        skillProgress.progress = skill.levelProgress
    }
    
}
