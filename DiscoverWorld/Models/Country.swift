//
//  Country.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

/// Represents a country.
struct Country: Codable {
    
    /// The country's id.
    let id: String
    
    /// The name of the country.
    let name: String
    
    /// The country's population.
    let population: Int
    
    let attractions: [Attraction]
}
