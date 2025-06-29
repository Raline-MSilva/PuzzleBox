//
//  PuzzleSearchViewModel.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 17/06/25.
//

import UIKit
import CoreData

protocol PuzzleSearchViewModelProtocol {
    var didUpdateResults: (([PuzzleResult]) -> Void)? { get set }
    var didFailWithError: ((Error) -> Void)? { get set }
    var didSelectPuzzleModel: ((Puzzle) -> Void)? { get set }
    var filteredPuzzles: [Puzzle] { get }
    var onEvent: ((AppEvent) -> Void)? { get set }
    
    func search(with query: String)
    func selectResult(_ result: PuzzleResult)
}

final class PuzzleSearchViewModel: PuzzleSearchViewModelProtocol {

    var didUpdateResults: (([PuzzleResult]) -> Void)?
    var didFailWithError: ((Error) -> Void)?
    var didSelectPuzzleModel: ((Puzzle) -> Void)?
    var onEvent: ((AppEvent) -> Void)?
    var filteredPuzzles: [Puzzle] = []

    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataPuzzleRepository.shared.context) {
        self.context = context
    }

    func search(with query: String) {
        let request: NSFetchRequest<PuzzleEntity> = PuzzleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)

        do {
            let context = CoreDataPuzzleRepository.shared.context
            let entities = try context.fetch(request)

            entities.forEach {
                print("🧩 \($0.name ?? "Sem nome")")
            }

            let results = entities.map { PuzzleResult(from: $0) }
            didUpdateResults?(results)
        } catch {
            print("❌ Erro ao buscar quebra-cabeças: \(error.localizedDescription)")
            didUpdateResults?([])
        }
    }
    
    func selectResult(_ result: PuzzleResult) {
        let puzzle = Puzzle(
            id: UUID(),
            name: result.name,
            brand: result.brand,
            pieceCount: result.pieceCount,
            status: .notStarted,
            type: .owned,
            startDate: nil,
            endDate: nil,
            imageData: result.imageData
        )
        onEvent?(.registration(puzzle))
    }
}
