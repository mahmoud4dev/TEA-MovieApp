//
//  CodableExt.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 14/08/2025.
//

import Foundation

extension Encodable {
    typealias JSON = [String: Any]
    
    func toString() -> String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

public extension String {
    func toObject<T: Decodable>() -> T? {
        do {
            let decoder = JSONDecoder()
            let jsonData = data(using: .utf8)!
            let parsedData = try decoder.decode(T.self, from: jsonData)
            return parsedData
        } catch {
            print(error)
        }
        return nil
    }
    
    func toDictionary() -> [String: AnyObject]? {
        if let data = data(using: .utf8) {
            do {
                let json = try JSONSerialization
                    .jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json
            } catch {
                print(error)
            }
        }
        return nil
    }
}
