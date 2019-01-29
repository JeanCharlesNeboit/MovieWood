//
//  Plist.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 07/02/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import Foundation

class PropertyList {
    static func getValue<T>(for key: String, plist name: String) -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) {
            return dict.object(forKey: key) as? T
        }
        return nil
    }
}
