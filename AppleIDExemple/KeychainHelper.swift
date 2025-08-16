//
//  KeychainHelper.swift
//  AppleIDExemple
//
//  Created by Vlad on 16/8/25.
//

import Foundation
import Security

/// A lightweight helper for storing and retrieving data securely in the Keychain.
/// This is used to persist sensitive information such as the Apple user identifier.
///
/// Keychain is encrypted, sandboxed, and persists across app launches and device restarts.
/// It is the recommended storage for authentication credentials on iOS.
final class KeychainHelper {
    
    /// Shared singleton instance for global access.
    static let shared = KeychainHelper()
    
    /// Private init ensures this helper is used only via the singleton.
    private init() {}
    
    /// Saves a string value securely in the Keychain.
    /// If an item already exists with the same service and account, it will be replaced.
    ///
    /// - Parameters:
    ///   - value: The string value to save (e.g., Apple user ID).
    ///   - service: A unique identifier for the service (e.g., "com.yourapp.auth").
    ///   - account: The account name to associate with this value (e.g., "appleUserID").
    func save(_ value: String, service: String, account: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecValueData as String   : data
        ]

        // Delete existing item if it exists
        SecItemDelete(query as CFDictionary)
        
        // Add the new value
        SecItemAdd(query as CFDictionary, nil)
    }

    /// Reads a string value securely from the Keychain.
    ///
    /// - Parameters:
    ///   - service: The service identifier.
    ///   - account: The account name.
    /// - Returns: The stored string if found, otherwise `nil`.
    func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            return value
        }
        return nil
    }

    /// Deletes an item from the Keychain.
    ///
    /// - Parameters:
    ///   - service: The service identifier.
    ///   - account: The account name.
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
