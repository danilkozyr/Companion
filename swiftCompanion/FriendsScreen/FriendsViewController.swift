import UIKit

class FriendsViewController: BaseViewController {

    // MARK: IBOutlets

    @IBOutlet private weak var noFriendsLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: Constants.NibNames.friend, bundle: nil),
                               forCellReuseIdentifier:  Constants.CellIdentifier.friend)
        }
    }

    // MARK: Private Properties

    private let presenter = FriendsPresenter()
    private var viewStates: [FriendViewState] = []

    // MARK: Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.friends
        presenter.setDelegate(self)
        presenter.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.load()
        tableView.reloadData()
    }
}

// MARK: FriendsPresenterDelegate

extension FriendsViewController: FriendsPresenterDelegate {
    func showUser(viewState: UserViewState) {
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

    func showFriends(with viewStates: [FriendViewState]) {
        self.viewStates = viewStates
        noFriendsLabel.isHidden = true
        tableView.isHidden = false
    }

    func showLabelWhenNoFriends() {
         tableView.isHidden = true
         noFriendsLabel.isHidden = false

        noFriendsLabel.text = Constants.Labels.noFriends
     }
}

// MARK: UITableViewDataSource

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewStates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.friend) as! FriendCell
        let viewState = viewStates[indexPath.row]
        cell.configure(with: viewState)

        return cell
    }
}

// MARK: UITableViewDelegate

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loadingScreen = storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.loading) as! LoadingViewController
        present(loadingScreen, animated: false)

        let friend = viewStates[indexPath.row]

        presenter.searchUser(with: "\(friend.id)")
    }

}
