import Foundation

class UserPresenter {

    private var delegate: UserPresenterDelegate?

    func setDelegate(_ delegate: UserPresenterDelegate) {
        self.delegate = delegate
    }

    func downloadLastLocation(for user: UserViewState) {
        guard user.location == nil else {
            return
        }

        FetcherService.getLocation(with: user.id).onSuccess { locations in
            guard let lastLocation = locations.first?.endAt else {
                return
            }

            self.delegate?.showLastLocation(lastLocation)
        }.onFailure { error in
            self.delegate?.showError(error.localizedDescription)
        }
    }

    func addToFriends(_ viewState: UserViewState) {
        


    }


//    @objc dynamic var name = ""
//    @objc dynamic var email = ""
//    @objc dynamic var level = ""
//    @objc dynamic var levelProgress = 0.0
//    @objc dynamic var picture: Data? = nil
}
