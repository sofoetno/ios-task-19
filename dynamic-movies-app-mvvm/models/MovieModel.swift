//
//  MovieModel.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

struct MovieModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let voteAverage: Double
}
