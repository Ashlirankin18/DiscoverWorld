//
//  AttractionCollectionViewCell.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// `UICollectionViewCell` subclass which displays an attraction.
final class AttractionCollectionViewCell: UICollectionViewCell {
    
    /// Configures the `AttractionCollectionViewCell` with data it needs to display.
    struct ViewModel {
        
        /// The name of the attraction.
        let name: String
        
        /// The attraction's image
        let image: UIImage
        
        /// The description of the attraction.
        let description: String
        
    }
    
    /// Single point of configuration of the `AttractionCollectionViewCell`.
    var viewModel: ViewModel? {
        didSet {
            attractionImageView.image = viewModel?.image
            attractionNameLabel.text = viewModel?.name
            attractinDescriptionLabel.text = viewModel?.description
        }
    }
    
    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var attractionImageView: UIImageView!
    @IBOutlet private weak var attractionNameLabel: UILabel!
    @IBOutlet private weak var attractinDescriptionLabel: UILabel!
}
