//
//  MoviesCoordinator.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation
import UIKit

protocol MoviesFlow {
    func openDetails(id: Int)
}

class MoviesCoordinator: Coordinator, ObservableObject {
    var window: UIWindow
    var viewModel: MoviesViewModel!
    var navigationController: UINavigationController!

    init(viewModel: MoviesViewModel, window: UIWindow) {
        self.viewModel = viewModel
        self.window = window
        navigationController = UINavigationController()
    }

    func start() {
        viewModel.MoviesFlow = self
        let vc = MoviesViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

// MARK: - Navigation Flow Implementation -
extension MoviesCoordinator: MoviesFlow {
    func openDetails(id: Int) {
        let service = MoviesService(networkManager: NetworkManager.shared)
        let local = MoviesLocalServiceManager(localDbManager: CoreDataManager.shared)
        let repository = MoviesRepository(movieService: service, movieLocalService: local)
        let useCase = DefaultMovieDetailsUseCase(moviesRepository: repository)
        let viewModel = MovieDetailsViewModel(movieId: id, movieDetailsUseCase: useCase)
        let coordinator = MovieDetailsCoordinator(viewModel: viewModel, navigationController: navigationController)
        coordinator.start()
    }
}
