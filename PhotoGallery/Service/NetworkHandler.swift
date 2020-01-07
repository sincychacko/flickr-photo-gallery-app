//
//  NetworkHandler.swift
//  PhotoGallery
//
//  Created by SINCY on 06/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case invalidSearchURL
    case invalidResponse
    case errorWhileDecoding
}

class NetworkHandler {
    
    private var apiKey = "96358825614a5d3b1a1c3fd87fca2b47"
    
    static let shared = NetworkHandler()
    
    func getImagesFor(searchString text: String, page: Int = 1, completion: @escaping (Result<ResultPage, Error>) -> Void) {
        guard let searchURL = getSearchURLFor(text: text,page: page) else {
            completion(.failure(ServiceError.invalidSearchURL))
            return
        }
        
        let searchURLRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchURLRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("API status: \(httpResponse.statusCode)")
            }
           
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let validData = data else {
                completion(.failure(ServiceError.invalidResponse))
                return
            }
           
            do {
                let photoPages = try JSONDecoder().decode(PhotoResultData.self, from: validData)
                completion(.success(photoPages.photoPage))
            } catch {
                completion(.failure(ServiceError.errorWhileDecoding))
            }
           
        }.resume()
    }
    
    func downloadImageWith(url: URL, completion: @escaping (Data?) -> Void) {
        
        URLSession.shared.dataTask( with: url, completionHandler: {
            (data, response, error) -> Void in
            completion(data)
            
        }).resume()
        
    }
    
    private func getSearchURLFor(text: String, page: Int) -> URL? {
        guard let escapedText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedText)&format=json&nojsoncallback=1&per_page=25&page=\(page)"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
        
        return url
    }
}
