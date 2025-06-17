//
//  AppCoordinator.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

final class AppCoordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        route(to: .registration)
    }

    private func showPuzzleRegistration() {
        let registrationViewModel = PuzzleRegistrationViewModel()
        registrationViewModel.onEvent = { [weak self] event in
            self?.route(to: event)
        }
        let registrationVC = PuzzleRegistrationViewController(viewModel: registrationViewModel)

        navigationController.pushViewController(registrationVC, animated: false)
    }

    private func showPuzzleList(with puzzle: Puzzle? = nil) {
        let listViewModel = PuzzleListViewModel()
        if let puzzle = puzzle {
            PuzzleRepository.shared.save(puzzle)
            listViewModel.currentType = puzzle.type
            listViewModel.filterPuzzles(status: puzzle.status, type: puzzle.type)
        }

        let listVC = PuzzleListViewController(viewModel: listViewModel)
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func route(to event: AppEvent) {
        switch event {
        case .registration:
            showPuzzleRegistration()
            
        case .list(let puzzle):
            showPuzzleList(with: puzzle)
        }
    }
}

enum AppEvent {
    case registration
    case list(Puzzle)
}
