//
//  CardViewController.swift
//  DiscoverWorld
//
//  Created by Ashli Rankin on 2/23/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit
protocol CardViewControllerDelegate: AnyObject {
    func panGestureDidBegin(_ cardViewController: CardViewController)
    func panGestureDidChange(_ cardViewController: CardViewController, with translation: CGPoint)
    func panGestureDidEnd(_ cardViewController: CardViewController)
}
/// `UIViewController` subclass which displays details about an attraction.
final class CardViewController: UIViewController {
    
    @IBOutlet private weak var handleAreaView: UIView!
    
    private let attraction: Attraction
    private let imageLoader: ImageLoader
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = .init(target: self, action: #selector(handleCardPan(panGestureRecognizer:)))
    
    weak var delegate: CardViewControllerDelegate?
    
    // MARK: - CardViewController
    
    /// Creates a new instance of `CardViewController`.
    /// - Parameters:
    ///   - attraction: A country's attraction.
    ///   - imageLoader: Loads the image from a URL.
    init(attraction: Attraction, imageLoader: ImageLoader, delegate: CardViewControllerDelegate?) {
        self.attraction = attraction
        self.imageLoader = imageLoader
        self.delegate = delegate
        super.init(nibName: "CardViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
