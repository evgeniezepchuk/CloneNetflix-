//
//  HeroHeader.swift
//  Netflix
//
//  Created by Евгений Езепчук on 10.10.23.
//

import UIKit

class HeroHeader: UIView {

    let views: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "heroImage")
        return view
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("play", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 7
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .clear
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("download", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 7
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .clear
        return button
    }()
    
    private func addGradiend() {
        let grad = CAGradientLayer()
        grad.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        grad.frame = bounds
        layer.addSublayer(grad)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(views)
        addGradiend()
        addSubview(playButton)
        addSubview(downloadButton)
        configureConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        views.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65),
            playButton.topAnchor.constraint(equalTo: topAnchor, constant: 350),
            playButton.widthAnchor.constraint(equalToConstant: 110),
            playButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -65),
            downloadButton.topAnchor.constraint(equalTo: topAnchor, constant: 350),
            downloadButton.widthAnchor.constraint(equalToConstant: 110),
            downloadButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    public func configure(with Poster_url: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(Poster_url)") else {
            return
        }
        
        views.sd_setImage(with: url)
    }
    

}
