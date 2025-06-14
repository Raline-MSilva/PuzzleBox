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

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


protocol KeyboardHandling: AnyObject {
    var scrollViewToAdjust: UIScrollView { get }
    func registerForKeyboardNotifications()
    func unregisterForKeyboardNotifications()
}

extension KeyboardHandling where Self: UIViewController {

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let bottomInset = keyboardFrame.height - self.view.safeAreaInsets.bottom
        scrollViewToAdjust.contentInset.bottom = bottomInset + 16
        scrollViewToAdjust.verticalScrollIndicatorInsets.bottom = bottomInset
    }

    private func keyboardWillHide(_ notification: Notification) {
        scrollViewToAdjust.contentInset.bottom = 0
        scrollViewToAdjust.verticalScrollIndicatorInsets = .zero
    }
}
