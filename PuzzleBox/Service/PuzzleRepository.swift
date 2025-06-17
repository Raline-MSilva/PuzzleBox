//
//  PuzzleRepository.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

final class PuzzleRepository {
    static let shared = PuzzleRepository()

    private let key = "saved_puzzles"

    private init() {}

    func save(_ puzzle: Puzzle) {
        var current = fetchAll()
        current.append(puzzle)
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func fetchAll() -> [Puzzle] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let puzzles = try? JSONDecoder().decode([Puzzle].self, from: data) else {
            return []
        }
        return puzzles
    }

    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
