//
//  APIRequest.swift
//  MovieWood
//
//  Created by Jules COURNUT on 22/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import Foundation

class MovieApi {
    static let apiURL = "https://api.themoviedb.org/3"
    static let apiKey = "api_key=" + (PropertyList.getValue(for: "ApiKey", plist: "Env") ?? "")
    static let resourcesURL = "https://image.tmdb.org/t/p"
    
    static func request(urlString: String, parameters: String = "", completionHandler: @escaping (Data?) -> Void) {
        let _url = urlString + "?" + apiKey +  parameters
        guard let url = URL(string: _url) else {
            completionHandler(nil)
            return
        }
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                completionHandler(data)
            }
        }
    }
}
