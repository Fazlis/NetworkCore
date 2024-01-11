//  Created by Iskandar Fazliddinov on 11/01/24.

import Foundation
import SwiftyJSON


protocol NetworkClientUseCase {
    func sendRequest<T>(request: NetworkRequest, completion: @escaping NetworkResponse<T>)
}

final class NetworkClient: NSObject, NetworkClientUseCase {
    func sendRequest<T: Codable>(request: NetworkRequest, completion: @escaping NetworkResponse<T>) where T: Codable {
        guard let url = URL(string: request.urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if let parameters = request.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(.invalidData))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode), let data = data {
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    Logger.printDecodingError(error: error)
                    completion(.failure(.invalidData))
                }
            } else {
                completion(.failure(.invalidResponse))
            }
        }
        task.resume()
    }
}
