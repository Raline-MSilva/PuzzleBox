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

extension UIColor {
    static let puzzleBackground = UIColor(hex: "#F4F1E8")
    static let puzzlePrimaryText = UIColor(hex: "#22372B")
    static let puzzleBorder = UIColor(hex: "#C6A97E")
    static let puzzleBeige = UIColor(hex: "#E7DED1")
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
