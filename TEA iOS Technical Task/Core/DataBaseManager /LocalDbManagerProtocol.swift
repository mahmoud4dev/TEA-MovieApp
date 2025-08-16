//
//  LocalDbManagerProtocol.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation

public protocol LocalDbManager {
    func saveObjects<T>(_ obj: [T])
    func getAllObjects<T>(_ type: T.Type, where query: String?) -> [T]
    func createEntity<T>(_: T.Type) -> T
    func updateObject<T>(_ type: T.Type, where query: String?, with values: [String: Any]) -> Bool
}
