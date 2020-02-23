//
//  AttractionCollectionViewController.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// `UICollectionViewController` subclass which displays attractions
final class AttractionCollectionViewController: UICollectionViewController {
    
    let attractions: [Attraction]
    
    init(attractions: [Attraction]) {
        self.attractions = attractions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
