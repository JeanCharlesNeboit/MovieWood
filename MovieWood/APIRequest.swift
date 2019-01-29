//
//  APIRequest.swift
//  MovieWood
//
//  Created by Jules COURNUT on 22/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import Foundation

class APIRequest {
    static let apiURL = "https://api.themoviedb.org/3"
    static let apiKey = "api_key="
    static let resourcesURL = "https://image.tmdb.org/t/p/original"
    
    static func request(urlString: String, completionHandler: @escaping (Data?) -> Void) {
        let _url = urlString + "?" + apiKey
        guard let url = URL(string: _url) else {
            completionHandler(nil)
            return
        }
        // Background thread
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            
            // Main/UI thread
            DispatchQueue.main.async {
                completionHandler(data)
            }
        }
    }
}
