//
//  PuzzleSearchViewController.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 17/06/25.
//

import UIKit

final class PuzzleSearchViewController: UIViewController {

    private let customView = PuzzleSearchView()
    private var viewModel: PuzzleSearchViewModelProtocol
    weak var coordinator: AppCoordinator?

    init(viewModel: PuzzleSearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar Quebra-Cabeça"
        customView.delegate = self
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.didUpdateResults = { [weak self] results in
            DispatchQueue.main.async {
                self?.customView.updateResults(results)
            }
        }

        viewModel.didFailWithError = { error in
            print("Erro ao buscar puzzles: \(error.localizedDescription)")
        }

        viewModel.onEvent = { [weak self] event in
            self?.coordinator?.route(to: event)
        }
    }
}

extension PuzzleSearchViewController: PuzzleSearchViewDelegate {
    func didSearchTextChange(_ text: String) {
        viewModel.search(with: text)
        
    }

    func didSelectPuzzle(_ puzzle: PuzzleResult) {
        viewModel.selectResult(puzzle)
    }
}
