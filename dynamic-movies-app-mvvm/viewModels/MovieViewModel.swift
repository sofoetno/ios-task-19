//
//  MovieViewModel.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

import Foundation

class MovieViewModel {
    var movie: Movie? = nil
    
    func fetchData(id: Int) async throws {
        let (data) = try await NetworkService.shared.getSingleMovie(id: id)
        
        var imageData: Data? = nil
        if let posterPath = data?.posterPath {
            imageData = try await fetchCoverImage(imageUrl: posterPath)
        }
        movie = Movie(
            id: data?.id ?? 0,
            name: data?.title ?? "",
            genre: data?.title ?? "",
            rating: data?.voteAverage ?? 0,
            description: data?.overview ?? "",
            imageUrl: data?.posterPath ?? "",
            coverImageUrl: data?.posterPath ?? "",
            imageData: imageData,
            coverImageData: imageData
        )
    }
    
    func fetchCoverImage(imageUrl: String) async throws -> Data? {
        let imageData = try await NetworkService.shared.getImage(imageUrl: imageUrl)
        return imageData
    }
}
