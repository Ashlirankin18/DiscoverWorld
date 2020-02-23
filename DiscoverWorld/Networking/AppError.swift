//
//  AppError.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

/// Contains the types of error that may occur in the app.
enum AppError: Error {
    
    /// The URL cannot be made.
    case badURL(String)
    
    /// A bad status code was returned from the server.
    case badStatusCode(String)
    
    /// There was an error with the network.
    case networkError(Error)
    
    /// No image could be found from data
    case noImageFound(Error)
    
    /// The Image could not be decoded.
    case imageDecodingError(String)
}
