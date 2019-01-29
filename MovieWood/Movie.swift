//
//  Movie.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 22/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class MovieList: Codable {
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

class Movie: Codable {
    var id: Int?
    var original_title: String?
    var release_date: String?
    var overview: String?
    
    var poster_path: String?
    var poster_image: UIImage?
    
    var backdrop_path: String?
    var backdrop_image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case poster_path
        case original_title
        case release_date
        case backdrop_path
        case overview
    }
    
    /*required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
        self.release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
        self.poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
    }*/
}
