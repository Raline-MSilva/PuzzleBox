//
//  PuzzleListItem.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

struct PuzzleListItem {
    let id: UUID
    let name: String
    let brand: String
    let pieces: Int
    let imageURL: String
    let status: PuzzleStatus
    let type: PuzzleType
}
