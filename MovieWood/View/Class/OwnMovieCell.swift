//
//  OwnMovieCell.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 08/02/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class OwnMovieCell: UITableViewCell {
    
    static let nibName = #file.lastPathComponent.deletePathComponent
    static let identifier = OwnMovieCell.nibName
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        
    }
}
