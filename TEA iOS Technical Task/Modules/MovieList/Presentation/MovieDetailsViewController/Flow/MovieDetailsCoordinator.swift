//
//  MovieDetailsCoordinator.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Foundation
import UIKit

protocol MovieDetailsFlow {
    func back()
}

class MovieDetailsCoordinator: Coordinator, ObservableObject {
    var viewModel: MovieDetailsViewModel!
    var navigationController: UINavigationController!

    init(viewModel: MovieDetailsViewModel, navigationController: UINavigationController) {
        self.viewModel = viewModel
        self.navigationController = navigationController
    }

    func start() {
        viewModel.movieDetailsFlow = self
        let vc = MovieDetailsViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Navigation Flow Implementation -
extension MovieDetailsCoordinator: MovieDetailsFlow {
    func back() {
        navigationController.popViewController(animated: true)
    }
}
