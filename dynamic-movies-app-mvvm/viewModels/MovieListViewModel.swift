//
//  MovieListViewModel.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

import Foundation

class MovieListViewModel {
    private var movies: [Movie] = []
    
    var count: Int {
        return movies.count
    }
    
    func getMovieByIndex(index: Int) -> Movie {
        return movies[index]
    }
    
    func fetchData(closure: @escaping () -> Void) {
        NetworkService.shared.movieList { [weak self] (movies: [MovieModel]?, error: Error?) in
            if let _ = error {
                return
            }

            self?.movies = movies!.map({
                Movie(
                    id: $0.id,
                    name: $0.title,
                    genre: $0.title,
                    rating: $0.voteAverage,
                    description: $0.overview,
                    imageUrl: $0.posterPath,
                    coverImageUrl: $0.posterPath,
                    imageData: nil,
                    coverImageData: nil,
                    details: [
                         ("Certificate", "15+"),
                         ("Runtime", "02:56"),
                         ("Release", "2022"),
                         ("Genre", "Action, Crime, Drama"),
                         ("Director", "Matt Reeves"),
                         ("Cast", "Robert Pattinson, Zoë Kravitz, Jeffrey Wright, Colin Farrell, Paul Dano, John Turturro, Andy Serkis, Peter Sarsgaard"),
                    ]
                )
            })

            closure()
        }
    }
}
