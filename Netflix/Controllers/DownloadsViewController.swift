//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Евгений Езепчук on 9.10.23.
//

import UIKit

class DownloadsViewController: UIViewController {

 
    var movies: [DownloadedFilmDataBase] = []
    var videoElement: VideoElement? = nil
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UpcomingMoviesTableViewCell.self, forCellReuseIdentifier: UpcomingMoviesTableViewCell.identifire)
//        table.estimatedRowHeight = 40
//        table.rowHeight = 40

        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Downloads"
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchMoviesFromDataBase { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movies = movie
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMoviesTableViewCell.identifire, for: indexPath) as? UpcomingMoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let title = movies[indexPath.row]
        cell.label.text = title.original_title
//        print("poster_path ", title.poster_path)
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(title.poster_path!)") else { return UITableViewCell() }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    cell.images.image = UIImage(data: data)
                }
            }
        } .resume()
//        DispatchQueue.main.async {
//            cell.images.sd_setImage(with: url)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
//            tableView.deleteRows(at: [indexPath], with: .fade)
            DataPersistenceManager.shared.deleteTitleWith(model: movies[indexPath.row]) { result in
                switch result {
                case .success():
                    print("deleted from the data base")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
//                DispatchQueue.main.async {
//                    tableView.reloadData()
//                }
                
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let movies = movies[indexPath.row]
        guard let titleName = movies.original_title ?? movies.original_name else { return }
        APICaller.shared.getMovie(with: titleName + "trailer") { result in
            switch result {
            case .success(let videoElement):
                self.videoElement = videoElement
                DispatchQueue.main.async {
                    var movie = Movie(id: Int(movies.id), media_type: movies.media_type, original_name: movies.original_name, original_title: movies.original_title, poster_path: movies.poster_path, overview: movies.overview, vote_count: Int(movies.vote_count), release_date: movies.release_date, vote_average: movies.vote_average)
                    self.navigationController?.pushViewController(TitlePreviewViewController(movie: movie, youTube: videoElement), animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
