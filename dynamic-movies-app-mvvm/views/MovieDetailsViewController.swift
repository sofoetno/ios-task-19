//
//  MovieDetailsViewController.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    private let movieImage = UIImageView()
    private let ratingLabel = UILabel()
    private let imdbLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let detailsStack = UIStackView()
    private let selecTButton = UIButton()
    
    private let movieViewModel = MovieViewModel()
    
    var movieId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1)
        
        Task {
            do {
                try await movieViewModel.fetchData(id: movieId ?? 0)
                updateData()
            } catch {
                print(error)
            }
        }
        
        setupNavigationBar()
        
        setupMovieImage()
        setupRatingLabel()
        setupImdbLabel()
        setupDescriptionLabel()
        setupDetails()
        setupSelectButton()
        
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        imdbLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        selecTButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    func updateData() {
        title = movieViewModel.movie?.name
        ratingLabel.text = "\(movieViewModel.movie?.rating ?? 0)"
        descriptionLabel.text = movieViewModel.movie?.description
    
        if let imageData = movieViewModel.movie?.coverImageData {
            movieImage.image = UIImage(data: imageData)
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(backToMain))
    }
    
    @objc func backToMain() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupMovieImage() {
        movieImage.contentMode = .scaleAspectFit
        view.addSubview(movieImage)
    }
    
    func setupRatingLabel() {
        ratingLabel.textColor = .white
        ratingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(ratingLabel)
    }
    
    func setupImdbLabel() {
        imdbLabel.text = "IMDB"
        imdbLabel.textColor = UIColor(red: 0.39, green: 0.45, blue: 0.58, alpha: 1)
        imdbLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(imdbLabel)
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.textColor = .white
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(descriptionLabel)
    }
    
    func setupDetails() {
        detailsStack.axis = .vertical
        detailsStack.spacing = 12
        
        if let details = movieViewModel.movie?.details {
            for detail in details {
                let label = UILabel()
                label.text = detail.0
                label.textColor = UIColor(red: 0.389, green: 0.452, blue: 0.58, alpha: 1)
                label.font = UIFont.systemFont(ofSize: 14)
                
                let value = UILabel()
                value.text = detail.1
                value.textColor = .white
                value.font = UIFont.systemFont(ofSize: 14)
                value.lineBreakMode = .byWordWrapping
                value.numberOfLines = 0
                
                let rowStack = UIStackView(arrangedSubviews: [label, value])
                rowStack.spacing = 16
                rowStack.alignment = .top
                
                detailsStack.addArrangedSubview(rowStack)
                
                label.translatesAutoresizingMaskIntoConstraints = false
                label.widthAnchor.constraint(equalToConstant: 90).isActive = true
            }
        }
        
        view.addSubview(detailsStack)
    }
    
    func setupSelectButton() {
        selecTButton.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.21, alpha: 1)
        selecTButton.setTitle("Select session", for: .normal)
        selecTButton.setTitleColor(UIColor.white, for: .normal)
        selecTButton.layer.masksToBounds = true
        selecTButton.layer.cornerRadius = 8
        view.addSubview(selecTButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieImage.heightAnchor.constraint(equalToConstant: 210),
            
            ratingLabel.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 12),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            imdbLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            imdbLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            descriptionLabel.topAnchor.constraint(equalTo: imdbLabel.bottomAnchor, constant: 28),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            detailsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            detailsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            detailsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            selecTButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selecTButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selecTButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            selecTButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
