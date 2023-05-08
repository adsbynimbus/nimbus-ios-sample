//
//  SwipeInterstitialViewController.swift
//  nimbus-ios-sample
//
//  Created by Inder Dhir on 4/14/23.
//

import Foundation
import NimbusKit
#if canImport(Shuffle)
import Shuffle
#endif
#if canImport(Shuffle_iOS)
import Shuffle_iOS
#endif
import UIKit

final class SwipeInterstitialViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let cardStack = SwipeCardStack()
    private let adManager = NimbusAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(cardStack)
        
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardStack.topAnchor.constraint(equalTo: view.topAnchor),
            cardStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        cardStack.dataSource = self
        cardStack.delegate = self
        
//        adManager.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("WTF \(gestureRecognizer) \(otherGestureRecognizer)")
        return true
    }
}

extension SwipeInterstitialViewController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        
        let request = NimbusRequest.forVideoAd(position: "position")
        adManager.showAd(
            request: request,
            container: card,
            adPresentingViewController: self
        )
        
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        2
    }
}

extension SwipeInterstitialViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
//        cardStack.gestureRecognizers?.forEach { $0.isEnabled = false }
        cardStack.gestureRecognizers?.forEach { if ($0.delegate == nil) { $0.delegate = self } }
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        
    }

    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        
    }

    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        
    }
}
