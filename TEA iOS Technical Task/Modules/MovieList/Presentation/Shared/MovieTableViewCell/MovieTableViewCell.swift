//
//  MovieTableViewCell.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //MARK: - IBOutlets -
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var favoriteImageView: UIImageView!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var rateLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!

    //MARK: - Properties -
    var favoriteCompletionHandler: (() -> Void)?
    
    //MARK: - AwakeFromNib -
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    //MARK: - Configuration -
    func configureUI() {
        selectionStyle = .none
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        favoriteImageView.addTapGesture { [weak self] in
            guard let self = self else {return}
            favoriteCompletionHandler?()
        }
    }
    
    func setData(_ model: MoviesListData) {
        favoriteImageView.image = model.isFavorite == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        titleLabel.text = model.title
        dateLabel.text = model.releaseDate
        rateLabel.text = String(format: "%.1f", model.voteAverage ?? 0.0)
        let imageBaseURL = "https://image.tmdb.org/t/p/w500"
        posterImageView.load(url: URL(string: imageBaseURL + (model.posterPath ?? "") ) ?? URL(fileURLWithPath: ""))
    }
}
