//  Created by Iskandar Fazliddinov on 11/01/24.

import Foundation
import SwiftyJSON


public protocol NetworkClientUseCase: AnyObject {
    func sendRequest<T>(request: NetworkRequest, completion: @escaping NetworkResponse<T>)
}

public final class NetworkClient: NSObject, NetworkClientUseCase {
    
    public func sendRequest<T: Codable>(request: NetworkRequest, completion: @escaping NetworkResponse<T>) where T: Codable {
        do {
            let urlRequest = try createURLRequest(from: request)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    
                    if (200..<300).contains(httpResponse.statusCode) {
                        completion(.success(decodedObject))
                    } else {
                        completion(.failure(.failedResponse(decodedObject)))
                    }
                    
                } catch {
                    Logger.printDecodingError(error: error)
                    completion(.failure(.requestFailed(error)))
                }
            }
            task.resume()
            
        } catch {
            completion(.failure(.requestFailed(error)))
        }
    }

    private func createURLRequest(from request: NetworkRequest) throws -> URLRequest {
        guard let url = URL(string: request.urlString) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let parameters = request.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw NetworkError.invalidData
            }
        }
        
        Logger.printRequest(request: urlRequest)
        
        return urlRequest
    }
}
