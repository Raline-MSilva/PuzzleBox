//
//  Puzzle.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

struct Puzzle {
    var id: UUID = UUID()
    var name: String
    var pieces: Int
    var status: PuzzleStatus
    var type: PuzzleType
    var startDate: Date?
    var endDate: Date?
    var photoPath: String?
}

enum PuzzleStatus: String, CaseIterable {
    case notStarted = "Aguardando"
    case inProgress = "Em montagem"
    case completed = "Montado"
}

enum PuzzleType: String, CaseIterable {
    case owned = "Próprio"
    case traveler = "Viajante"
}
