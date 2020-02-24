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
    
    private lazy var cardViewController: CardViewController = .init(attraction: attractions[0], imageLoader: imageLoader)
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attraction = attractions[indexPath.row]
        
        visualEffectsView = UIVisualEffectView()
        visualEffectsView.frame = view.frame
        view.addSubview(visualEffectsView)
        
        addChild(cardViewController)
        view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: view.frame.height - cardHandleArea, width: view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(panGestureRecognizer:)))
        
        cardViewController.handleAreaView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleCardPan(panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .began:
            startIntractiveTransition(state: nextState, duration: 1.0)
        case .changed:
            let translation = panGestureRecognizer.translation(in: cardViewController.handleAreaView)
            
            var fractionComplete = translation.y / cardHeight
            
            fractionComplete = isCardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractionTransition()
        default:
            break
        }
    }
    
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
      if runningAnimations.isEmpty {
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
            case .collapsed:
                self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleArea
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
                self.cardViewController.view.layer.cornerRadius = 12.0
            case .collapsed:
                self.cardViewController.view.layer.cornerRadius = 0
            }
        }
        cornerRadiusAnimator.startAnimation()
        runningAnimations.append(cornerRadiusAnimator)
        
        let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0 ) {
            switch state {
            case .expanded:
                self.visualEffectsView.effect = UIBlurEffect(style: .regular)
            case .collapsed:
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
}
