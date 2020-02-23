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
    
    private let imageLoader: ImageLoader
    
    private var attractions: [Attraction] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    
    init(attractions: [Attraction], imageLoader: ImageLoader) {
        self.attractions = attractions
        self.imageLoader = imageLoader
        super.init(nibName: "AttractionCollectionViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Attractions", comment: "Indicates to the user this is an attraction.")
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "AttractionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AttractionCollectionViewCell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attractions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttractionCollectionViewCell", for: indexPath) as? AttractionCollectionViewCell else {
            return UICollectionViewCell()
        }
        let attraction = attractions[indexPath.row]
        imageLoader.retrieveImage(urlString: attraction.image) { (result) in
            switch result {
            case let .failure(error):
                print(error)
                cell.viewModel = AttractionCollectionViewCell.ViewModel(name: attraction.name, image: UIImage(systemName: "lock.slash.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40.0, weight: .heavy, scale: .large)) ?? UIImage(), description: attraction.description)
            case let .success(image):
                cell.viewModel = AttractionCollectionViewCell.ViewModel(name: attraction.name, image: image, description: attraction.description)
            }
        }
        
        return cell
    }
}
