import Foundation

protocol SearchPresenterDelegate {
    func showUser(_ user: UserResponse, viewState: UserViewState)
    func showError(with message: String)
}

class SearchPresenter {

    // MARK: Private properties

    private var delegate: SearchPresenterDelegate?

    // MARK: Internal methods

    func setDelegate(_ delegate: SearchPresenterDelegate) {
        self.delegate = delegate
    }

    func load() {
        FetcherService.getToken().onSuccess { token in
            Constants.Token.token = token.accessToken
        }.onFailure { error in
            self.delegate?.showError(with: error.localizedDescription)
        }
    }

    func searchUser(with text: String?) {
        guard let login = text?.replacingOccurrences(of: " ", with: "").lowercased() else {
            return
        }

        FetcherService.getUser(with: login).onSuccess { user in
            let factory = UserViewStateFactory()
            let viewState = factory.make(from: user)

            self.delegate?.showUser(user, viewState: viewState)
        }.onFailure { error in
            self.delegate?.showError(with: error.localizedDescription)
        }
    }
}
