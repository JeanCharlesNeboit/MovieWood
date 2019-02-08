//
//  TodayCollectionViewController.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 22/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TodayCell"

class TodayCollectionViewController: UICollectionViewController {

    var refreshControl: UIRefreshControl!
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.addSubview(refreshControl)
    }
    
    // MARK: - Refresh Control
    func stopRefreshControl() {
        self.refreshControl.endRefreshing()
    }
    
    @objc func loadData() {
        stopRefreshControl()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TodayCollectionViewCell
        let movie = movies?[indexPath.row]
    
        // Configure the cell
        if let poster = movie?.poster_image {
            cell.showPoster(image: poster)
        }
        else {
            ImageDownloader.downloadImageFromApi(urlString: "/\(movie?.poster_path ?? "")", type: .reduce) { (image) in
                if let image = image {
                    movie?.poster_image = image
                    if let index = self.movies?.index(where: {$0 === movie}) {
                        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    }
                }
            }
        }
        cell.title.text = movie?.title
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieTableViewController") as! MovieTableViewController
        vc.movie = movies?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
