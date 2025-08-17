//
//  MoviesViewController.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import Combine
import UIKit

class MoviesViewController: UIViewController {
    // MARK: - IBOutlets -

    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties -

    private let viewModel: MoviesViewModel

    var cancellable: Set<AnyCancellable> = []

    // MARK: - Initializer -

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MoviesViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle()
        self.setupTableView()
        self.addBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchPlayingData()
    }

    // MARK: - Design -

    func setupTitle() {
        self.navigationItem.title = "Movies"
    }

    private func addBinding() {
        self.viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &self.cancellable)

        self.viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.viewModel.showIndicator() : self.viewModel.hideIndicator()
            }
            .store(in: &self.cancellable)

        self.viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else { return }
                guard let _ = self else { return }
                print(error.localizedDescription)
            }
            .store(in: &self.cancellable)
    }
}

// MARK: - UITableView -

extension MoviesViewController {
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(cellType: MovieTableViewCell.self)
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = .init(top: 10, left: 0, bottom: 20, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = self.tableView.frame.height

        // 1) Don't trigger before first batch renders (prevents first-load fire)
        guard self.tableView.numberOfRows(inSection: 0) > 0 else { return }

        // 2) Only paginate when we actually have scrollable content
        guard contentHeight > frameHeight + 100 else { return } // small buffer

        // 3) Don't request while already loading
        guard !self.viewModel.loading else { return }

        // 4) Near-bottom threshold
        if offsetY > contentHeight - frameHeight - 200 {
            self.viewModel.fetchPlayingData()
        }
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieTableViewCell.self, for: indexPath)
        let item = self.viewModel.items[indexPath.row]
        cell.setData(item)
        cell.favoriteCompletionHandler = { [weak self] in
            guard let self = self else { return }
            var item = self.viewModel.remoteData[indexPath.row]
            if item.isFavorite == nil {
                item.isFavorite = false
                item.isFavorite?.toggle()
            } else  {
                item.isFavorite?.toggle()
            }
            self.viewModel.remoteData[indexPath.row] = item
            cell.setData(item)
            self.viewModel.updateIsFavorite(id: item.id ?? 0, value: item.isFavorite == true)
        }
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.viewModel.items[indexPath.row].id else { return }
        self.viewModel.MoviesFlow?.openDetails(id: id)
    }
}
