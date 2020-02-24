//
//  CardViewController.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/23/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

final class CardViewController: UIViewController {
  
    @IBOutlet weak var handleAreaView: UIView!
    
    private let attraction: Attraction
    private let imageLoader: ImageLoader
    
    // MARK: - CardViewController
    
    /// Creates a new instance of `CardViewController`.
    /// - Parameters:
    ///   - attraction: A country's attraction.
    ///   - imageLoader: Loads the image from a URL.
    init(attraction: Attraction, imageLoader: ImageLoader) {
        self.attraction = attraction
        self.imageLoader = imageLoader
        super.init(nibName: "CardViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewControlller
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
