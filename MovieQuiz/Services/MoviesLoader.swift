//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Тихтей  Павел on 24.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesURL: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_wkmd6k3j") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
            case .success(let data):
                let mostPopularMovies = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                guard let mostPopularMovies = mostPopularMovies else { return }
                handler(.success(mostPopularMovies))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
