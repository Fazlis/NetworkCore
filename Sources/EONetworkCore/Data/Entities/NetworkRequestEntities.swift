//
//  File.swift
//  
//
//  Created by Iskandar Fazliddinov on 11/01/24.
//

import Foundation


public protocol NetworkRequest {
    var urlString: String { get }
    var method: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
    case failedResponse(Codable)
}
