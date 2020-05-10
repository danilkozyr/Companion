import Foundation
import UIKit

protocol UserPresenterDelegate {
    func showLastLocation(_ location: String?)
    func showProfileImage(_ image: UIImage)
    func addBarButtonItem()
    func hideBarButtonItem()
    func showError(_ error: String)
}

class UserPresenter {

    // MARK: Private properties

    private var delegate: UserPresenterDelegate?

    // MARK: Internal methods

    func setDelegate(_ delegate: UserPresenterDelegate) {
        self.delegate = delegate
    }

    func load(for user: UserViewState) {
        downloadLastLocation(for: user)
        downloadProfileImage(for: user)
        if !checkIfFriendIsAlreadyAdded(with: user.id) {
            delegate?.addBarButtonItem()
        }
    }

    func addToFriends(_ viewState: UserViewState) {
        guard !checkIfFriendIsAlreadyAdded(with: viewState.id) else {
            return
        }

        let friend = Friend()
        friend.id = viewState.id
        friend.name = viewState.fullName
        friend.email = viewState.email
        friend.level = viewState.level
        friend.levelProgress = viewState.levelProgress
        friend.image = viewState.image?.pngData()

        if let url = viewState.imageURL {
            friend.imageURL = String(describing: url)
        }

        let storage = Storage()
        storage.saveObject(friend)
        delegate?.hideBarButtonItem()
    }

    // MARK: Private methods

    private func checkIfFriendIsAlreadyAdded(with id: Int) -> Bool {
        let storage = Storage()
        let objects: [Friend] = storage.readObject()
        let savedFriend = objects.first(where: { $0.id == id })

        return savedFriend == nil ? false : true
    }

    private func downloadLastLocation(for user: UserViewState) {
        guard user.location == nil else {
            return
        }

        FetcherService.getLocation(with: user.id).onSuccess { locations in
            guard let lastLocation = locations.first?.endAt else {
                return
            }

            guard let lastLocationDate = lastLocation.convertToDisplayViewFrom() else {
                return
            }

            self.delegate?.showLastLocation(Constants.Labels.lastOnline + lastLocationDate)
        }.onFailure { error in
            self.delegate?.showError(error.localizedDescription)
        }
    }

    private func downloadProfileImage(for user: UserViewState) {
        guard let url = user.imageURL else {
            return
        }

        FetcherService.getProfileImage(from: url).onSuccess { [weak self] data in
            guard let self = self, let image = UIImage(data: data) else {
                return
            }

            self.delegate?.showProfileImage(image)
        }
    }
}
