//
//  SafeAccess+Extension.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
