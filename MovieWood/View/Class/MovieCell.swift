//
//  MovieCellView.swift
//  MovieWood
//
//  Created by Jean-Charles NEBOIT on 29/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    static let nibName = #file.lastPathComponent.deletePathComponent
    static let identifier = MovieCell.nibName
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.posterImage.image = nil
        self.titleLabel.text = ""
        self.overviewLabel.text = ""
    }
}
