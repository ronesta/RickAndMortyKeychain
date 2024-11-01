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
    private let keychain = KeychainSwift()

    private init() {}

    func saveCharacters(characters: [Character]) {
        do {
            let data = try JSONEncoder().encode(characters)
            if let jsonString = String(data: data, encoding: .utf8) {
                keychain.set(jsonString, forKey: "characters")
            }
        } catch {
            print("Failed to encode characters: \(error.localizedDescription)")
        }
    }

    func loadCharacters() -> [Character]? {
        guard let jsonString = keychain.get("characters"),
              let data = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            let characters = try JSONDecoder().decode([Character].self, from: data)
            return characters
        } catch {
            print("Error decoding characters: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteCharacters() {
        keychain.delete("characters")
        print("Characters have been removed from the keychain.")
    }

    func saveImage(_ data: Data, key: String) {
        keychain.set(data, forKey: key)
    }

    func loadImage(key: String) -> Data? {
        return keychain.getData(key)
    }

    func deleteImage(key: String) {
        keychain.delete(key)
    }
}
