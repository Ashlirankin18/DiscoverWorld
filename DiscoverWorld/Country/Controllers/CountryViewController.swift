//
//  CountryViewController.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// `UIViewController` subclass which displays contries
final class CountryViewController: UIViewController {
    
    @IBOutlet private weak var countryTableView: UITableView!
    
    private lazy var networkHelper = NetworkHelper()
    private lazy var imageLoader: ImageLoader = .init(networkHelper: networkHelper)
    private var countries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.countryTableView.reloadData()
            }
        }
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        retrieveCountries()
    }
    
    private func configureTableView() {
        countryTableView.register(UINib(nibName: "CountryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryTableViewCell")
        countryTableView.rowHeight = UITableView.automaticDimension
        countryTableView.dataSource = self
        countryTableView.delegate = self
    }
    
    private func retrieveCountries() {
        
        let urlString = "https://5e5152c3f2c0d300147c05f7.mockapi.io/Country"
        
        networkHelper.performDataTask(urlEndPoint: urlString) { (result) in
            switch result {
            case let .success(data):
                guard let countries = try? JSONDecoder().decode([Country].self, from: data) else {
                    assertionFailure("Could not decode countries")
                    return
                }
                self.countries = countries
            case let .failure(error):
                print(error)
            }
        }
    }
}
extension CountryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        let country = countries[indexPath.row]
        imageLoader.retrieveImage(urlString: country.flagURL) { (result) in
            switch result {
            case let .success(image):
            cell.viewModel = CountryTableViewCell.ViewModel(name: country.name, population: country.population, flag: image)
            case let .failure(error):
            print(error)
            }
        }
        return cell
    }
}
extension CountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
