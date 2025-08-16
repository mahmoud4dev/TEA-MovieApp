//
//  MovieDetailsViewController.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak private var favoriteImageView: UIImageView!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var releaseDateLabel: UILabel!
    @IBOutlet weak private var totalNumberOfVotesLabel: UILabel!
    @IBOutlet weak private var overviewLabel: UILabel!
    @IBOutlet weak private var voteLabel: UILabel!

    //MARK: - Properties -
    private let viewModel: MovieDetailsViewModel
    var cancellable: Set<AnyCancellable> = []
    
    //MARK: - Initializer -
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle()
        self.addBinding()
        self.configureGestureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMovieDetails()
    }
    
    //MARK: - Design -
    func setupTitle() {
        self.navigationItem.title = "Movie Details"
    }
    
    func configureGestureUI() {
        favoriteImageView.addTapGesture { [weak self] in
            guard let self = self else {return}
            viewModel.updateIsFavorite()
        }
    }
    
    func setData(_ model: MovieDetailsData) {
        favoriteImageView.image = (model.isFavorite == true) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let imageBaseURL = "https://image.tmdb.org/t/p/w500"
        posterImageView.load(url: URL(string: imageBaseURL + (model.posterPath ?? "") ) ?? URL(fileURLWithPath: ""))
        posterImageView.layer.cornerRadius = 8
        nameLabel.text = model.title
        releaseDateLabel.text = model.releaseDate
        totalNumberOfVotesLabel.text = "\(model.voteCount ?? 0)"
        overviewLabel.text = model.overview
        voteLabel.text = String(format: "%.1f", model.voteAverage ?? 0.0)
    }
    
    //MARK: - Binding -
    private func addBinding() {
        self.viewModel.$detailsData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self = self else {return}
                guard let model = model else {return}
                setData(model)
            }
            .store(in: &cancellable)
        
        viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else {return}
                isLoading ? viewModel.showIndicator() : viewModel.hideIndicator()
            }
            .store(in: &cancellable)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else {return}
                guard let _ = self else {return}
                print(error.localizedDescription)
            }
            .store(in: &cancellable)
        
    }
}
