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
    static let resourcesApiURL = "https://image.tmdb.org"
    
    static func request(urlString: String, completionHandler: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
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
