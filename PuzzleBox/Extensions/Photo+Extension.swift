//
//  Photo+Extension.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

extension UIViewController {
    func presentPhotoPickerActionSheet(
        title: String = "Adicionar Foto",
        message: String = "Escolha uma opção",
        onCameraSelected: @escaping () -> Void,
        onGallerySelected: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Tirar Foto", style: .default) { _ in
                onCameraSelected()
            })
        }

        alert.addAction(UIAlertAction(title: "Escolher da Galeria", style: .default) { _ in
            onGallerySelected()
        })

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        // Evita crash no iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        present(alert, animated: true)
    }
}
