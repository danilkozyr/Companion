import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    private let presenter = SearchPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setDelegate(self)
//        presenter.searchUser(with: "dkozyr")
        addBarButtonItem()
    }

    private func addBarButtonItem() {
        let barButtonItem = UIBarButtonItem(title: "Friends", style: .plain, target: self, action: #selector(handleAddBarButtonItem))

        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc private func handleAddBarButtonItem() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendsVCID") as! FriendsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false

        presenter.searchUser(with: textField.text)

        return true
    }
}

extension SearchViewController: SearchPresenterDelegate {
    func showUser(_ user: UserResponse, viewState: UserViewState) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        view.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "UserVCID") as! UserViewController
        nextVC.viewState = viewState
        navigationController?.pushViewController(nextVC, animated: true)
    }

    func showError(_ error: String) {
        let alert = UIAlertController().returnAlert(title: "Error", message: error, action: "OK")
        activityIndicator.isHidden = true
        view.isUserInteractionEnabled = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
        present(alert, animated: true)
    }


}
