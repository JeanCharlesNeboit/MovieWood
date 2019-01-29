//
//  ViewController.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 22/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MovieApi.request(urlString: MovieApi.apiURL+"/trending/movie/day") { (data) in
            var movies = [Movie]()
            if let data = data {
                if let list = try? JSONDecoder().decode(MovieList.self, from: data) {
                    movies = list.movies
                }
            }
            self.performSegue(withIdentifier: "Present", sender: movies)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tab = segue.destination as? UITabBarController, let movies = sender as? [Movie] {
            if let nav = tab.viewControllers?.first as? UINavigationController, let vc = nav.topViewController as? TodayCollectionViewController {
                vc.movies = movies
            }
        }
    }
}

