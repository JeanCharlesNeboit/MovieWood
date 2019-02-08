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
    var title: String?
    var original_title: String?
    var release_date: String?
    var overview: String?
    var vote_average: Float?
    
    var poster_path: String?
    var poster_image: UIImage?
    
    var backdrop_path: String?
    var backdrop_image: UIImage?
    
    var details: Details?
    var video: Video?
    
    var watched: Bool?
    var watchlist: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case poster_path
        case title
        case original_title
        case release_date
        case backdrop_path
        case overview
        case vote_average
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.title = try values.decodeIfPresent(String.self, forKey: .title)
        self.original_title = try values.decodeIfPresent(String.self, forKey: .original_title)
        self.release_date = try values.decodeIfPresent(String.self, forKey: .release_date)
        self.overview = try values.decodeIfPresent(String.self, forKey: .overview)
        self.vote_average = try values.decodeIfPresent(Float.self, forKey: .vote_average)
        self.poster_path = try values.decodeIfPresent(String.self, forKey: .poster_path)
        self.backdrop_path = try values.decodeIfPresent(String.self, forKey: .backdrop_path)
    }
    
    // MARK: - Details
    class Details: Codable {
        var genre: [String]?
        
        enum CodingKeys: String, CodingKey {
            case genre
        }
        
        required init(from decoder: Decoder) throws {
            
        }
    }
}
