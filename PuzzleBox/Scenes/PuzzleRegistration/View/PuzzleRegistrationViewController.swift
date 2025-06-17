//
//  PuzzleRegistrationViewController.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 06/05/25.
//

import UIKit

final class PuzzleRegistrationViewController: UIViewController, KeyboardHandling {
    
    public let puzzleView = PuzzleRegistrationView()
    private let viewModel: PuzzleRegistrationViewModelProtocol
    private let imagePicker = UIImagePickerController()
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        puzzleView.delegate = self

        registerForKeyboardNotifications()
    }
    
    deinit {
        unregisterForKeyboardNotifications()
       }

}
extension PuzzleRegistrationViewController: PuzzleRegistrationViewDelegate {
    func didTapSaveButton() {
        viewModel.updateName(puzzleView.nameField.text ?? "")
        viewModel.updatePieces(Int(puzzleView.piecesField.text ?? "") ?? 0)
        viewModel.updateStatus(PuzzleStatus.allCases[puzzleView.statusControl.selectedSegmentIndex])
        viewModel.updateType(.owned)
        viewModel.updatePhoto(puzzleView.photoView.imageView.image)

        let newPuzzle = viewModel.puzzle
        
        // Salva no repositório
        PuzzleRepository.shared.save(newPuzzle)
        viewModel.saveTapped()
    }
    
    func didTapPhotoButton() {
        presentPhotoPickerActionSheet(
            onCameraSelected: { [weak self] in
                self?.presentImagePicker(sourceType: .camera)
            },
            onGallerySelected: { [weak self] in
                self?.presentImagePicker(sourceType: .photoLibrary)
            }
        )
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
        guard let status = PuzzleStatus.allCases[safe: index] else { return }
        viewModel.updateStatus(status)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
}

extension PuzzleRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage

        guard let image = selectedImage else {
            picker.dismiss(animated: true)
            return
        }

        puzzleView.setPhotoImage(image)

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

