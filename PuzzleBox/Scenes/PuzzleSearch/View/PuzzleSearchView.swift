//
//  PuzzleSearchView.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 17/06/25.
//

import UIKit

protocol PuzzleSearchViewDelegate: AnyObject {
    func didSearchTextChange(_ text: String)
    func didSelectPuzzle(_ puzzle: PuzzleResult)
}

final class PuzzleSearchView: UIView {

    weak var delegate: PuzzleSearchViewDelegate?

    private var results: [PuzzleResult] = []

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar quebra-cabeça..."
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.returnKeyType = .done
        return sb
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PuzzleSearchCell.self, forCellReuseIdentifier: PuzzleSearchCell.identifier)
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateResults(_ newResults: [PuzzleResult]) {
        results = newResults
        tableView.reloadData()
    }
    
    @objc
    private func closeKeyboard() {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

// MARK: SetupUI

extension PuzzleSearchView: SetupUI {
    func setupSubviews() {
        addSubview(searchBar)
        addSubview(tableView)
    }

    func setupConfigure() {
        backgroundColor = .systemBackground
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PuzzleSearchCell.self, forCellReuseIdentifier: PuzzleSearchCell.identifier)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

extension PuzzleSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didSearchTextChange(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

extension PuzzleSearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let puzzle = results[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PuzzleSearchCell.identifier, for: indexPath) as? PuzzleSearchCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: puzzle)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let puzzle = results[indexPath.row]
        searchBar.resignFirstResponder()
        delegate?.didSelectPuzzle(puzzle)
    }
}
