import Foundation
import UIKit

protocol FriendsPresenterDelegate {
    func showFriends(with viewStates: [FriendViewState])
    func showLabelWhenNoFriends()
    func showUser(viewState: UserViewState)
    func showError(with message: String)
}

class FriendsPresenter {

    // MARK: Private properties

    private var delegate: FriendsPresenterDelegate?

    // MARK: Internal methods

    func setDelegate(_ delegate: FriendsPresenterDelegate) {
        self.delegate = delegate
    }

    func load() {
        downloadFriendsFromDatabase()
    }

    func searchUser(with id: String) {
        FetcherService.getUser(with: id).onSuccess { user in
            let factory = UserViewStateFactory()
            let viewState = factory.make(from: user)

            self.delegate?.showUser(viewState: viewState)
        }.onFailure { error in
            self.delegate?.showError(with: error.localizedDescription)
        }
    }

    // MARK: Private methods

    private func downloadFriendsFromDatabase() {
        let storage = Storage()
        let friends: [Friend] = storage.readObject()

        guard !friends.isEmpty else {
            delegate?.showLabelWhenNoFriends()
            return
        }

        var viewStates: [FriendViewState] = []
        let factory = FriendViewStateFactory()

        friends.forEach { friend in
            let viewState = factory.make(from: friend)

            viewStates.append(viewState)
        }

        delegate?.showFriends(with: viewStates)
    }
}
