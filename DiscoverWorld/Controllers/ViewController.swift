//
//  ViewController.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/22/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var countryTableView: UITableView!
    private let networkHelper = NetworkHelper()
    
    private let urlString = "https://5e5152c3f2c0d300147c05f7.mockapi.io/Country"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

