//
//  CardView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 16.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

protocol SwipeCardsDelegate {
    func swipeDidEnd()
    func swipeWillStart()
    func setSwippingState(inSwipping: Bool)
    func getSwippingState() -> Bool
}

@IBDesignable
class CardView: UIView {
    
    var shadowView : UIView!
    var startPosition: CGRect!
    var isSwipable = false
    var delegate : SwipeCardsDelegate?
    var contentView: CardContent?
    
    @IBInspectable var cardColor: UIColor? {
        set { self.backgroundColor = newValue ?? UIColor.systemBackground }
        get { return self.backgroundColor ?? UIColor.systemBackground }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addShadow()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addShadow()
        addPanGestureOnCards()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    var topConst: NSLayoutConstraint?
    var rightConst: NSLayoutConstraint?
    var bottomConst: NSLayoutConstraint?
    var leftConst: NSLayoutConstraint?
    
    func configureConstraints(top: Int, right: Int,bottom: Int,left: Int) {
        guard let superview = superview else { return }
        
        self.removeConstraints(self.constraints)
        
        translatesAutoresizingMaskIntoConstraints = false
        leftConst = leftAnchor.constraint(equalTo: superview.leftAnchor, constant: CGFloat(left))
        rightConst = rightAnchor.constraint(equalTo: superview.rightAnchor, constant: CGFloat(right))
        bottomConst = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: CGFloat(bottom))
        topConst = topAnchor.constraint(equalTo: superview.topAnchor, constant: CGFloat(top))
        
        leftConst?.isActive = true
        rightConst?.isActive = true
        bottomConst?.isActive = true
        topConst?.isActive = true
    }
    
    func changeConstraints(top: Int, right: Int,bottom: Int,left: Int) {
        topConst?.constant = CGFloat(top)
        rightConst?.constant = CGFloat(right)
        bottomConst?.constant = CGFloat(bottom)
        leftConst?.constant = CGFloat(left)
    }
    
    func addShadow() {
        self.backgroundColor = cardColor // .systemBackground// UIColor(named: "background")
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor(named: "dark shadow")?.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 20
        self.layer.masksToBounds = false
        self.layer.needsDisplayOnBoundsChange = true
        //        updateShadow()
    }
    
    func addView(content: CardContent) {
        contentView?.removeFromSuperview()
        self.addSubview(content)
        contentView = content
        clipsToBounds = true
        contentView?.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.layer.shadowColor = UIColor(named: "dark shadow")?.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        updateShadow()
        contentView?.frame = bounds
        contentView?.setNeedsUpdateConstraints()
        contentView?.updateConstraintsIfNeeded()
        
        guard let superview = superview, let topConst = topConst, let rightConst = rightConst, let bottomConst = bottomConst, let leftConst = leftConst else { return }
        
        startPosition = CGRect(x: leftConst.constant, y: topConst.constant, width: (superview.frame.width - leftConst.constant + rightConst.constant), height: (superview.frame.height - topConst.constant + bottomConst.constant))
    }
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        guard isSwipable else { return }
        guard !(delegate?.getSwippingState() ?? false) else { return }
        let card = sender.view as! CardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: startPosition.midX, y: startPosition.midY)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        switch sender.state {
        case .ended:
            guard let superview = superview else { return }
            let offset = superview.frame.width * 0.25
            
            if (card.center.x) > superview.frame.maxX - offset {
                card.swipe(right: true)
            } else if card.center.x < superview.frame.minX + offset {
                card.swipe(right: false)
            } else {
                UIView.animate(withDuration: 0.2) {
                    card.transform = .identity
                    card.frame = self.startPosition
                    self.layoutIfNeeded()
                }
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    func swipe(right: Bool = Bool.random()) {
        guard !(self.delegate?.getSwippingState() ?? false) else { return }
        self.delegate?.setSwippingState(inSwipping: true)
        self.delegate?.swipeWillStart()
//        let centerOfParentContainer = CGPoint(x: startPosition.midX, y: startPosition.midY)

        
        UIView.animate(withDuration: 0.2, animations: {
            self.center = CGPoint(x: self.center.x + 400 * (right ? 1 : -1), y: self.center.y + 75)
            self.alpha = 0
            
            let rotation = (right ? -1 : 1) * tan(self.frame.width * 2.0 / self.frame.height)
            self.transform = CGAffineTransform(rotationAngle: rotation)
        }) { _ in
            self.delegate?.swipeDidEnd()
            self.delegate?.setSwippingState(inSwipping: false)
            self.layoutIfNeeded()
        }
    }
}
