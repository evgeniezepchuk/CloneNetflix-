//
//  APICaller.swift
//  Netflix
//
//  Created by Евгений Езепчук on 13.10.23.
//

import UIKit

struct Constants {
    static let API_KEY = "5b747ffde4e517423919372c6d69c681"
    static let baseURL = "https://api.themoviedb.org"
    static let YouTubeAPI_KEY = "AIzaSyBNFQ-Dd3UXoB9lYheXr9909pqKEDyf4fI"
    static let YouTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
    // "https://youtube.googleapis.com/youtube/v3/search?q=Harry%20potterr&key=AIzaSyBNFQ-Dd3UXoB9lYheXr9909pqKEDyf4fI"
}

class APICaller {
    static let shared = APICaller()
    
    
    
    func getTrendingMovies(complition: @escaping (Result<[Movie], Error>) -> Void)  {
        let url = "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getTrendingTv(complition: @escaping (Result<[Movie], Error>) -> Void)  {
        let url = "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getTrendingPopular(complition: @escaping (Result<[Movie], Error>) -> Void)  {
        let url = "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getTopRated(complition: @escaping (Result<[Movie], Error>) -> Void)  {
        let url = "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getUpcomingMovies(complition: @escaping (Result<[Movie], Error>) -> Void)  {
        let url = "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getUpcoming(complition: @escaping (Result<[Movie], Error>) -> Void)  {
        let url = "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getDiscoverMovies(complition: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    
    func search(with query: String, complition: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url = "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)"
        guard let URL = URL(string: url) else { fatalError() }
        URLSession.shared.dataTask(with: URLRequest(url: URL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let datas = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                complition(.success(datas.results))
            } catch {
                complition(.failure(error))
            }
        }
        .resume()
    }
    
    func getMovie(with query: String,  complition: @escaping (Result<VideoElement, Error>) -> Void)  {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=lzQpS1rH3zI&key=AIzaSyBNFQ-Dd3UXoB9lYheXr9909pqKEDyf4fI") else { return }
        guard let url = URL(string: "\(Constants.YouTubeBaseURL)q=\(query)&key=\(Constants.YouTubeAPI_KEY)") else { return }
        
        // https://youtube.googleapis.com/youtube/v3/search?q=Harry%20potterr&key=AIzaSyBNFQ-Dd3UXoB9lYheXr9909pqKEDyf4fI
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(results)
                let responce = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                print(responce)
                complition(.success(responce.items[0]))
 
            } catch {
                print(error.localizedDescription)
                complition(.failure(error))
            }
        }
            .resume()
    }
}

// https://api.themoviedb.org/3/movie/upcoming?api_key=5b747ffde4e517423919372c6d69c681

// https://api.themoviedb.org/3/movie/upcoming?api_key=5b747ffde4e517423919372c6d69c681&language=en-US&page=1


/*
https://api.themoviedb.org/3/discover/movie?api_key=5b747ffde4e517423919372c6d69c681&language=en-
US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatr
ate
*/
// https://api.themoviedb.org3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)
