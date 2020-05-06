import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var place: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var pool: UILabel!
    @IBOutlet private weak var corrections: UILabel!
    @IBOutlet private weak var wallet: UILabel!
    @IBOutlet private weak var level: UILabel!
    
    static let identifier = "profileCell"
    
    @IBOutlet weak var levelProgress: UIProgressView! {
        didSet {
            levelProgress.setCorner(with: 10, borderWidth: 0.5, color: .white)
            levelProgress.transform = CGAffineTransform(scaleX: 1, y: 5)
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.setGradientColor(colorOne: .clear, colorTwo: .black, startPosition: CGPoint(x: 0, y: 0.4))
        }
    }
    
    func configureCell(user: UserViewState) {
        backgroundColor = .clear
        profileImage.downloaded(from: user.imageURL)
        fullName.text = user.fullName
        email.text = user.email
        location.text = user.campusPlace
        wallet.text = "Wallet: " + user.wallet
        corrections.text = "Corrections: " + user.corrections
        pool.text = user.poolDate
        place.text = user.location
        level.text = "Level " + user.level
        levelProgress.progress = user.levelProgress
    }
}
