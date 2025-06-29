//
//  Puzzle.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

// MARK: - Domain Model + UI

struct Puzzle: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var brand: String
    var pieceCount: Int
    var status: PuzzleStatus
    var type: PuzzleType
    var startDate: Date?
    var endDate: Date?
    var photoPath: String?
    var imageData: Data?

    var isTraveler: Bool {
        return type == .traveler
    }
}

// MARK: - Core Data Conversion

extension Puzzle {
    init(entity: PuzzleEntity) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? ""
        self.brand = entity.brand ?? ""
        self.pieceCount = Int(entity.pieceCount)
        self.status = PuzzleStatus(rawValue: entity.status ?? "") ?? .notStarted
        self.type = entity.isTraveler ? .traveler : .owned
        self.startDate = entity.startDate
        self.endDate = entity.endDate
        self.imageData = entity.imageData
    }
}

extension PuzzleEntity {
    func update(from model: Puzzle) {
        self.id = model.id
        self.name = model.name
        self.brand = model.brand
        self.pieceCount = Int64(model.pieceCount)
        self.status = model.status.rawValue
        self.isTraveler = model.type == .traveler
        self.startDate = model.startDate
        self.endDate = model.endDate
        self.imageData = model.imageData
    }
}

// MARK: - Puzzle Factory (Exemplo: integração com API externa)

extension Puzzle {
    static func from(result: PuzzleResult) -> Puzzle {
        return Puzzle(
            id: result.id ?? UUID(),
            name: result.name,
            brand: result.brand,
            pieceCount: result.pieceCount,
            status: .notStarted,
            type: .owned,
            startDate: nil,
            endDate: nil,
            imageData: nil
        )
    }
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
    var isTraveler: Bool {
        return self == .traveler
    }
}
