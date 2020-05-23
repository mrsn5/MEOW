//
//  QuizCoordinator.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 21.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class QuizCoordinator: Coordinator {
    
    static let shared = QuizCoordinator()
    
    var rootViewController: UIViewController
    var transitioningDelegate: UIViewControllerTransitioningDelegate
    
    var presentedViews: [UIViewController] = []
    
    init() {
        rootViewController = QuizMenuView()
        rootViewController.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "doc.richtext"), selectedImage: UIImage(systemName: "doc.richtext"))
        transitioningDelegate = FadeTransition()
    }
    
    func start() {}
    
    func startQuiz(completion: (()->())? = nil) {
        if presentedViews.last is QuizResultsView {
            presentedViews.last?.dismiss(animated: true, completion: { [weak self] in
                self?.presentedViews.removeLast()
                if let quiz = self?.presentedViews.last as? QuizView {
                    quiz.start()
                }
            })
            return
        }
        let quizView = QuizView()
        quizView.modalPresentationStyle = .fullScreen
        quizView.transitioningDelegate = transitioningDelegate
        quizView.modalPresentationCapturesStatusBarAppearance = true
        rootViewController.present(quizView, animated: true, completion: { [weak self] in
            completion?()
            self?.presentedViews.append(quizView)
        })
    }
    
    func showResults(viewModel: QuizViewModel, completion: (()->())? = nil) {
        let quizResults = QuizResultsView(viewModel: viewModel)
        quizResults.modalPresentationStyle = .fullScreen
        quizResults.transitioningDelegate = transitioningDelegate
        quizResults.modalPresentationCapturesStatusBarAppearance = true
        presentedViews.last?.present(quizResults, animated: true, completion: { [weak self] in
            completion?()
            self?.presentedViews.append(quizResults)
        })
    }
    
    func showMenu() {
        guard presentedViews.count > 0 else { return }
        presentedViews.removeLast()
        while presentedViews.count > 0 {
            hideAll(view: presentedViews.last!.view)
            presentedViews.removeLast()
        }
        rootViewController.dismiss(animated: true, completion: nil)
        presentedViews.removeAll()
    }
    
    func showBreedDetails(breed: Breed) {
        let viewController = BreedDetailsView(breed: breed)
        presentedViews.last?.present(viewController, animated: true, completion: nil)
    }
    
    func hideAll(view: UIView) {
        for v in view.subviews {
            v.isHidden = true
        }
    }
}

class FadeTransition: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePushAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadePopAnimator()
    }
}
