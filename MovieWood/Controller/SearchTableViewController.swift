//
//  SearchTableViewController.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 22/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    var movies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false // apply searchBar opaque !
        
        tableView.register(UINib(nibName: MovieCell.nibName, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        let movie = movies?[indexPath.row]
        
        // Configure the cell...
        if let poster = movie?.poster_image {
            cell.posterImage.image = poster
        }
        else {
            ImageDownloader.downloadImageFromApi(urlString: "/\(movie?.poster_path ?? "")", type: .reduce) { (image) in
                if let image = image {
                    movie?.poster_image = image
                    if let index = self.movies?.index(where: {$0 === movie}) {
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                }
            }
        }
        cell.titleLabel.text = movie?.title
        cell.overviewLabel.text = movie?.overview

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieTableViewController") as! MovieTableViewController
        vc.movie = movies?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.navigationBar.isTranslucent = false
        movies?.removeAll()
        MovieApi.request(urlString: MovieApi.apiURL + "/search/movie", parameters: "&query=\(searchBar.text?.replacingOccurrences(of: " ", with: "%20") ?? "")&page=1", completionHandler: { (data) in
            guard let data = data else {
                // Display error
                return
            }
            
            if let list = try? JSONDecoder().decode(MovieList.self, from: data) {
                self.movies = list.movies
                self.tableView.reloadData()
            }
        })
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
}
