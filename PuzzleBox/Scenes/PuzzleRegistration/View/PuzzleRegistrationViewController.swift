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

