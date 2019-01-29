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
    
    static func downloadImage(urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
        let index = imagesDict?.index(forKey: urlString)
        if index != nil && imagesDict?[index!].value == true {
            return
        }
        
        imagesDict?[urlString] = true
        APIRequest.request(urlString: APIRequest.resourcesURL + urlString + "?\(APIRequest.apiKey)") { (data) in
            var image: UIImage?
            if let data = data {
                image = UIImage(data: data)
                imagesDict?.removeValue(forKey: urlString)
            }
            completionHandler(image)
        }
    }
}
