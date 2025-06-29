//
//  PuzzleRegistrationView.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

protocol PuzzleRegistrationViewDelegate: AnyObject {
    func didTapSaveButton()
    func didTapPhotoButton()
    func didChangeName(_ name: String)
    func didChangePieces(_ pieces: String)
    func didChangeStatus(index: Int)
    func didChangeType(index: Int)
}

final class PuzzleRegistrationView: UIView {
    
    // MARK: - Deleagte
    
    public weak var delegate: PuzzleRegistrationViewDelegate?
    
    // MARK: - UI Elements
    
    public let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    private let headerStack = UIStackView()
    private let contentStack = UIStackView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cadastrar Quebra-Cabeça"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityLabel = "Cadastrar Quebra-Cabeça"
        return label
    }()
    
    public let photoView = PhotoPlaceholderView()
    public let nameField = PuzzleTextField(placeholder: "Nome")
    public let brandField = PuzzleTextField(placeholder: "Marca")
    public let piecesField = PuzzleTextField(placeholder: "Número de Peças")
    
    private let statusGroupStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let typeGroupStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Tipo"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    public let typeControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["📦 Próprio", "🚚 Viajante"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = UIColor.systemGroupedBackground
        control.selectedSegmentTintColor = UIColor.systemOrange
        control.accessibilityLabel = "Tipo do Quebra-Cabeça"
        return control
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    public let statusControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["⏳ Aguardando", "🧩 Montando", "✅ Finalizado"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = UIColor.systemGroupedBackground
        control.selectedSegmentTintColor = UIColor.systemOrange
        control.accessibilityLabel = "Status do Quebra-Cabeça"
        return control
    }()
    
    private let startDateField = PuzzleTextField(placeholder: "Data de Início")
    private let endDateField = PuzzleTextField(placeholder: "Data de Fim")
    
    private let dateStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.accessibilityLabel = "Salvar quebra-cabeça"
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleSaveButton() {
        delegate?.didTapSaveButton()
    }
    
    @objc
    private func handlePhotoButton() {
        delegate?.didTapPhotoButton()
    }
    
    @objc
    private func nameFieldChanged(_ sender: UITextField) {
        delegate?.didChangeName(sender.text ?? "")
    }
    
    @objc
    private func piecesFieldChanged(_ sender: UITextField) {
        delegate?.didChangePieces(sender.text ?? "")
    }
    
    @objc
    private func statusChanged(_ sender: UISegmentedControl) {
        delegate?.didChangeStatus(index: sender.selectedSegmentIndex)
    }
    
    @objc
    private func typeChanged(_ sender: UISegmentedControl) {
        delegate?.didChangeType(index: sender.selectedSegmentIndex)
    }
    
    private func configureActions() {
        saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        photoView.actionButton.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        nameField.addTarget(self, action: #selector(nameFieldChanged), for: .editingChanged)
        piecesField.addTarget(self, action: #selector(piecesFieldChanged), for: .editingChanged)
        statusControl.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
        typeControl.addTarget(self, action: #selector(typeChanged), for: .valueChanged)
    }
    
    private func makeSpacer(height: CGFloat = 12) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }
    
    func setPhotoImage(_ image: UIImage?) {
        photoView.setImage(image)
    }
    
    func fillForm(with model: Puzzle) {
        nameField.text = model.name
        brandField.text = model.brand
        piecesField.text = "\(model.pieceCount)"
        
        // Corrigindo enums -> índice do segmented control
        if let statusIndex = PuzzleStatus.allCases.firstIndex(of: model.status) {
            statusControl.selectedSegmentIndex = statusIndex
        }

        if let typeIndex = PuzzleType.allCases.firstIndex(of: model.type) {
            typeControl.selectedSegmentIndex = typeIndex
        }
        
        // Convertendo imageData -> UIImage
        let image = model.imageData.flatMap { UIImage(data: $0) }
        setPhotoImage(image)

        // Converter datas para string
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "pt_BR")

        if let start = model.startDate {
            startDateField.text = formatter.string(from: start)
        }

        if let end = model.endDate {
            endDateField.text = formatter.string(from: end)
        }
    }
}
// MARK: - SetupUI

extension PuzzleRegistrationView: SetupUI {

    func setupSubviews() {
        
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)

        headerStack.addArrangedSubview(photoView)

        typeGroupStack.addArrangedSubview(typeLabel)
        typeGroupStack.addArrangedSubview(typeControl)

        statusGroupStack.addArrangedSubview(statusLabel)
        statusGroupStack.addArrangedSubview(statusControl)

        dateStack.addArrangedSubview(startDateField)
        dateStack.addArrangedSubview(endDateField)

        contentStack.addArrangedSubview(nameField)
        contentStack.addArrangedSubview(brandField)
        contentStack.addArrangedSubview(piecesField)
        contentStack.addArrangedSubview(typeGroupStack)
        contentStack.addArrangedSubview(statusGroupStack)
        contentStack.addArrangedSubview(dateStack)
        contentStack.addArrangedSubview(saveButton)

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(headerStack)
        mainStackView.addArrangedSubview(contentStack)
    }

    func setupConfigure() {
        backgroundColor = .puzzleBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        piecesField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.keyboardDismissMode = .interactive
        titleLabel.textColor = .puzzlePrimaryText

        mainStackView.axis = .vertical
        mainStackView.spacing = 32
        
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
        mainStackView.isLayoutMarginsRelativeArrangement = true

        headerStack.axis = .vertical
        headerStack.spacing = 24

        contentStack.axis = .vertical
        contentStack.spacing = 20


    }

    func setupConstraints() {

        NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

                mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

                mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

                photoView.heightAnchor.constraint(equalToConstant: 180),
                saveButton.heightAnchor.constraint(equalToConstant: 50),
            ])
    }
}

// MARK: - Custom Field

final class PuzzleTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = .black
        self.textColor = .puzzlePrimaryText
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.puzzleBorder.cgColor
        self.setLeftPaddingPoints(10)

        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
        self.accessibilityLabel = placeholder
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
