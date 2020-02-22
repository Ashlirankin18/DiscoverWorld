//
//  CountryTableViewCell.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// `UITableViewCell` subclass which displays a country.
final class CountryTableViewCell: UITableViewCell {
    
    /// Contains data needed to configure the `CountryTableViewCell`.
    struct ViewModel {
        
        /// The name of the country.
        let name: String
        
        /// The country's population.
        let population: Int
        
        /// The country's flag.
        let flag: UIImage
    }
    
    /// Single point of configuration of the cell.
    var viewModel: ViewModel? {
        didSet {
            
            guard let viewModel = viewModel else {
                assertionFailure("Could not find ViewModel")
                return
            }
            flagImageView.image = viewModel.flag
            countryNameLabel.text = viewModel.name
            populationLabel.text = String(viewModel.population)
        }
    }
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var countryNameLabel: UILabel!
    @IBOutlet private weak var populationLabel: UILabel!
}
