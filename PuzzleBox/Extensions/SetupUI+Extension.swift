//
//  SetupUI+Extension.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 14/06/25.
//

import UIKit

protocol SetupUI {
    func setupSubviews()
    func setupConstraints()
    func setupConfigure()
    func setup()
}

extension SetupUI {
    func setup() {
        setupSubviews()
        setupConstraints()
        setupConfigure()
    }
}
