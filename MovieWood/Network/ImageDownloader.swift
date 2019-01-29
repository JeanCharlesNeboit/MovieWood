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
    
    enum imageType: String {
        case original = "/original"
        case reduce = "/w500"
    }
    
    static func downloadImage(urlString: String, type: imageType, completionHandler: @escaping (UIImage?) -> Void) {
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
}
