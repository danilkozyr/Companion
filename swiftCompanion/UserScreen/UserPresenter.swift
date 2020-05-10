import Foundation
import UIKit

protocol UserPresenterDelegate {
    func showLastLocation(_ location: String?)
    func showProfileImage(_ image: UIImage)
    func handleBarButtonItems(isFriend: Bool)
    func showError(_ message: String)
}

class UserPresenter {

    // MARK: Private properties

    private var delegate: UserPresenterDelegate?
    private let storage = Storage()

    // MARK: Internal methods

    func setDelegate(_ delegate: UserPresenterDelegate) {
        self.delegate = delegate
    }

    func load(for user: UserViewState) {
        downloadLastLocation(for: user)
        downloadProfileImage(for: user)
        let isFriend = checkIfFriendIsAlreadyAdded(with: user.id)
        delegate?.handleBarButtonItems(isFriend: isFriend)
    }

    func addToFriends(_ viewState: UserViewState) {
        let isFriend = checkIfFriendIsAlreadyAdded(with: viewState.id)

        guard !isFriend else {
            return
        }

        let friend = Friend()
        friend.id = viewState.id
        friend.name = viewState.fullName
        friend.email = viewState.email
        friend.level = viewState.studyLevel
        friend.levelProgress = viewState.studyLevelProgress
        friend.image = viewState.image?.pngData()

        if let url = viewState.imageURL {
            friend.imageURL = String(describing: url)
        }

        storage.saveObject(friend)
        delegate?.handleBarButtonItems(isFriend: true)
    }

    func deleteFromFriends(_ viewState: UserViewState) {
        storage.deleteObject(type: Friend.self, with: viewState.id)
        delegate?.handleBarButtonItems(isFriend: false)
    }

    // MARK: Private methods

    private func checkIfFriendIsAlreadyAdded(with id: Int) -> Bool {
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
