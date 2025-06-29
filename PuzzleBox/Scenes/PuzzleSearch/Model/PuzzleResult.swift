//
//  PuzzleResult.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 17/06/25.
//

import UIKit

struct PuzzleResult {
    let id: UUID?
    let name: String
    let brand: String
    let pieceCount: Int
    let imageData: Data?
    
    init(from entity: PuzzleEntity) {
        self.id = entity.id ?? nil
        self.name = entity.name ?? ""
        self.brand = entity.brand ?? ""
        self.pieceCount = Int(entity.pieceCount)
        self.imageData = entity.imageData
    }
}
