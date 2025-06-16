//
//  Photo.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

final class PhotoPlaceholderView: UIView {

    // MARK: - Subviews

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .systemBrown
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let placeholderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Adicionar Foto", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Alterar Foto", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()
    
    var onPhotoTap: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
        let hasImage = image != nil
        placeholderButton.isHidden = hasImage
        changeButton.isHidden = !hasImage
        iconImageView.isHidden = hasImage
    }
    
    func resetImage() {
        setImage(nil)
    }
    
    @objc
    private func photoTapped() {
        onPhotoTap?()
    }

}

// MARK: - Setup
    
extension PhotoPlaceholderView: SetupUI {
    func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubview(imageView)
        addSubview(iconImageView)
        addSubview(placeholderButton)
        addSubview(changeButton)
        addSubview(actionButton)
    }
    
    func setupConfigure() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderButton.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            placeholderButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50),
            placeholderButton.widthAnchor.constraint(equalToConstant: 140),
            placeholderButton.heightAnchor.constraint(equalToConstant: 40),
            
            changeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            changeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            changeButton.widthAnchor.constraint(equalToConstant: 110),
            changeButton.heightAnchor.constraint(equalToConstant: 32),
            
            actionButton.topAnchor.constraint(equalTo: topAnchor),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
