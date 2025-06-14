//
//  Photo.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

final class PhotoPlaceholderView: UIView {

    // MARK: - Subviews

    private let borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = UIColor.systemBrown.cgColor
        view.backgroundColor = UIColor.systemGroupedBackground
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .systemBrown
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Adicionar Foto"
        label.textColor = .systemBrown
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Setup
    
extension PhotoPlaceholderView: SetupUI {
    func setupSubviews() {
        addSubview(borderView)
        borderView.addSubview(iconImageView)
        borderView.addSubview(label)
        borderView.addSubview(actionButton)
    }
    
    func setupConfigure() {
        borderView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconImageView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 52),
            iconImageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),

            label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            label.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),

            actionButton.topAnchor.constraint(equalTo: borderView.topAnchor),
            actionButton.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: borderView.bottomAnchor),
        ])
    }
    
}
