//
//  PhotosViewModel.swift
//  PhotoGallery
//
//  Created by SINCY on 07/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation

enum FetchType {
    case initial
    case subsequent
}

protocol PhotosViewModelDelegate: class {
    func fetchDidCompleteWith(fetchType: FetchType)
    func fetchDidFailWith(reason: String)
}

class PhotosViewModel {
    
    var paging: ResultPage? {
        didSet {
            if self.paging == nil {
                photos.removeAll()
            }
        }
    }
    var photos: [Photo] = []
    weak var delegate: PhotosViewModelDelegate?
    
    func getResultImagesFor(searchText: String, pageNo: Int) {
        NetworkHandler.shared.getImagesFor(searchString: searchText, page: pageNo) { (result) in
            
            switch result {
                case .success(let paging):
                    self.paging = paging
                    if paging.currentPage == 1 {
                        self.photos = paging.photoArray
                        self.delegate?.fetchDidCompleteWith(fetchType: .initial)
                    } else {
                        self.photos.append(contentsOf: paging.photoArray)
                        self.delegate?.fetchDidCompleteWith(fetchType: .subsequent)
                    }
                    
                case .failure(let error):
                    var message = ""
                    switch error {
                    case ServiceError.invalidSearchURL:
                        message = "Something is wrong with the flikr url"
                    case ServiceError.invalidResponse:
                        message = "Invalid response"
                    case ServiceError.errorWhileDecoding:
                        message = "Something went wrong while decoding the data"
                    default:
                        message = error.localizedDescription
                    }
                    self.delegate?.fetchDidFailWith(reason: message)
            }
        }
    }
}
