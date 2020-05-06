import Foundation
import Alamofire
import BrightFutures

class NetworkService {
    func create<T: Decodable>(from endPoint: Endpoint) -> Future<T, Error> {
        return Future { complete in
            guard let urlRequest = URL(string: endPoint.url) else {
                return
            }

            AF.request(urlRequest, method: endPoint.method, parameters: endPoint.parameters, headers: endPoint.headers).response { response in
                guard response.error == nil else {
                    complete(.failure(response.error!))
                    return
                }

                guard let data = response.data else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data is Missing"])
                    complete(.failure(error))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    let response = try decoder.decode(T.self, from: data)
                    complete(.success(response))
                } catch {
                    complete(.failure(error))
                }
            }
        }
    }
}
