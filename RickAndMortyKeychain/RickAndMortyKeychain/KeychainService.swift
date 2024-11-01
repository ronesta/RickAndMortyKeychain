//
//  KeychainService.swift
//  RickAndMortyKeychain
//
//  Created by Ибрагим Габибли on 01.11.2024.
//

import Foundation
import KeychainSwift

final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    private let keychain = KeychainSwift()

    func saveCharactersToKeychain(characters: [Character]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(characters)
            if let jsonString = String(data: data, encoding: .utf8) {
                keychain.set(jsonString, forKey: "characters")
                print("Данные успешно сохранены в Keychain.")
            }
        } catch {
            print("Failed to encode characters: \(error.localizedDescription)")
        }
    }

    func loadCharactersFromKeychain() -> [Character]? {
        guard let jsonString = keychain.get("characters") else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }

        do {
            let decoder = JSONDecoder()
            let characters = try decoder.decode([Character].self, from: data)
            return characters
        } catch {
            print("Error decoding characters: \(error.localizedDescription)")
            return nil
        }
    }

    func saveImage(_ data: Data, key: String) {
        keychain.set(data, forKey: key)
    }

    func loadImage(key: String) -> Data? {
        return keychain.getData(key)
    }

    func clearImage(key: String) {
        keychain.delete(key)
    }
}
