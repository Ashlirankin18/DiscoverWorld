//
//  ImageLoader.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

class ImageLoader {
    
    let networkHelper: NetworkHelper
    typealias ImageHandler = (Result<UIImage, AppError>) -> Void
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
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
