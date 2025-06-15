//
//  PuzzleRegistrationViewController.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 06/05/25.
//

import UIKit

final class PuzzleRegistrationViewController: UIViewController, KeyboardHandling {
    
    private let puzzleView = PuzzleRegistrationView()
    private let viewModel: PuzzleRegistrationViewModelProtocol
    var scrollViewToAdjust: UIScrollView {
            return puzzleView.scrollView
        }
    
    init(viewModel: PuzzleRegistrationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = puzzleView
        puzzleView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
    }
    
    deinit {
        unregisterForKeyboardNotifications()
       }

}
extension PuzzleRegistrationViewController: PuzzleRegistrationViewDelegate {
    func didTapSaveButton() {
        print("Salvar quebra-cabeça")
    }
    
    func didTapPhotoButton() {
        print("Adicionar foto")
    }
    
    func didChangeName(_ name: String) {
        viewModel.updateName(name)
    }
    
    func didChangePieces(_ pieces: String) {
        if let count = Int(pieces) {
            viewModel.updatePieces(count)
        }
    }
    
    func didChangeStatus(index: Int) {
        guard let status = Puzzle.PuzzleStatus.allCases[safe: index] else { return }
        viewModel.updateStatus(status)
    }
    
}
