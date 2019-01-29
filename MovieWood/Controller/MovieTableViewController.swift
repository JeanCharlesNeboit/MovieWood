//
//  MovieTableViewController.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 28/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit
import MXParallaxHeader

class MovieTableViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, MXParallaxHeaderDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    
    var headerView: HeaderView?
    let cellTypes: [DetailMovieCell.CellType] = [.overview, .trailer, .related, .ratings, .cast, .information]
    
    var movie: Movie? {
        didSet {
            if movie?.backdrop_image == nil {
                ImageDownloader.downloadImage(urlString: "/\(movie?.backdrop_path ?? "")", type: .original) { (image) in
                    if let image = image {
                        self.movie?.backdrop_image = image
                        self.configureView()
                        self.configureStatusBarStyle()
                    }
                }
            }
            configureView()
        }
    }
    
    var statusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch statusBarStyle {
        case .default:
            dismissButton.tintColor = UIColor.black
        case .lightContent:
            dismissButton.tintColor = UIColor.white
        }
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        tableView.register(UINib(nibName: "DetailMovieCell", bundle: nil), forCellReuseIdentifier: "DetailMovieCell")
        headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as? HeaderView
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.height = 300
        tableView.parallaxHeader.mode = .fill
        tableView.parallaxHeader.delegate = self
        configureView()
    }
    
    func configureView() {
        headerView?.backdropImageView?.image = movie?.backdrop_image
        headerView?.posterImageView?.image = movie?.poster_image
        headerView?.titleLabel?.text = movie?.title
        headerView?.releaseLabel?.text = movie?.release_date
        /*let white: UnsafeMutablePointer<CGFloat>? = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let alpha: UnsafeMutablePointer<CGFloat>? = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        self.headerView?.backdropImageView?.layer.colorOfPoint(point: CGPoint(x: 0, y: 0)).getWhite(white, alpha: alpha)
        print(white?.pointee, alpha?.pointee)*/
    }
    
    func configureStatusBarStyle() {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        var pixel: CGFloat = 0
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        for i in stride(from: Int(statusBarFrame.origin.x), to: Int(statusBarFrame.size.width), by: Int(statusBarFrame.size.width)/5) {
            for j in Int(statusBarFrame.origin.y) ..< Int(statusBarFrame.size.height) {
                if let color = self.headerView?.backdropImageView?.layer.colorOfPoint(point: CGPoint(x: i, y: j)) {
                    pixel = pixel + 1
                    red = red + (color.cgColor.components?[0] ?? 0)
                    green = green + (color.cgColor.components?[1] ?? 0)
                    blue = blue + (color.cgColor.components?[2] ?? 0)
                    alpha = alpha + color.cgColor.alpha
                }
            }
        }
        red = red/pixel
        green = green/pixel
        blue = blue/pixel
        alpha = alpha/pixel
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        let white: UnsafeMutablePointer<CGFloat>? = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        color.getWhite(white, alpha: nil)
        if let white = white?.pointee {
            if white < 0.5 {
                statusBarStyle = .lightContent
            }
            else {
                statusBarStyle = .default
            }
            setNeedsStatusBarAppearanceUpdate()
        }
        white?.deallocate()
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMovieCell", for: indexPath) as! DetailMovieCell
        
        let cellType = cellTypes[indexPath.row]
        cell.titleLabel.text = cellType.rawValue
        
        switch cellType {
        case .overview:
            cell.detailTextView.text = movie?.overview
        case .trailer:
            break
        case .related:
            break
        case .ratings:
            break
        case .cast:
            break
        case .information:
            break
        }
        
        //self.tableView.invalidateIntrinsicContentSize()
        return cell
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
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if parallaxHeader.progress < 1.0 {
            tableView.parallaxHeader.mode = .bottom
        }
        else {
            tableView.parallaxHeader.mode = .fill
        }
    }
}
