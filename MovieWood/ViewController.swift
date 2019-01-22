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
        APIRequest.request(urlString: APIRequest.apiURL + "/trending/movie/day?api_key=") { (data) in
            guard let data = data else {
                // Display error
                return
            }
            //UI thread, use data image
            self.performSegue(withIdentifier: "Present", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

