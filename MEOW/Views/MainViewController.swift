//
//  MainViewController.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 15.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

protocol Coordinator {
    var rootViewController: UIViewController { get set }
    
    func start()
}


class MainCoordinator: Coordinator {
    let window: UIWindow
    var rootViewController: UIViewController
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = MainViewController()
//        childCoordinators = [QuizCoordinator.shared]
    }
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        for c in childCoordinators {
            c.start()
        }
    }
}


class MainViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let breed = BreedListView()
        breed.tabBarItem = UITabBarItem(title: "Breeds", image: UIImage(systemName: "square.grid.3x2"), selectedImage: UIImage(systemName: "square.grid.3x2.fill"))
//
//        let quiz = QuizCoordinator.shared.rootViewController
//        quiz.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(systemName: "doc.richtext"), selectedImage: UIImage(systemName: "doc.richtext"))
        
        let gallery = GalleryView()
        gallery.tabBarItem = UITabBarItem(title: "Gallery", image: UIImage(systemName: "photo.on.rectangle.fill"), selectedImage: UIImage(systemName: "photo.on.rectangle"))
        
        
        
        viewControllers = [breed, gallery]
//        selectedIndex = 1
        
        setupUI()
    }
    
    
    
    
    func setupUI() {
        tabBar.tintColor = UIColor(named: "primary")
        if let items = tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
            }
        }
        
        for subview in tabBar.subviews {
            for badgeView in subview.subviews {
                if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
                    badgeView.layer.transform = CATransform3DIdentity
                    badgeView.layer.transform = CATransform3DMakeTranslation(-6.0, 0.0, 1.0)
                }
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
        tabFrame.size.height = 40
        tabFrame.origin.y = self.view.frame.size.height - 40
        self.tabBar.frame = tabFrame
    }
}
