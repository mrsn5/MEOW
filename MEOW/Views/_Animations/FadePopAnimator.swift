//
//  FadePopAnimator.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 21.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class FadePopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            return
        }

        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
