//
//  MovieViewController.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 28/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    var movie: Movie? {
        didSet {
            if movie?.backdrop_image == nil {
                APIRequest.request(urlString: APIRequest.resourcesURL + "/\(movie?.backdrop_path ?? "")") { (data) in
                    if let data = data {
                        self.movie?.backdrop_image = UIImage(data: data)
                        self.configureView()
                    }
                }
            }
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        overviewTextView.textContainerInset = UIEdgeInsets.zero
        overviewTextView.textContainer.lineFragmentPadding = 0
    }

    
    func configureView() {
        self.posterImage?.image = movie?.poster_image
        self.titleLabel?.text = movie?.original_title
        self.releaseLabel?.text = movie?.release_date?.components(separatedBy: "-").first
        self.backdropImage?.image = movie?.backdrop_image
        self.overviewTextView?.text = movie?.overview
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
