//
//  PuzzleRegistrationViewModel.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

protocol PuzzleRegistrationViewModelProtocol {
    var puzzle: Puzzle { get }
    func updateName(_ name: String)
    func updatePieces(_ count: Int)
    func updateStatus(_ status: Puzzle.PuzzleStatus)
    func updateType(_ type: Puzzle.PuzzleType)
    func updateStartDate(_ date: Date?)
    func updateEndDate(_ date: Date?)
    func updatePhoto(_ image: UIImage?)
}

final class PuzzleRegistrationViewModel: PuzzleRegistrationViewModelProtocol {
    public var puzzle = Puzzle(
        name: "",
        pieces: 0,
        status: .notStarted,
        type: .owned,
        startDate: nil,
        endDate: nil,
        photoPath: ""
    )
    
    public func updateName(_ name: String) {
        puzzle.name = name
    }

    public func updatePieces(_ count: Int) {
        puzzle.pieces = count
    }

    public func updateStatus(_ status: Puzzle.PuzzleStatus) {
        puzzle.status = status
    }

    public func updateType(_ type: Puzzle.PuzzleType) {
        puzzle.type = type
    }

    public func updateStartDate(_ date: Date?) {
        puzzle.startDate = date
    }

    public func updateEndDate(_ date: Date?) {
        puzzle.endDate = date
    }

    public func updatePhoto(_ image: UIImage?) {
        guard let image else { return }
        let fileName = "\(UUID().uuidString).jpg"
        
        if let filePath = saveImageToDocuments(image, named: fileName) {
            puzzle.photoPath = filePath
        }
    }

    @discardableResult
    private func saveImageToDocuments(_ image: UIImage, named fileName: String) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Falha ao converter UIImage em JPEG.")
            return nil
        }

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Não foi possível acessar o diretório de documentos.")
            return nil
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Erro ao salvar imagem em \(fileURL): \(error.localizedDescription)")
            return nil
        }
    }
}
