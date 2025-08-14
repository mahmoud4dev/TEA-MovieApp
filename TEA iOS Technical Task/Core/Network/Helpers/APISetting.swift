//
//  APISetting.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 14/08/2025.
//

import Foundation

enum EnvironmentVariables: String {
    case baseURL = "BASE_API_URL"
}

enum APISetting {
    // global variable from info.plist
    static var baseURL: String {
        getStringValueFromDict(key: .baseURL)
    }
}

func getStringValueFromDict(key: EnvironmentVariables) -> String {
    return Bundle.main.infoDictionary?[key.rawValue] as? String ?? ""
}
