//
//  TrailerMovieCell.swift
//  MovieWood
//
//  Created by Jean-Charles Neboit on 08/02/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

protocol TrailerMovieCellProtocol {
    func trailerDidLaunch()
}

class TrailerMovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    static let nibName = #file.lastPathComponent.deletePathComponent
    static let identifier = TrailerMovieCell.nibName
    
    var delegate: TrailerMovieCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }
    
    override func prepareForReuse() {
        
    }
    
    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.trailerDidLaunch()
    }
}
