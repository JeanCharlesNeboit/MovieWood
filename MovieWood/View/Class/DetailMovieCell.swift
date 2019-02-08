//
//  Cast&CrewTableViewCell.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 30/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class DetailMovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    static let nibName = #file.lastPathComponent.deletePathComponent
    static let identifier = DetailMovieCell.nibName
    
    enum CellType: String, CaseIterable {
        case own
        case overview = "Overview"
        case trailer = "Trailer"
        case related = "Related"
        case ratings = "Ratings & Reviews"
        case cast = "Cast & Crew"
        case information = "Information"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailTextView.textContainerInset = .zero
        detailTextView.textContainer.lineFragmentPadding = 0
    }

    override func prepareForReuse() {
        
    }
}
