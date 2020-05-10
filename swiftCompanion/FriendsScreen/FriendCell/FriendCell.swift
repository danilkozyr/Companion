import UIKit

class FriendCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView! {
        didSet {
            progressView.setCorner(with: 10, borderWidth: 0.5, color: .white)
            progressView.transform = CGAffineTransform(scaleX: 1, y: 5)
        }
    }
    @IBOutlet private weak var friendImageView: UIImageView! {
        didSet {
            friendImageView.setGradientColor(colorOne: .clear, colorTwo: .black, startPosition: CGPoint(x: 0, y: 0.4))
        }
    }

    // MARK: Internal properties and methods

    let presenter = FriendCellPresenter()

    func configure(with viewState: FriendViewState) {
        presenter.setDelegate(self)
        presenter.loadLastLocation(with: viewState.id)
        nameLabel.text = viewState.fullName
        levelLabel.text = Constants.Labels.level + viewState.level
        progressView.progress = viewState.levelProgress
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.image = viewState.image
    }
}

// MARK: FriendCellPresenterDelegate

extension FriendCell: FriendCellPresenterDelegate {
    func showLastLocation(_ location: String) {
        placeLabel.text = location
    }
}
