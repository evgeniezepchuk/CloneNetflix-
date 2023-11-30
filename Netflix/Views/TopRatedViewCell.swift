//
//  TopRatedViewCell.swift
//  Netflix
//
//  Created by Евгений Езепчук on 15.10.23.
//

import UIKit

class  TopRatedViewCell: UITableViewCell {
    
    static let identifire = "TopRatedViewCell"
    var movies: [Movie] = []
    var youTube: VideoElement?
    var delegate: DidSelectItemDelegate? = HomeViewController()
    var str = "https://image.tmdb.org/t/p/w500"
    
    let collectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TopRatedViewCell")
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    private func downloadMovieAt(indexPath: [IndexPath]) {
        DataPersistenceManager.shared.downloadMovieWith(model: movies[indexPath[0].row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                print("Downloaded data...")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension TopRatedViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedViewCell", for: indexPath)
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
        cell.backgroundView = image
        APICaller.shared.getTopRated(complition: { [weak self] result in
            switch result {
            case .success(let title):
                self?.movies = title
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(self?.movies[indexPath.row].poster_path ?? "")") else { return }
//                DispatchQueue.main.async {
//                    var image = UIImageView()
                    image.sd_setImage(with: url)
                    
//                }
//                URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, _, error in
//                    guard let data = data, error == nil else { return }
//                    DispatchQueue.main.async {
//                        view.image = UIImage(data: data)
//                        cell.backgroundView = view
//            
//                    }
//                }) .resume()
            case .failure(let error):
                print(error)
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movies = movies[indexPath.row]
        guard let titleName = movies.original_name ?? movies.original_title else { return }
        APICaller.shared.getMovie(with: titleName + "trailer") { result in
            switch result {
            case .success(let videoElement):
                print(videoElement.id)
                self.youTube = videoElement
                DispatchQueue.main.async {
                    self.delegate?.didSelect(movie: movies, youTube: videoElement)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
            let config = UIContextMenuConfiguration(actionProvider:  { [weak self] _ in
                let downloadAction = UIAction(title: "Download", state: .off) { [weak self] _ in
                    
                    self?.downloadMovieAt(indexPath: indexPaths)
//                    indexPaths[0].row
                }
                return UIMenu(title: "", options: .displayInline, children: [downloadAction])
            })
            return config
            
        
    }
}
