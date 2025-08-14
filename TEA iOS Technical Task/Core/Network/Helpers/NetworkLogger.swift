//
//  NetworkLogger.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 14/08/2025.
//

import Foundation

/// Utility class for logging network requests and responses.
class NetworkLogger {
    /// Logs a network request.
    ///
    /// - Parameter request: The network request to be logged.
    static func log(request: URLRequest) {
        print("➡️ Request: \(request.url?.absoluteString ?? "Unknown URL")")
        print("Method: \(request.httpMethod ?? "Unknown Method")")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody {
            if let prettyBody = prettyPrintJSON(data: body) {
                print("Body (JSON):\n\(prettyBody)")
            } else {
                print("Body (Raw): \(String(decoding: body, as: UTF8.self))")
            }
        }
    }
    
    /// Logs a network response and its data.
    ///
    /// - Parameters:
    ///   - response: The network response to be logged.
    ///   - data: The data received from the network response.
    static func log(response: URLResponse?, data: Data?) {
        if let httpResponse = response as? HTTPURLResponse {
            print("⬅️ Response: \(httpResponse.url?.absoluteString ?? "Unknown URL")")
            print("Status Code: \(httpResponse.statusCode)")
            
            if let headers = httpResponse.allHeaderFields as? [String: Any] {
                print("Headers: \(headers)")
            }
        } else {
            print("⬅️ Response: Unknown response.")
        }
        
        if let data = data {
            if let prettyBody = prettyPrintJSON(data: data) {
                print("Response Body (JSON):\n\(prettyBody)")
            } else if let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body (Raw): \(responseBody)")
            } else {
                print("Response Body: Unable to decode data.")
            }
        }
    }
    
    /// Logs an error that occurred during a network request.
    ///
    /// - Parameter error: The error to be logged.
    static func log(error: Error) {
        print("❌ Error: \(error.localizedDescription)")
    }
    
    /// Attempts to pretty-print JSON data.
    ///
    /// - Parameter data: The JSON data to pretty print.
    /// - Returns: A pretty-printed JSON string, or `nil` if the data cannot be parsed.
    private static func prettyPrintJSON(data: Data) -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(data: prettyData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
