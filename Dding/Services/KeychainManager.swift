//
//  KeychainManager.swift
//  Dding
//
//  Created by 이지은 on 12/4/24.
//

import KeychainSwift

class KeychainManager {
    static let shared = KeychainManager()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    private enum Key {
        static let userIdentifier = "userIdentifier"
        static let userEmail = "userEmail"
    }
    
    func saveUserKeychain(_ identifier: String, _ email: String) {
        keychain.set(identifier, forKey: Key.userIdentifier)
        keychain.set(email, forKey: Key.userEmail)
    }
    
    func saverUserEmail(_ email: String) {
        keychain.set(email, forKey: Key.userEmail)
    }
    
    func getUserIdentifier() -> String? {
        return keychain.get(Key.userIdentifier)
    }
    
    func getUserEmail() -> String? {
        return keychain.get(Key.userEmail)
    }
    
    func deleteUserKeychain() {
        keychain.clear()
    }
    
    func delete(forKey key: String) {
        keychain.delete(key)
    }
}
