import Foundation
import BrightFutures

class FetcherService {

    static private var networkService = NetworkService()

    static func getToken() -> Future<TokenResponse, Error> {
        let parameters = ["grant_type" : "client_credentials",
                          "client_id" : Constants.Token.client_id,
                          "client_secret" : Constants.Token.client_secret]

        let endpoint = Endpoint(url: Constants.URLs.token,
                                parameters: parameters,
                                method: .post,
                                headers: nil)

        return networkService.create(from: endpoint)
    }


    static func getUser(with login: String) -> Future<UserResponse, Error> {
        let endpoint = Endpoint(url: Constants.URLs.user + login)

        return networkService.create(from: endpoint)
    }

    static func getLocation(with id: Int) -> Future<[Location], Error> {
        let endpoint = Endpoint(url: Constants.URLs.locationsDomen + "\(id)" + Constants.URLs.locationsParameters)

        return networkService.create(from: endpoint)
    }

}
