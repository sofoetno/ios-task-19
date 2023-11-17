//
//  Movie.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

import UIKit

class Movie {
    var id: Int
    var name: String
    var genre: String
    var rating: Double
    var isFavorite: Bool = false
    var description: String
    var imageUrl: String?
    var coverImageUrl: String?
    var imageData: Data?
    var coverImageData: Data?
    var details: [(String, String)]? = nil
    
    init(
        id: Int,
        name: String,
        genre: String,
        rating: Double,
        description: String,
        imageUrl: String,
        coverImageUrl: String,
        imageData: Data?,
        coverImageData: Data?,
        details: [(String, String)]? = nil
    ) {
        self.id = id
        self.name = name
        self.genre = genre
        self.rating = rating
        self.description = description
        self.imageUrl = imageUrl
        self.coverImageUrl = coverImageUrl
        self.imageData = imageData
        self.coverImageData = coverImageData
        self.details = details
    }
}
