//
//  ImageLoader.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// Handles thre logic related to loading images.
final class ImageLoader {
    
    private let networkHelper: NetworkHelper
    
    typealias ImageHandler = (Result<UIImage, AppError>) -> Void
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    /// Retrives an image from a urlString.
    /// - Parameters:
    ///   - urlString: URL String representation of the image
    ///   - completionHandler: Handles the result of asynchronous call.
    func retrieveImage(urlString: String, completionHandler: @escaping ImageHandler) {
        networkHelper.performDataTask(urlEndPoint: urlString) { (result) in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        completionHandler(.success(image))
                    } else {
                        completionHandler(.failure(.imageDecodingError("Could not retrieve image from data")))
                    }
                }
                
            case let .failure(error):
                completionHandler(.failure(.noImageFound(error)))
            }
        }
    }
}
