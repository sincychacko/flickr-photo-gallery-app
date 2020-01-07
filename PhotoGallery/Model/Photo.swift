//
//  File.swift
//  PhotoGallery
//
//  Created by SINCY on 06/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation


struct Photo: Codable {
    var id = ""
    var owner = ""
    var secret = ""
    var server = ""
    var farm = 0
    var title = ""
    var ispublic = false
    var isfriend0 = false
    var isfamily = false
    
    var imageURLString: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    enum CodingKeys: String, CodingKey {
       case id, title, secret, farm, server
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.secret = try container.decode(String.self, forKey: .secret)
        self.farm = try container.decode(Int.self, forKey: .farm)
        self.server = try container.decode(String.self, forKey: .server)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(secret, forKey: .secret)
        try container.encode(farm, forKey: .farm)
        try container.encode(server, forKey: .server)
    }
}
