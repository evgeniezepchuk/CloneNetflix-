//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by Евгений Езепчук on 9.10.23.
//

import UIKit

class UpcomingViewController: UIViewController {

    var movies: [Movie] = []
    var youTube: VideoElement?
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(UpcomingMoviesTableViewCell.self, forCellReuseIdentifier: UpcomingMoviesTableViewCell.identifire)
//        table.estimatedRowHeight = 40
//        table.rowHeight = 40

        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true 
        title = "Upcoming"
        
        view.addSubview(tableView)
        fetchUpcoming()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcoming { [weak self]  result in
            switch result {
            case .success(let titles):
                self?.movies = titles
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
//        APICaller.shared.getMovie(with: movies[IndexPath.row].original_name ?? "") { <#Result<VideoElement, Error>#> in
//            <#code#>
//        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMoviesTableViewCell.identifire, for: indexPath) as!  UpcomingMoviesTableViewCell
    
        
        
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
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
}
