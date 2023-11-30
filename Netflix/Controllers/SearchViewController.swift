//
//  SearchViewController.swift
//  Netflix
//
//  Created by Евгений Езепчук on 9.10.23.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {

    private var movies: [Movie] = []
    var youTube: VideoElement?
    
    private var searchMovies: [Movie] = []
    
    private let discoverTable = {
        let table = UITableView()
        table.rowHeight = 40
        table.register(UpcomingMoviesTableViewCell.self, forCellReuseIdentifier: UpcomingMoviesTableViewCell.identifire)
        return table
    }()
    
    private let searchBar = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or a Tv show"
        controller.searchBar.tintColor = .white
        controller.searchBar.searchBarStyle = .minimal

        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .black
        title = "Search"
        view.backgroundColor = .black
        discoverTable.dataSource = self
        discoverTable.delegate = self
        navigationItem.searchController = searchBar
        fetchDiscoverMovies()
        view.addSubview(discoverTable)
        searchBar.searchResultsUpdater = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movies = movies[indexPath.row]
        guard let titleName = movies.original_title ?? movies.original_name else { return }
        APICaller.shared.getMovie(with: titleName + "trailer") { result in
            switch result {
            case .success(let videoElement):
                self.youTube = videoElement
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(TitlePreviewViewController(movie: movies, youTube: videoElement), animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMoviesTableViewCell.identifire, for: indexPath) as? UpcomingMoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let movies = movies[indexPath.row]
        cell.label.text = movies.original_name ?? movies.original_title ?? "Unowned"
        cell.label.textAlignment = .center
        cell.label.numberOfLines = 0
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(movies.poster_path!)")
        cell.images.sd_setImage(with: url)
  
//        URLSession.shared.dataTask(with: URLRequest(url: url!), completionHandler: { data, _, error in
//            guard let data = data, error == nil else { return }
//            DispatchQueue.main.async {
//                cell.image.image = UIImage(data: data)
//            }
//        }) .resume()
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.searchTextField.text
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty,
        text.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultController.delegate = self
        APICaller.shared.search(with: text) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    resultController.movies = movie
                    print(resultController.movies.count)
                    resultController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}

extension SearchViewController: DidSelectItemDelegate {
    func didSelect(movie: Movie, youTube: VideoElement) {
        DispatchQueue.main.async { [weak self] in
        let vc = TitlePreviewViewController(movie: movie, youTube: youTube)
        self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

