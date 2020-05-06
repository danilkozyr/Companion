protocol SearchPresenterDelegate {
    func showUser(_ user: UserResponse, viewState: UserViewState)
    func showError(_ error: String)
}
