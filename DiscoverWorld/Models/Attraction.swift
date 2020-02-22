//
//  Attraction.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

/// Represents a country's attraction
struct Attraction: Codable {
    
    /// The id of the attraction.
    let id: String
    
    /// The country's id.
    let countryId: String
    
    /// The name of the attraction.
    let name: String
    
    /// The description of the attraction.
    let description: String
}
