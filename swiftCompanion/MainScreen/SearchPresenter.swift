import Foundation

class SearchPresenter {

    var delegate: SearchPresenterDelegate?

    func setDelegate(_ delegate: SearchPresenterDelegate) {
        self.delegate = delegate
    }

    func searchUser(with text: String?) {
        guard let login = text?.replacingOccurrences(of: " ", with: "").lowercased() else {
            return
        }

        FetcherService.getToken().onSuccess { [weak self] token in
            guard let self = self else {
                return
            }

            Constants.Token.token = token.accessToken

            FetcherService.getUser(with: login).onSuccess { user in
                let factory = UserViewStateFactory()
                let viewState = factory.make(from: user)

                self.delegate?.showUser(user, viewState: viewState)
            }.onFailure { error in
                self.delegate?.showError(error.localizedDescription)
            }
            
        }.onFailure { error in
            self.delegate?.showError(error.localizedDescription)
        }
    }
}
