//
//  DataPersistenceManager.swift
//  Netflix
//
//  Created by Евгений Езепчук on 25.10.23.
//

import UIKit
import CoreData


class DataPersistenceManager {
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadMovieWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = DownloadedFilmDataBase(context: context)
        
        item.original_title = model.original_title
        item.original_name = model.original_name
        item.media_type = model.media_type
        item.overview = model.overview
        item.id = Int64(model.id)
        item.poster_path = model.poster_path
        item.vote_average = model.vote_average
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchMoviesFromDataBase(completion: @escaping (Result<[DownloadedFilmDataBase], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<DownloadedFilmDataBase>
        request = DownloadedFilmDataBase.fetchRequest()
        
        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: DownloadedFilmDataBase, completion: @escaping(Result<Void,Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDeleteData))
        }
    }
}
