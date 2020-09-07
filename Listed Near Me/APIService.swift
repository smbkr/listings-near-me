//
//  API.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 19/08/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation

class APIService {
    
    private let scheme = "http"
    private let hostname = "localhost"
    private let port = 3000
    private let basePath = "dev"
    
    func getAll(completion: @escaping (Result<[Listing], Error>) -> Void) {
        let url = createURLComponents(for: "all")
        
        guard let validUrl = url.url else {
            return // TODO: Better error handling here?
        }
        
        URLSession.shared.dataTask(with: validUrl) { (data, response, error) in
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
           do {
                let listings = try JSONDecoder().decode([Listing].self, from: validData)
                completion(.success(listings))
            } catch let serializationError {
                completion(.failure(serializationError))
            }
        }.resume()
    }
    
    func getNear(_ location: Location, completion: @escaping (Result<[Listing], Error>) -> Void) {
        var url = createURLComponents(for: "near")
        url.queryItems = [
            URLQueryItem(name: "long", value: String(location.long)),
            URLQueryItem(name: "lat", value: String(location.lat))
        ]
        
        guard let validUrl = url.url else {
            return // TODO: Error handling
        }
        
        URLSession.shared.dataTask(with: validUrl) { (data, response, error) in
            // TOOD: reduce duplication
            guard let validData = data, error == nil else {
                 completion(.failure(error!))
                 return
             }
             
            do {
                 let listings = try JSONDecoder().decode([Listing].self, from: validData)
                 completion(.success(listings))
             } catch let serializationError {
                 completion(.failure(serializationError))
             }
        }.resume()
    }
    
    private func createURLComponents(for path: String) -> URLComponents {
        var url = URLComponents()
        url.scheme = scheme
        url.host = hostname
        url.port = port
        url.path = "/\(basePath)/\(path)"
        
        return url
    }
}
