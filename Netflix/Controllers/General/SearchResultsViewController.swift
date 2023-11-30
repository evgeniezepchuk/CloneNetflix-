//
//  SearchResultsViewController.swift
//  Netflix
//
//  Created by Евгений Езепчук on 17.10.23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    var movies: [Movie] = []
    var youTube: VideoElement?
    
    public weak var delegate: DidSelectItemDelegate?
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var numberOfItemPerRow: CGFloat = 3
        var width = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        view.backgroundColor = .black
        view.addSubview(searchResultsCollectionView)
        print(movies.count)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = "Upcoming"
//        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.searchResultsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}



extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
//        cell.delegate = self
        let image = UIImageView()
        image.center = cell.center
        let movies = movies[indexPath.row]
        let stringURL = "https://image.tmdb.org/t/p/w500\(movies.poster_path ?? "")"
        guard let url = URL(string: stringURL) else { fatalError("error from SearchResultsViewController") }
        cell.backgroundView = image
        URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                image.image = UIImage(data: data)
            }
        }).resume()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movies = movies[indexPath.row]
        let titleName = movies.original_title ?? ""
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.youTube = videoElement
                guard let videoId = self?.youTube else { return }
                print(videoId.id.videoId)
                DispatchQueue.main.async {
                    self?.delegate?.didSelect(movie: movies, youTube: videoId)
//                    self?.navigationController?.pushViewController(TitlePreviewViewController(movie: movies, youTube: videoId), animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
//        print(indexPath.row)
//        print(titleName)
    }
    
    
}

extension SearchResultsViewController: DidSelectItemDelegate {
    func didSelect(movie: Movie, youTube: VideoElement) {
        let vc = TitlePreviewViewController(movie: movie, youTube: youTube)
//        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
}
