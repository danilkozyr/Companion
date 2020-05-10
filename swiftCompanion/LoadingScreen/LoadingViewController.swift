import UIKit

class LoadingViewController: UIViewController {

    // MARK: IBOutlet

    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }

}
