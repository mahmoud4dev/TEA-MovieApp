//
//  AppCoordinator.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow!

    init(window: UIWindow) {
        self.window = window
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
    }

    public func start() {
        let service = MoviesService(networkManager: NetworkManager.shared)
        let local = MoviesLocalServiceManager(localDbManager: CoreDataManager.shared)
        let repository = MoviesRepository(movieService: service, movieLocalService: local)

        let moviesUseCase = DefaultMoviesUseCase(moviesRepository: repository)
        let moviesViewModel = MoviesViewModel(moviesUseCase: moviesUseCase)
        let moviesCoordinator = MoviesCoordinator(viewModel: moviesViewModel, window: window)
        moviesCoordinator.start()
    }
}
