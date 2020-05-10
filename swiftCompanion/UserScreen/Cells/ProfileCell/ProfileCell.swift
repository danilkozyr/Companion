import UIKit

class ProfileCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var place: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var pool: UILabel!
    @IBOutlet private weak var corrections: UILabel!
    @IBOutlet private weak var wallet: UILabel!
    @IBOutlet private weak var level: UILabel!
    @IBOutlet private weak var levelProgress: UIProgressView! {
        didSet {
            levelProgress.setCorner(with: 10, borderWidth: 0.5, color: .white)
            levelProgress.transform = CGAffineTransform(scaleX: 1, y: 5)
        }
    }
    @IBOutlet private weak var profileImage: UIImageView! {
        didSet {
            profileImage.contentMode = .scaleAspectFill
            profileImage.setGradientColor(colorOne: .clear, colorTwo: .black, startPosition: CGPoint(x: 0, y: 0.4))
        }
    }

    // MARK: Configuration
    
    func configureCell(user: UserViewState) {
        backgroundColor = .clear
        profileImage.image = user.image
        fullName.text = user.fullName
        email.text = user.email
        location.text = user.campusPlace
        wallet.text = Constants.Labels.wallet + user.wallet
        corrections.text = Constants.Labels.corrections + user.corrections
        pool.text = user.poolDate
        place.text = user.location
        level.text = Constants.Labels.level + user.level
        levelProgress.progress = user.levelProgress
    }
}
