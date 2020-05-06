import UIKit

class FriendsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFriendsLabel: UILabel!

    private var viewStates: [UserViewState] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Friends"
        if viewStates.isEmpty {
            tableView.isHidden = true
            noFriendsLabel.isHidden = false

            noFriendsLabel.text = "You don't have friends yet. Search for a friend and add him to the friends. :)"
        } else {
            noFriendsLabel.isHidden = true
            tableView.isHidden = false
        }
    }



}
