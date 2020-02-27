//
//  CardViewController.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/23/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// Subscribe to this object if you would like to receive notifications about the status of the pan gesture recognizer.
protocol CardViewControllerDelegate: AnyObject {
    
    /// Called when a pan gesture has begun.
    /// - Parameter cardViewController: `CardPresentationController` displays detils about an attraction.
    func panGestureDidBegin(_ cardViewController: CardViewController)
    
    /// Called when a pan gesture has changed
    /// - Parameters:
    ///   - cardViewController: `CardPresentationController` displays detils about an attraction.
    ///   - translation: The translation of the pan gesture in the coordinate system of the specified view.
    func panGestureDidChange(_ cardViewController: CardViewController, with translation: CGPoint)
    
    /// Called when a pan gesture has ended
    /// - Parameter cardViewController: `CardPresentationController` displays detils about an attraction.
    func panGestureDidEnd(_ cardViewController: CardViewController)
}

/// `UIViewController` subclass which displays details about an attraction.
final class CardViewController: UIViewController {
    
    struct ViewModel {
        
        /// The name of the attraction.
        let name: String
        
        /// The attraction's description.
        let description: String
        
        /// The  attractions image
        let image: UIImage
    }
    
    @IBOutlet private weak var handleAreaView: UIView!
    
    @IBOutlet private weak var attractionImageView: UIImageView!
    
    @IBOutlet private weak var attractionNameLabel: UILabel!
    
    @IBOutlet private weak var attractionDescriptionTextView: UITextView!
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = .init(target: self, action: #selector(handleCardPan(panGestureRecognizer:)))
    
    /// Notifies subscriber to pan gesture recognizer changes.
    private weak var delegate: CardViewControllerDelegate?
    
    /// Single point of configuration of the `CardViewController`.
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            attractionImageView.layer.cornerRadius = 5.0
            attractionImageView.image = viewModel.image
            attractionNameLabel.text = viewModel.name
            attractionDescriptionTextView.text = viewModel.description
        }
    }
    
    // MARK: - CardViewController
    
    /// Creates a new instance of `CardViewController`.
    /// - Parameters:
    ///   - attraction: A country's attraction.
    ///   - imageLoader: Loads the image from a URL.
    init(delegate: CardViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: "CardViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        handleAreaView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handleCardPan(panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .began:
            delegate?.panGestureDidBegin(self)
        case .changed:
            delegate?.panGestureDidChange(self, with: panGestureRecognizer.translation(in: handleAreaView))
        case .ended:
            delegate?.panGestureDidEnd(self)
        default:
            break
        }
    }
}
