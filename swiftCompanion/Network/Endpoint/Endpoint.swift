import Foundation
import Alamofire

struct Endpoint {
    var url: String
    var parameters: [String: String] = [:]
    var method: HTTPMethod = .get
    var headers: HTTPHeaders? = ["Authorization": "Bearer " + Constants.Token.token]
}
