//
//  MovieTableViewController.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 28/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit
import AVKit
import MXParallaxHeader
import XCDYouTubeKit

class MovieTableViewController: UIViewController, UITableViewDataSource, UITabBarDelegate, MXParallaxHeaderDelegate, TrailerMovieCellProtocol, AVPlayerViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var headerView: HeaderView?
    let cellTypes: [DetailMovieCell.CellType] = [.own, .overview, .trailer, .related, .ratings, .cast, .information]
    
    var movie: Movie? {
        didSet {
            if movie?.backdrop_image == nil {
                ImageDownloader.downloadImageFromApi(urlString: "/\(movie?.backdrop_path ?? "")", type: .original) { (image) in
                    if let image = image {
                        self.movie?.backdrop_image = image
                        self.configureView()
                    }
                }
            }
            if movie?.video == nil, let id = movie?.id {
                Video.getVideo(from: id) { (video) in
                    if let video = video, let videoID = video.trailer {
                        ImageDownloader.downloadImageFromYoutube(videoID: videoID, type: .max) { (image) in
                            if let image = image {
                                video.thumbnail = image
                                self.tableView.reloadData()
                            }
                        }
                    }
                    self.movie?.video = video
                }
            }
            configureView()
        }
    }
    
    var statusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch statusBarStyle {
        case .default:
            navigationController?.navigationBar.tintColor = .black
        case .lightContent:
            navigationController?.navigationBar.tintColor = .white
        }
        return statusBarStyle
    }
    
    var playerViewController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: OwnMovieCell.nibName, bundle: nil), forCellReuseIdentifier: OwnMovieCell.identifier)
        tableView.register(UINib(nibName: DetailMovieCell.nibName, bundle: nil), forCellReuseIdentifier: DetailMovieCell.identifier)
        tableView.register(UINib(nibName: TrailerMovieCell.nibName, bundle: nil), forCellReuseIdentifier: TrailerMovieCell.identifier)
        headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as? HeaderView
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.mode = .fill
        tableView.parallaxHeader.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    func configureView() {
        headerView?.backdropImageView?.image = movie?.backdrop_image
        headerView?.posterImageView?.image = movie?.poster_image
        headerView?.titleLabel?.text = movie?.title
        headerView?.releaseLabel?.text = movie?.release_date
        if let imageView = headerView?.backdropImageView, let _ = imageView.image {
            UIStatusBarStyle.adaptiveStyle(with: imageView.layer, completionHandler: { (style) in
                self.statusBarStyle = style
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }
    }
    
    func trailerDidLaunch() {
        playerViewController = AVPlayerViewController()
        self.present(playerViewController!, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(movie?.video?.trailer) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTube.VideoQuality.hd720] ?? streamURLs[YouTube.VideoQuality.medium360] ?? streamURLs[YouTube.VideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController?.player?.currentItem)
                playerViewController?.player?.play()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController?.dismiss(animated: true)
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        let cellType = cellTypes[indexPath.row]
        
        switch cellType {
        case .own:
            cell = tableView.dequeueReusableCell(withIdentifier: OwnMovieCell.identifier, for: indexPath)
        case .overview:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: DetailMovieCell.identifier, for: indexPath) as! DetailMovieCell
            detailCell.titleLabel.text = cellType.rawValue
            detailCell.detailTextView.text = movie?.overview
            cell = detailCell
        case .trailer:
            let trailerCell = tableView.dequeueReusableCell(withIdentifier: TrailerMovieCell
                .identifier, for: indexPath) as! TrailerMovieCell
            trailerCell.titleLabel.text = cellType.rawValue
            trailerCell.thumbnailImageView.image = movie?.video?.thumbnail
            trailerCell.delegate = self
            cell = trailerCell
        case .related:
            break
        case .ratings:
            break
        case .cast:
            break
        case .information:
            break
        
        }
        
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
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if parallaxHeader.progress < 1.0 {
            tableView.parallaxHeader.mode = .bottom
        }
        else {
            tableView.parallaxHeader.mode = .fill
        }
    }
}
