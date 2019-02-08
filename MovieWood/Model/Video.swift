//
//  Video.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 08/02/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class VideoList: Codable {
    var videos: [Video]
    
    enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
}

class Video: Codable {
    var trailer: String?
    var site: String?
    var thumbnail: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case trailer = "key"
        case site
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.trailer = try values.decodeIfPresent(String.self, forKey: .trailer)
        self.site = try values.decodeIfPresent(String.self, forKey: .site)
    }
    
    static func getVideo(from movieID: Int, completionHandler: @escaping (Video?) -> Void) {
        MovieApi.request(urlString: MovieApi.apiURL + "/movie/\(String(movieID))/videos") { (data) in
            if let data = data {
                if let videos = try? JSONDecoder().decode(VideoList.self, from: data) {
                    for video in videos.videos {
                        if video.site == "YouTube" {
                            completionHandler(video)
                            break
                        }
                    }
                }
            }
        }
        completionHandler(nil)
    }
}
