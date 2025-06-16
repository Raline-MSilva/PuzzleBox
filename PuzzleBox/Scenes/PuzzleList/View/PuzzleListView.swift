//
//  PuzzleListView.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

protocol PuzzleListViewDelegate: AnyObject {
    func didSelectStatus(_ status: PuzzleStatus)
    func didSelectType(_ type: PuzzleType)
}

final class PuzzleListView: UIView {
    
    // MARK: - UI Components
    
    private let statusStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    public let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PuzzleListTableViewCell.self, forCellReuseIdentifier: PuzzleListTableViewCell.reuseIdentifier)
        return table
    }()
    
    private let typeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()

    private var typeButtons: [UIButton] = []
    private let types: [PuzzleType] = PuzzleType.allCases
    private var selectedType: PuzzleType = .owned
    
    private var statusButtons: [UIButton] = []
    private let statuses: [PuzzleStatus] = [.notStarted, .inProgress, .completed]
    private var selectedStatus: PuzzleStatus = .completed
    
    weak var delegate: PuzzleListViewDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupStatusButtons()
        setupTypeButtons()
        setSelectedStatus(selectedStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func updateButtonTitles(counts: [PuzzleStatus: Int]) {
        for (index, status) in statuses.enumerated() {
            let count = counts[status] ?? 0
            let button = statusButtons[index]
            button.accessibilityLabel = "\(status.displayName), \(count) quebra-cabeças"
            button.setTitle("\(status.displayName) (\(count))", for: .normal)
        }
    }
    
    func updateTypeButtonTitles(counts: [PuzzleType: Int]) {
        for (index, type) in types.enumerated() {
            let count = counts[type] ?? 0
            let button = typeButtons[index]
            button.accessibilityLabel = "\(type.displayName), \(count) quebra-cabeças"
            button.setTitle("\(type.displayName) (\(count))", for: .normal)
        }
    }
    
    public func setSelectedStatus(_ status: PuzzleStatus) {
        for (index, s) in statuses.enumerated() {
            let isSelected = s == status
            let button = statusButtons[index]
            button.backgroundColor = isSelected ? .systemBlue : .systemGray5
            button.setTitleColor(isSelected ? .white : .darkGray, for: .normal)
        }
    }
    
    public  func setSelectedType(_ type: PuzzleType) {
        for (index, t) in types.enumerated() {
            let isSelected = t == type
            let button = typeButtons[index]
            button.backgroundColor = isSelected ? .systemGreen : .systemGray5
            button.setTitleColor(isSelected ? .white : .darkGray, for: .normal)
        }
    }
    
    // MARK: - Private
    
    private func setupStatusButtons() {
        statuses.forEach { status in
            let button = UIButton(type: .system)
            button.setTitle(status.displayName, for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 8
            button.backgroundColor = .systemGray5
            button.addTarget(self, action: #selector(statusButtonTapped(_:)), for: .touchUpInside)
            button.accessibilityIdentifier = "statusButton_\(status.rawValue)"
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            statusStackView.addArrangedSubview(button)
            statusButtons.append(button)
        }
    }
    
    private func setupTypeButtons() {
        types.forEach { type in
            let button = UIButton(type: .system)
            button.setTitle(type.displayName, for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 8
            button.backgroundColor = .systemGray5
            button.addTarget(self, action: #selector(typeButtonTapped(_:)), for: .touchUpInside)
            button.accessibilityIdentifier = "typeButton_\(type.rawValue)"
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            typeStackView.addArrangedSubview(button)
            typeButtons.append(button)
        }
        setSelectedType(selectedType)
    }

    
    
    @objc
    private func statusButtonTapped(_ sender: UIButton) {
        guard let index = statusButtons.firstIndex(of: sender) else { return }
        let tappedStatus = statuses[index]
        guard tappedStatus != selectedStatus else { return }
        
        selectedStatus = tappedStatus
        setSelectedStatus(selectedStatus)
        delegate?.didSelectStatus(selectedStatus)
    }
    
    @objc
    private func typeButtonTapped(_ sender: UIButton) {
        guard let index = typeButtons.firstIndex(of: sender) else { return }
        let tappedType = types[index]
        guard tappedType != selectedType else { return }
        
        selectedType = tappedType
        setSelectedType(selectedType)
        delegate?.didSelectType(selectedType)
    }
    
    
}

// MARK: SetupUI

extension PuzzleListView: SetupUI {
    func setupSubviews() {
        addSubview(typeStackView)
        addSubview(statusStackView)
        addSubview(tableView)
    }
    
    func setupConfigure() {
        backgroundColor = .systemBackground
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        typeStackView.translatesAutoresizingMaskIntoConstraints = false // ← Faltava isso
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            typeStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            typeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            statusStackView.topAnchor.constraint(equalTo: typeStackView.bottomAnchor, constant: 8),
            statusStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            typeStackView.heightAnchor.constraint(equalToConstant: 40),
            statusStackView.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
