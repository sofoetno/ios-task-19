//
//  MovieListViewController.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

import UIKit

class MovieListViewController: UIViewController {
    private let maincStackView = UIStackView()
    private var collectionView: UICollectionView?
    private let mainLabel = UILabel()
    private let topBar = UIStackView()

    private let movieListViewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieListViewModel.fetchData(closure: { [weak self] in
            self?.collectionView?.reloadData()
        })
        
        view.backgroundColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1)
        
        setupTopbar()
        setupMainStackView()
        setupConstraints()
    }
    
    func setupTopbar() {
        let logo = UIImageView()
        logo.image = UIImage(named: "Product Logo")
        logo.frame = CGRect(x: 0, y: 0, width: 33, height: 37)
        
        let profileButton = ButtonWithPadding()
        profileButton.setPadding(top: 8, left: 16, bottom: 8, right: 16)
        profileButton.setTitle("Profile", for: .normal)
        profileButton.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.21, alpha: 1)
        profileButton.layer.cornerRadius = 8
        
        topBar.addArrangedSubview(logo)
        topBar.addArrangedSubview(profileButton)
        topBar.alignment = .center
        topBar.axis = .horizontal
        topBar.distribution = .equalSpacing
        
        view.addSubview(topBar)
    }
    
    func setupMainStackView() {
        maincStackView.backgroundColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1)
        
        maincStackView.axis = .vertical
        maincStackView.spacing = 15
        
        mainLabel.text = "Now in cinemas"
        mainLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        mainLabel.textColor = .white
        
        maincStackView.addArrangedSubview(mainLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView?.backgroundColor = UIColor(red: 0.1, green: 0.13, blue: 0.2, alpha: 1)
        
        maincStackView.addArrangedSubview(collectionView!)
        
        view.addSubview(maincStackView)
    }
    
    func setupConstraints() {
        maincStackView.translatesAutoresizingMaskIntoConstraints = false
        topBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topBar.heightAnchor.constraint(equalToConstant: 64),
            
            maincStackView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            maincStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            maincStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            maincStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell
        
        Task {
           do {
               try await cell?.configure(movie: movieListViewModel.getMovieByIndex(index: indexPath.row))
           } catch {
               print("Error fetching additional data: \(error)")
           }
        }
        
        return cell ?? UICollectionViewCell()
    }
}

extension MovieListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 164, height: 300)
    }
}

extension MovieListViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newItem = MovieDetailsViewController()
        
        let movie = movieListViewModel.getMovieByIndex(index: indexPath.row)
        
        newItem.movieId = movie.id
        
        self.navigationController?.pushViewController(newItem, animated: true)
    }
}
