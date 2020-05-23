//
//  GalleryCardView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 16.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit


protocol CardStackDelegate {
    func numberOfItems() -> Int
    func cardStack(viewForItem at: Int) -> CardContent
    func cardStack(swipeDidEndHandler at: Int)
    func swipeWillStart()
}

@IBDesignable
class CardStackView: UIView {
    var delegate: CardStackDelegate?
    var cards: [CardView] = []
    var cardsCount = 4
    var offsetY = 15
    var offsetX = 15
    var currentItem: Int = 0
    var isSwipping = false
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    override func awakeFromNib() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    func configure() {
        offsetX = Int(frame.width * 0.025)
        offsetY = Int(frame.height * 0.025)
        self.backgroundColor = UIColor(named: "background")
        
        reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.backgroundColor = UIColor(named: "background")
    }
    
    func reloadData() {
        currentItem = 0
        print("Reload")
        
        let from = min(cards.count, delegate?.numberOfItems() ?? 0)
        let to = min(cardsCount, delegate?.numberOfItems() ?? 0)
        for i in from..<to {
            addCard(delay: Double(i - from) / 4.0)
        }
        
        // update views
        for i in 0..<min(2, delegate?.numberOfItems() ?? 2) {
            setView(forItem: i)
        }
        
        
        while cards.count > cardsCount {
            cards.last?.removeFromSuperview()
            cards.removeLast()
        }
    }
    
    func nextCard() {
        cards.first?.swipe()
    }
    
    func addCard(delay: Double = 0) {
        let card = CardView()
        card.delegate = self
        self.cards.append(card)
        self.addSubview(card)
        sendSubviewToBack(card)
        let i = self.cards.count
        card.configureConstraints(
            top: i * offsetY*2 - offsetY,
            right: i * -offsetX,
            bottom: (cardsCount-i+1) * -offsetY,
            left: i * offsetX)
        card.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: delay, options: .curveLinear, animations: {
            card.alpha = 1.0 / CGFloat(i)
        }) { [weak self] _ in
            self?.activateFirst()
        }
    }
    
    func setView(forItem at: Int) {
        guard let view = delegate?.cardStack(viewForItem: at + currentItem) else { return }
        view.alpha = 0
        cards[at].addView(content: view)
        UIView.animate(withDuration: 1.0) {
            view.alpha = 1.0
        }
    }
    
    func activateFirst() {
        self.cards.first?.isSwipable = true
        self.cards.first?.contentView?.activate()
    }
}

extension CardStackView: SwipeCardsDelegate {
    func swipeWillStart() {
        self.delegate?.swipeWillStart()
    }
    
    func swipeDidEnd() {
        self.delegate?.cardStack(swipeDidEndHandler: self.currentItem)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else {return}
            for i in 1..<self.cards.count {
                
                self.cards[i].changeConstraints(
                    top: i * self.offsetY*2 - self.offsetY,
                    right: i * -self.offsetX,
                    bottom: (self.cardsCount-i+1) * -self.offsetY,
                    left: i * self.offsetX)
                self.cards[i].alpha = 1.0 / CGFloat(i)
            }
            self.layoutIfNeeded()
        }) { [weak self] _ in
            guard let self = self else {return}
            self.cards.first?.removeFromSuperview()
            if !self.cards.isEmpty {
                self.cards.removeFirst()
            }
            self.currentItem += 1
            if self.currentItem + self.cardsCount <= self.delegate?.numberOfItems() ?? 0 {
                self.addCard()
            }
            self.activateFirst()
            
            if self.cards.count > 1 {
                self.setView(forItem: 1)
            }
        }
    }
    
    func setSwippingState(inSwipping: Bool) {
        self.isSwipping = inSwipping
    }
    
    func getSwippingState() -> Bool {
        return self.isSwipping
    }
}
