//
//  MovieCell.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

import UIKit

class MovieCell: UICollectionViewCell {
    private var imageView = UIImageView()
    private let nameLabel = UILabel()
    private let genreLabel = UILabel()
    private var isFavoriteButton = UIButton()
    private let ratingLabel = UILabel()
    
    private let movieViewModel = MovieViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupImageView()
        setupNameLabel()
        setupGenreLabel()
        setupIsFavoriteButton()
        setupRatingLabel()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
    }
    
    func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentView.addSubview(nameLabel)
    }
    
    func setupGenreLabel() {
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.textColor = UIColor(red: 0.39, green: 0.45, blue: 0.58, alpha: 1)
        genreLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        contentView.addSubview(genreLabel)
    }
    
    func setupRatingLabel() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.21, alpha: 1)
        ratingLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        ratingLabel.textColor = .white
        ratingLabel.layer.masksToBounds = true
        ratingLabel.layer.cornerRadius = 4
        contentView.addSubview(ratingLabel)
    }
    
    func setupIsFavoriteButton() {
        isFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        isFavoriteButton.setImage(UIImage(named: "greyHeart"), for: .normal)
        isFavoriteButton.addAction(UIAction(handler: { [weak self] action in
            if let isFavorite = self?.movieViewModel.movie?.isFavorite {
                if isFavorite == true {
                    self?.movieViewModel.movie?.isFavorite = false
                    self?.isFavoriteButton.setImage(UIImage(named: "greyHeart"), for: .normal)
                } else {
                    self?.movieViewModel.movie?.isFavorite = true
                    self?.isFavoriteButton.setImage(UIImage(named: "heart"), for: .normal)
                }
            }
            
        }), for: .touchUpInside)
        contentView.addSubview(isFavoriteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            isFavoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            isFavoriteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            genreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(movie: Movie) async throws {
        if let imageUrl = movie.imageUrl {
            let imageData = try await movieViewModel.fetchCoverImage(imageUrl: imageUrl)
            if let imageData {
                let image = UIImage(data: imageData)
                imageView.image = image?.scalePreservingAspectRatio(targetSize: CGSize(width: 164, height: 230))
            }
        }
        
        nameLabel.text = movie.name
        genreLabel.text = movie.genre
        ratingLabel.text = "\(movie.rating)"
    }
}
