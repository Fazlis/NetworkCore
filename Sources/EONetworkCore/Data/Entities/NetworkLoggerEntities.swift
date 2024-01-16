//
//  File.swift
//  
//
//  Created by Iskandar Fazliddinov on 11/01/24.
//

import Foundation
import SwiftyJSON

struct Logger {
    
    static var startRequest = TimeInterval()
    static var endRequest = TimeInterval()
    
    static func printRequest(request: URLRequest) {
        startRequest = Date().timeIntervalSince1970
        let url = request.url?.absoluteString ?? ""
        
        #if DEBUG
        print("""
            ✴️⬇️
            URL: \(url);
            BODY: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "NO BODY DATA");
            HEADERS: \(request.allHTTPHeaderFields ?? [:]);
            ⬆️✴️
        """)
        #endif
        
    }
    
    static func printResponse(url: URL?, statusCode: Int, data: Data, method: String) {
        endRequest = Date().timeIntervalSince1970
        let urlStr = url?.absoluteString ?? ""
        let icon = statusCode == 200 ? "✅" : "❌"
        let json = try? JSONDecoder().decode(JSON.self, from: data)
        let jsonString = json?.rawString(.utf8, options: .prettyPrinted) ?? ""
        
        #if DEBUG
        print("""
            \(icon)⬇️
            URL: \(urlStr);
            STATUS CODE: \(statusCode);
            JSON: \(jsonString)
            ⬆️\(icon)
        """)
        #endif
        
        let interval = Double(round(1000 * (endRequest - startRequest)))
    }
    
    static func currentTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    static func printDecodingError(error: Error) {
        #if DEBUG
        print("""
            ❗️JSON decode error. Description: \(error.localizedDescription)❗️
        """)
        #endif
    }
}
