//
//  AppError.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

enum AppError: Error {
    case badURL(String)
    case badStatusCode(String)
    case networkError(Error)
}
