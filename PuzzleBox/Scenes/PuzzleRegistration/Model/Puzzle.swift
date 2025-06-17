//
//  Puzzle.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

struct Puzzle: Codable {
    var id: UUID = UUID()
    var name: String
    var pieces: Int
    var status: PuzzleStatus
    var type: PuzzleType
    var startDate: Date?
    var endDate: Date?
    var photoPath: String?
}

enum PuzzleStatus: String, CaseIterable, Codable {
    case notStarted = "Aguardando"
    case inProgress = "Em montagem"
    case completed = "Montado"
    
    var displayName: String {
        switch self {
        case .notStarted: return "⏳ Aguardando"
        case .inProgress: return "🧩 Montando"
        case .completed: return "✅ Finalizado"
        }
    }
}

enum PuzzleType: String, CaseIterable, Codable {
    case owned = "Próprio"
    case traveler = "Viajante"

    var displayName: String {
        switch self {
        case .owned: 
            return "🔒 Próprios"
        case .traveler: 
            return "🌍 Viajantes"
        }
    }
}
