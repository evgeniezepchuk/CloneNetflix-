//
//  TitlePreviewViewController.swift
//  Netflix
//
//  Created by Евгений Езепчук on 21.10.23.
//

import UIKit
import SDWebImage
import WebKit

class TitlePreviewViewController: UIViewController {
    
    var movie: Movie
    var youTube: VideoElement?
   
    
    init(movie: Movie, youTube: VideoElement?) {
        self.movie = movie
        self.youTube = youTube
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Harry Potter"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.text = "This is the best movie ever to watch as a kid!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download", for: .normal)
//        button.frame = CGRect(x: 150, y: 450, width: 90, height: 35)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = movie.original_title
        overviewLabel.text = movie.overview
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .darkGray
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        addConstraints()
        
        DispatchQueue.main.async { [self] in
            guard let ve = self.youTube else { return }
            configure(with: ve)
        }
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110),
            downloadButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func configure(with youTube: VideoElement) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(youTube.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
    
    
}

