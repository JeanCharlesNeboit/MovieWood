//
//  Youtube.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 08/02/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class YouTube {
    private static let imgYoutubeURL = "https://img.youtube.com/vi/"
    
    enum ImageResolution: String {
        case standard = "/sddefault.jpg"
        case max = "/maxresdefault.jpg"
    }
    
    struct VideoQuality {
        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    }
    
    public static func getThumbnail(video id: String, resolution: ImageResolution, completionHandler: @escaping (UIImage?) -> Void) {
        let _url = imgYoutubeURL + id + resolution.rawValue
        guard let url = URL(string: _url) else {
            completionHandler(nil)
            return
        }
        DispatchQueue.global().async {
            var image: UIImage? = nil
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
}
