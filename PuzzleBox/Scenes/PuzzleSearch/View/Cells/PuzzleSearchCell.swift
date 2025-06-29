//
//  PuzzleSearchCell.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 18/06/25.
//

import UIKit

class PuzzleSearchCell: UITableViewCell {
    
    static let identifier = "PuzzleSearchCell"
    
    private let puzzleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .secondarySystemBackground // fallback visual
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        
        return stack
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Configuration
    
    func configure(with puzzle: PuzzleResult) {
        titleLabel.text = puzzle.name
        subtitleLabel.text = "\(puzzle.brand) • \(puzzle.pieceCount) peças"
        
        if let data = puzzle.imageData, let image = UIImage(data: data) {
            puzzleImageView.image = image
        } else {
            puzzleImageView.image = UIImage(systemName: "photo")
        }
    }
}

extension PuzzleSearchCell: SetupUI {
    func setupSubviews() {
        contentView.addSubview(puzzleImageView)
        contentView.addSubview(labelsStack)
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitleLabel)
    }

    func setupConfigure() {
        puzzleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.translatesAutoresizingMaskIntoConstraints = false

    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            puzzleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            puzzleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            puzzleImageView.widthAnchor.constraint(equalToConstant: 60),
            puzzleImageView.heightAnchor.constraint(equalToConstant: 60),
            
            labelsStack.leadingAnchor.constraint(equalTo: puzzleImageView.trailingAnchor, constant: 12),
            labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
