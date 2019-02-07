//
//  TodayCollectionViewCell.swift
//  MovieWood
//
//  Created by Jules COURNUT on 22/01/2019.
//  Copyright © 2019 Jean-Charles Neboit. All rights reserved.
//

import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        self.poster.image = nil
        self.activityView.startAnimating()
        self.activityView.isHidden = false
    }
    
    func showPoster(image: UIImage) {
        self.activityView.isHidden = true
        self.activityView.stopAnimating()
        self.poster.image = image
    }
}
