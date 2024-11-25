//
//  NetworkManager.swift
//  RickAndMortyKeychain
//
//  Created by Ибрагим Габибли on 01.11.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    var counter = 1

    private let urlString = "https://rickandmortyapi.com/api/character"

    func getCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data else {
                print("No data")
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let character = try JSONDecoder().decode(PostCharacters.self, from: data)
                completion(.success(character.results))
                print("Load data", self.counter)
                self.counter += 1
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
