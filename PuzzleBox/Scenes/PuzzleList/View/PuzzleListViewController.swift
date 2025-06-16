//
//  PuzzleListViewController.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

final class PuzzleListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: PuzzleListViewModelProtocol
    private let puzzleListView = PuzzleListView()
    private var selectedStatus: PuzzleStatus = .notStarted
    private var selectedType: PuzzleType = .owned
    
    // MARK: - Init
    
    init(viewModel: PuzzleListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = puzzleListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quebra-Cabeças"
        puzzleListView.delegate = self
        setupTableView()
        puzzleListView.setSelectedStatus(selectedStatus)
        puzzleListView.setSelectedType(selectedType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.currentType = selectedType
        viewModel.filterPuzzles(status: selectedStatus, type: selectedType)
        
        puzzleListView.tableView.reloadData()
        
        puzzleListView.updateButtonTitles(counts: viewModel.countByStatus(for: selectedType))
        puzzleListView.updateTypeButtonTitles(counts: viewModel.countByType())
    }

    // MARK: - Setup
    
    private func setupTableView() {
        puzzleListView.tableView.delegate = self
        puzzleListView.tableView.dataSource = self
        puzzleListView.tableView.register(PuzzleListTableViewCell.self, forCellReuseIdentifier: PuzzleListTableViewCell.reuseIdentifier)
    }

}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension PuzzleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPuzzles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PuzzleListTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? PuzzleListTableViewCell else {
            return UITableViewCell()
        }
        let puzzle = viewModel.puzzle(at: indexPath.row)
        cell.configure(with: puzzle)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PuzzleListViewDelegate

extension PuzzleListViewController: PuzzleListViewDelegate {
    func didSelectStatus(_ status: PuzzleStatus) {
        selectedStatus = status
        viewModel.filterPuzzles(status: status, type: selectedType)
        puzzleListView.tableView.reloadData()

        puzzleListView.updateButtonTitles(counts: viewModel.countByStatus(for: selectedType))
        puzzleListView.updateTypeButtonTitles(counts: viewModel.countByType())
        
    }
    
    func didSelectType(_ type: PuzzleType) {
        selectedType = type
        viewModel.currentType = type
        viewModel.filterPuzzles(status: selectedStatus, type: selectedType)
        puzzleListView.tableView.reloadData()
        puzzleListView.updateButtonTitles(counts: viewModel.countByStatus(for: selectedType))
        puzzleListView.updateTypeButtonTitles(counts: viewModel.countByType())
    }
}
