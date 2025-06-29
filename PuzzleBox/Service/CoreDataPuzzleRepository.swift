//
//  PuzzleRepository.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import CoreData
import UIKit

protocol PuzzleRepositoryProtocol {
    func save(_ puzzle: Puzzle)
    func fetchAll() -> [Puzzle]
    func update(_ puzzle: Puzzle)
    func delete(_ puzzle: Puzzle)
}

class CoreDataPuzzleRepository {
    public static let shared = CoreDataPuzzleRepository()

    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "PuzzleBox")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Erro ao carregar o Core Data: \(error.localizedDescription)")
            }
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Erro ao salvar o contexto: \(error.localizedDescription)")
            }
        }
    }
    
    func seedInitialPuzzlesIfNeeded() {
        let request: NSFetchRequest<PuzzleEntity> = PuzzleEntity.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            guard count == 0 else { return }

            if let gastonImage = UIImage(named: "gaston")?.pngData(),
               let mafaldaImage = UIImage(named: "mafalda")?.pngData() {
                let puzzles: [(name: String, brand: String, pieces: Int, imageName: Data, status: PuzzleStatus, type: PuzzleType)] = [
                    ("Gaston", "Ravensburger", 1000, gastonImage, .completed, .traveler),
                    ("Mafalda", "Clementoni", 1000, mafaldaImage, .completed, .traveler)
                ]
                
                
                puzzles.forEach { data in
                    let entity = PuzzleEntity(context: context)
                    entity.name = data.name
                    entity.brand = data.brand
                    entity.pieceCount = Int64(Int32(data.pieces))
                    entity.imageData = data.imageName
                    entity.status = data.status.rawValue
                }
            }
            
            
            try context.save()
            print("✅ Dados iniciais inseridos com sucesso!")
            
        } catch {
            print("❌ Erro ao inserir dados iniciais: \(error)")
        }
    }
}
