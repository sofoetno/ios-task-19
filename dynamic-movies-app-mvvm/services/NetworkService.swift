//
//  NetworkService.swift
//  dynamic-movies-app-mvvm
//
//  Created by Sofo Machurishvili on 17.11.23.
//

import Foundation

struct MoviesData: Codable {
    let results: [MovieModel]
}

enum NetworkError: Error {
    case decodeError
    case wrongResponse
    case wrongStatusCode(code: Int)
}

class NetworkService {
    static var shared = NetworkService()
    
    private let apiKey = "53b1afc277745d64ccd210af319cbed6"
    private let imageRootUrl = "https://image.tmdb.org/t/p/w300_and_h450_bestv2"
    
    func movieList(completion: @escaping ([MovieModel]?, Error?) -> Void) {
        let apiKey = "53b1afc277745d64ccd210af319cbed6"
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("accept", forHTTPHeaderField: "application/json")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkError.wrongResponse)
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(nil, NetworkError.wrongStatusCode(code: response.statusCode))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(MoviesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(object.results, nil)
                }
            } catch {
                print(String(describing: error))

                print("decoding error")
            }
        }).resume()
    }
    
    func getSingleMovie(id: Int) async throws -> MovieModel? {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("accept", forHTTPHeaderField: "application/json")
        
        let (data, _) = try await URLSession.shared.data(for: request)
    
        let decoder = JSONDecoder()
        return try decoder.decode(MovieModel.self, from: data)
    }
    
    func getImage(imageUrl: String) async throws -> Data? {
        let url = URL(string: "\(imageRootUrl)\(imageUrl)")
        let request = URLRequest(url: url!)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
