//
//  UpcomingMoviesTableViewCell.swift
//  Netflix
//
//  Created by Евгений Езепчук on 16.10.23.
//

import UIKit

class UpcomingMoviesTableViewCell: UITableViewCell {

    static let identifire = "UpcomingMoviesTableViewCell"
    
    var images = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var label = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let button = {
        var button = UIButton(type: .system)
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
//        button.addTarget(UpcomingMoviesTableViewCell.self, action: #selector(download), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(images)
        addSubview(label)
        addSubview(button)
        addConstraints()
        
        
    }
    
    @objc func download() {
        print("the movie was dowloaded")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        image.frame = bounds
        
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
//            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            images.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
//            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            images.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
//            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            images.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            images.widthAnchor.constraint(equalToConstant: 100),
            images.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(greaterThanOrEqualTo: image.leadingAnchor, constant: 20),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 120),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -100),
            label.heightAnchor.constraint(equalToConstant: 200)
//            label.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 340)
//            button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 5),
//            button.heightAnchor.constraint(equalToConstant: 20),
//            button.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    

}

extension UpcomingMoviesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    
    
    
}

// https://api.themoviedb.org/3/movie/upcoming?api_key=5b747ffde4e517423919372c6d69c681&language=en-US&page=1
