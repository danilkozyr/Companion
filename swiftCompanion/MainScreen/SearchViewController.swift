import UIKit

// MARK: TODO: Handle Token correctly: get one time, save to cache.

class SearchViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }

    // MARK: Private properties
    
    private let presenter = SearchPresenter()

    // MARK: Internal methods

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setDelegate(self)
        presenter.load()
        addBarButtonItem()
    }

    // MARK: Private methods

    private func addBarButtonItem() {
        let barButtonItem = UIBarButtonItem(title: Constants.Titles.friends,
                                            style: .plain,
                                            target: self,
                                            action: #selector(handleAddBarButtonItem))

        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc private func handleAddBarButtonItem() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.friends) as! FriendsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        let loadingScreen = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.loading) as! LoadingViewController
        present(loadingScreen, animated: false)

        presenter.searchUser(with: textField.text)

        return true
    }
}

// MARK: SearchPresenterDelegate

extension SearchViewController: SearchPresenterDelegate {
    func showUser(_ user: UserResponse, viewState: UserViewState) {
        dismiss(animated: false, completion: nil)

        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.user) as! UserViewController
        nextVC.viewState = viewState
        navigationController?.pushViewController(nextVC, animated: true)
    }

    func showError(with message: String) {
        dismiss(animated: false, completion: nil)

        let alert = UIAlertController().create(title: Constants.Titles.error,
                                               message: message,
                                               action: Constants.Labels.ok)
        present(alert, animated: true)
    }
}
