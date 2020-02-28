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
    
    private enum CardState {
        case expanded
        case collapsed
    }
    
    private let cardHeight: CGFloat = 500
    private let cardHandleArea: CGFloat = 44
    private var isCardVisible: Bool = false
    private var animationProgressWhenInterrupted: CGFloat = 0.0
    private var nextState: CardState {
        return isCardVisible ? .collapsed : .expanded
    }
    
    private var visualEffectsView: UIVisualEffectView!
    
    private lazy var cardViewController: CardViewController = .init(delegate: self)
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    
    private let imageLoader: ImageLoader
    
    private var attractions: [Attraction] {
        didSet {
            collectionView.reloadData()
        }
    }
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(handleTapGesture(tapGestureRecognizer:)))
    
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    
    /// Creates a new instance of `AttractionCollectionViewContoroller`
    /// - Parameters:
    ///   - attractions: The attractions that a country has.
    ///   - imageLoader: Responsible for retrieving images.
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
    
    private func retrieveImage(urlString: String, completion: @escaping (UIImage) -> Void) {
        imageLoader.retrieveImage(urlString: urlString) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(image):
                completion(image)
            }
        }
    }
    
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height
                }
            }
            frameAnimator.addCompletion { _ in
                self.isCardVisible = !self.isCardVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 10.0
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0 ) {
                switch state {
                case .expanded:
                     self.visualEffectsView.isHidden = false
                    self.visualEffectsView.effect = UIBlurEffect(style: .regular)
                   
                case .collapsed:
                    self.visualEffectsView.isHidden = true
                    self.visualEffectsView.effect = nil
                }
            }
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    private func startIntractiveTransition(state: CardState, duration: TimeInterval) {
        
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractionTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.0)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attractions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttractionCollectionViewCell", for: indexPath) as? AttractionCollectionViewCell else {
            return UICollectionViewCell()
        }
        let attraction = attractions[indexPath.row]
        
        retrieveImage(urlString: attraction.image) { (image) in
            cell.viewModel = AttractionCollectionViewCell.ViewModel(name: attraction.name, image: image, description: attraction.description)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAttraction = attractions[indexPath.row]
        
        retrieveImage(urlString: selectedAttraction.image) { [weak self] (image) in
            self?.cardViewController.viewModel = CardViewController.ViewModel(name: selectedAttraction.name, description: selectedAttraction.description, image: image)
        }
        
        visualEffectsView = UIVisualEffectView()
        visualEffectsView.frame = view.frame
        view.addSubview(visualEffectsView)
        visualEffectsView.addGestureRecognizer(tapGestureRecognizer)
        visualEffectsView.isUserInteractionEnabled = true
        addChild(cardViewController)
        view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: view.frame.height, width: view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        animateTransitionIfNeeded(state: nextState, duration: 1.0)
    }
    
    @objc private func handleTapGesture(tapGestureRecognizer: UITapGestureRecognizer) {
        animateTransitionIfNeeded(state: nextState, duration: 1.0)
    }
}

extension AttractionCollectionViewController: CardViewControllerDelegate {
    
    // MARK: - CardViewControllerDelegate
    
    func panGestureDidBegin(_ cardViewController: CardViewController) {
        startIntractiveTransition(state: nextState, duration: 1.0)
    }
    
    func panGestureDidChange(_ cardViewController: CardViewController, with translation: CGPoint) {
        var fractionComplete = translation.y / cardHeight
        
        fractionComplete = isCardVisible ? fractionComplete : -fractionComplete
        updateInteractiveTransition(fractionCompleted: fractionComplete)
    }
    
    func panGestureDidEnd(_ cardViewController: CardViewController) {
        continueInteractionTransition()
        visualEffectsView.isHidden = true
    }
}
