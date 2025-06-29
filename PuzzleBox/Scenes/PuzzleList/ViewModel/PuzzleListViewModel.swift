//
//  PuzzleListViewModel.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

protocol PuzzleListViewModelProtocol {
    var allPuzzles: [PuzzleListItem] { get }
    var filteredPuzzles: [PuzzleListItem] { get }
    var currentStatus: PuzzleStatus { get set}
    var currentType: PuzzleType { get set }
    var puzzles: [Puzzle] { get set }
    
    func filterPuzzles(status: PuzzleStatus, type: PuzzleType)
    func countForStatus(_ status: PuzzleStatus) -> Int
    func puzzle(at index: Int) -> PuzzleListItem
    func countByStatus(for type: PuzzleType) -> [PuzzleStatus: Int]
    func countByType() -> [PuzzleType: Int]
    func addPuzzle(_ puzzle: Puzzle)
}

protocol PuzzleListViewModelDelegate: AnyObject {
    func didUpdateFilteredPuzzles()
}

final class PuzzleListViewModel: PuzzleListViewModelProtocol {
    // MARK: - Properties
    
    private(set) var allPuzzles: [PuzzleListItem] = []
    private(set) var filteredPuzzles: [PuzzleListItem] = []
    var puzzles: [Puzzle] = []
    
    internal var currentStatus: PuzzleStatus = .completed
    internal var currentType: PuzzleType = .owned
    
    var numberOfFilteredPuzzles: Int {
        return filteredPuzzles.count
    }
    var didUpdate: (() -> Void)?
    weak var delegate: PuzzleListViewModelDelegate?
    
    // MARK: - Init
    
    init() {
        filterPuzzles(status: .completed, type: .owned)
        didUpdate?()
    }

    func filterPuzzles(status: PuzzleStatus, type: PuzzleType) {
        currentStatus = status
        currentType = type

        filteredPuzzles = allPuzzles.filter { $0.status == status && $0.type == type }
 
        delegate?.didUpdateFilteredPuzzles()
    }

    func countForStatus(_ status: PuzzleStatus) -> Int {
        return allPuzzles.filter { $0.status == status }.count
    }
    
    func countByStatus(for type: PuzzleType) -> [PuzzleStatus: Int] {
        return PuzzleStatus.allCases.reduce(into: [:]) { result, status in
            result[status] = allPuzzles.filter { $0.status == status && $0.type == type }.count
        }
    }
    
    func countByType() -> [PuzzleType: Int] {
        return PuzzleType.allCases.reduce(into: [:]) { result, type in
            result[type] = allPuzzles.filter { $0.type == type }.count
        }
    }

    func puzzle(at index: Int) -> PuzzleListItem {
        return filteredPuzzles[index]
    }
    func addPuzzle(_ puzzle: Puzzle) {
        puzzles.append(puzzle)
    }
}
