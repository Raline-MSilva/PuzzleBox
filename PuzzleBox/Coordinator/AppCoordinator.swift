//
//  AppCoordinator.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

protocol AppCoordinatorProtocol {
    func start()
    func route(to event: AppEvent)
}

final class AppCoordinator: AppCoordinatorProtocol {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSearch()
    }
    
    private func showSearch() {
        let viewModel = PuzzleSearchViewModel()
        viewModel.onEvent = { [weak self] event in
            self?.route(to: event)
        }
        
        let viewController = PuzzleSearchViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPuzzleRegistration(with puzzle: Puzzle? = nil) {
        let viewModel = PuzzleRegistrationViewModel(puzzle: puzzle)
        viewModel.onEvent = { [weak self] event in
            self?.route(to: event)
        }

        let viewController = PuzzleRegistrationViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPuzzleList(with puzzle: Puzzle? = nil) {
        let viewModel = PuzzleListViewModel()
        let viewController = PuzzleListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func route(to event: AppEvent) {
        switch event {
        case .search:
            showSearch()
        case .registration(let puzzle):
            showPuzzleRegistration(with: puzzle)
        case .list(let puzzle):
            showPuzzleList(with: puzzle)
        }
    }
}

enum AppEvent {
    case search
    case registration(Puzzle)
    case list(Puzzle)
}
