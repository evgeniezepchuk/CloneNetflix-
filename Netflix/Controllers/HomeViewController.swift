//
//  HomeViewController.swift
//  Netflix
//
//  Created by Евгений Езепчук on 9.10.23.
//

import UIKit
import SDWebImage

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

protocol AlertErrorDelegate {
    func showAlert(message: String)
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Movie?
    var movie: [Movie]?
    private var headerView = HeroHeader()
    var vi: VideoElement?

    
    
    let headerText: [String] = ["Trending movies", "Trending TV", "Popular", "Upcoming Movies", "Top rated"]
    
    
    let tableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.register(TrendingMoviesViewCell.self, forCellReuseIdentifier: TrendingMoviesViewCell.identifire)
        tb.register(PopularViewCell.self, forCellReuseIdentifier: PopularViewCell.identifire)
        tb.register(TrendingTvViewCell.self, forCellReuseIdentifier: TrendingTvViewCell.identifire)
        tb.register(TopRatedViewCell.self, forCellReuseIdentifier: TopRatedViewCell.identifire)
        tb.register(UpcomingMoviesViewCell.self, forCellReuseIdentifier: UpcomingMoviesViewCell.identifire)
        
        
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        headerView = HeroHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 450))
//        headerView.views.image = UIImage(named: "heroImage")
        headerView.views.image = UIImage(systemName: "heart")
        configureHeroHeaderView()
        headerView.playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        headerView.downloadButton.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        
        tableView.tableHeaderView = headerView
        view.backgroundColor = .black
        view.addSubview(tableView)
        configureHeroHeaderView()
        configureBar()
        addVI()
    }
    
    @objc func downloadAction() {
        let ac = UIAlertController(title: "dss", message: "dada", preferredStyle: .alert)
        self.present(ac, animated: true)
    }
    
    func addVI(){
        APICaller.shared.getMovie(with: randomTrendingMovie?.original_title ?? "") { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.vi = videoElement
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func playAction() {
        if randomTrendingMovie != nil && vi != nil {
            navigationController?.pushViewController(TitlePreviewViewController(movie: randomTrendingMovie!, youTube: vi!), animated: true)
        } else {
            return
        }
    }
    
    private func configureHeroHeaderView() {
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView.configure(with: self?.randomTrendingMovie?.poster_path ?? "")
                guard let titleName = self?.randomTrendingMovie!.original_name ?? self?.randomTrendingMovie!.original_title else { return }
                APICaller.shared.getMovie(with: titleName + "trailer") { result in
                    switch result {
                    case .success(let videoElement):
                        self?.vi = videoElement
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
//        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func configureBar() {
        var image = UIImage(named: "netflix")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
                                              UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)]
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingMoviesViewCell.identifire, for: indexPath) as? TrendingMoviesViewCell else {
        //            return UITableViewCell()
        //        }
        
        //         return cell
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingMoviesViewCell.identifire, for: indexPath) as? TrendingMoviesViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            //            APICaller.shared.getTrendingMovies { result in
            //                switch result {
            //                case .success(let movie):
            ////                    self?.movie = movie
            //                    cell.configure(with: movie)
            //                case .failure(let error):
            //                    print(error.localizedDescription)
            //                }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTvViewCell.identifire, for: indexPath) as? TrendingTvViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            //            }
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularViewCell.identifire, for: indexPath) as? PopularViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            //            APICaller.shared.getTrendingTv { result in
            //                switch result {
            //                case .success(let movie):
            ////                    self?.movie = movie
            //                    cell.configure(with: movie)
            //                case .failure(let error):
            //                    print(error.localizedDescription)
            //                }
            //            }
            
            //            APICaller.shared.getTrendingPopular { result in
            //                switch result {
            //                case .success(let movie):
            ////                    self?.movie = movie
            //                    cell.configure(with: movie)
            //                case .failure(let error):
            //                    print(error.localizedDescription)
            //                }
            //            }
        case 3 :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMoviesViewCell.identifire, for: indexPath) as? UpcomingMoviesViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            
        case 4 :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopRatedViewCell.identifire, for: indexPath) as? TopRatedViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
            //            APICaller.shared.getUpcoming { result in
            //                switch result {
            //                case .success(let movie):
            ////                    self?.movie = movie
            //                    cell.configure(with: movie)
            //                case .failure(let error):
            //                    print(error.localizedDescription)
            //                }
            //            }
            
            
            //                APICaller.shared.getTopRated { result in
            //                    switch result {
            //                    case .success(let movie):
            //                        //                    self?.movie = movie
            //                        cell.configure(with: movie)
            //                    case .failure(let error):
            //                        print(error.localizedDescription)
            //                    }
            //                }
            
        default:
            return UITableViewCell()
        }
    }
    //        return cell
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return headerText.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
         
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = headerText[section]
        header.font = UIFont.systemFont(ofSize: 18,weight: .medium)
        header.frame = CGRect(x: 10, y: 0, width: Int(view.frame.width) / 2, height: 15)
        return header
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
    }
    
}

extension HomeViewController: DidSelectItemDelegate, AlertErrorDelegate {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        print(message, " errrrrr")
//        alert.addAction(UIAlertAction(title: "ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            
            self?.present(alert, animated: true)
        }
    }
    
    func didSelect(movie: Movie, youTube: VideoElement) {
        let vc = TitlePreviewViewController(movie: movie, youTube: youTube)
        
//        guard let vc = vc else { return }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    
   
}
