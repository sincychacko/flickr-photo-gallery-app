//
//  Paging.swift
//  PhotoGallery
//
//  Created by SINCY on 06/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation

struct PhotoResultData: Codable {
    var photoPage: ResultPage
    
    enum CodingKeys: String, CodingKey {
        case photoPage = "photos"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.photoPage = try container.decode(ResultPage.self, forKey: .photoPage)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(photoPage, forKey: .photoPage)
    }
}

struct ResultPage: Codable {
    var currentPage: Int = 0
    var totalPages: Int = 0
    var perpage: Int = 0
    var total: String = ""
    var photoArray = [Photo]()
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "pages"
        case photoArray = "photo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.currentPage = try container.decode(Int.self, forKey: .currentPage)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.photoArray = try container.decode([Photo].self, forKey: .photoArray)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(currentPage, forKey: .currentPage)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(photoArray, forKey: .photoArray)
    }
}
