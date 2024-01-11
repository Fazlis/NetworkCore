//  NetworkResponseEntities.swift
//  Created by Iskandar Fazliddinov on 11/01/24.

import Foundation


typealias NetworkResponse<T: Codable> = (Result<T, NetworkError>) -> Void
