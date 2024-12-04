//
//  KeychainService.swift
//  RickAndMortyKeychain
//
//  Created by Ибрагим Габибли on 01.11.2024.
//

import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    private let queue = DispatchQueue(label: "KeychainServiceQueue")
    private let charactersKey = "characters"

    private init() {}

    func saveCharacters(characters: [Character]) {
        do {
            let data = try JSONEncoder().encode(characters)
            let status = saveData(data, forKey: charactersKey)

            if status != errSecSuccess {
                print("Failed to save characters to keychain. Error code: \(status)")
            }
        } catch {
            print("Failed to encode characters: \(error.localizedDescription)")
        }
    }

    func loadCharacters() -> [Character]? {
        guard let data = loadData(forKey: charactersKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode([Character].self, from: data)
        } catch {
            print("Failed to decode characters: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteCharacters() {
        deleteData(forKey: charactersKey)
        print("Characters have been removed from the keychain.")
    }

    func saveImage(_ data: Data, key: String) {
        let status = saveData(data, forKey: key)

        if status != errSecSuccess {
            print("Failed to save image to keychain. Error code: \(status)")
        }
    }

    func loadImage(key: String) -> Data? {
        return loadData(forKey: key)
    }

    func deleteImage(key: String) {
        deleteData(forKey: key)
    }
}

// MARK: - Private Keychain Helpers
extension KeychainService {
    private func saveData(_ data: Data, forKey key: String) -> OSStatus {
        return queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]

            SecItemDelete(query as CFDictionary)

            return SecItemAdd(query as CFDictionary, nil)
        }
    }

    private func loadData(forKey key: String) -> Data? {
        return queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)

            if status == errSecSuccess {
                return result as? Data
            } else {
                print("Failed to load data for key \(key). Error code: \(status)")
                return nil
            }
        }
    }

    private func deleteData(forKey key: String) {
        return queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]

            let status = SecItemDelete(query as CFDictionary)

            if status != errSecSuccess && status != errSecItemNotFound {
                print("Failed to delete data for key \(key). Error code: \(status)")
            }
        }
    }
}
