//
//  ImageDownloader.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 29/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class ImageDownloader {
    static var imagesDict: [String: Bool]?
    
    static func downloadImageFromApi(urlString: String, type: MovieApi.ImageResolution, completionHandler: @escaping (UIImage?) -> Void) {
        let index = imagesDict?.index(forKey: urlString)
        if index != nil && imagesDict?[index!].value == true {
            return
        }
        
        imagesDict?[urlString] = true
        MovieApi.request(urlString: MovieApi.resourcesURL + type.rawValue + urlString + "?\(MovieApi.apiKey)") { (data) in
            var image: UIImage?
            if let data = data {
                image = UIImage(data: data)
                imagesDict?.removeValue(forKey: urlString)
            }
            completionHandler(image)
        }
    }
    
    static func downloadImageFromYoutube(videoID: String, type: YouTube.ImageResolution, completionHandler: @escaping (UIImage?) -> Void) {
        let index = imagesDict?.index(forKey: videoID)
        if index != nil && imagesDict?[index!].value == true {
            return
        }
        
        imagesDict?[videoID] = true
        YouTube.getThumbnail(video: videoID, resolution: .standard) { (image) in
            completionHandler(image)
        }
    }
}
