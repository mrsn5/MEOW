//
//  QuizMenuView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 20.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class QuizMenuView: UIViewController {

    @IBOutlet weak var startButton: RoundedButton!
    @IBOutlet weak var catImage: UIImageView!
    private var catWalk1: CatWalk!
    private var catWalk2: CatWalk!
    private let catType = Int.random(in: 1...4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCats()
    }
    
    func setupCats(){
        catImage.image = UIImage(named: "cat\(catType)")
        addCatWalk()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func addCatWalk() {
        catWalk1 = CatWalk.instantiate()
        catWalk1.frame = CGRect(x: 0, y: -self.view.frame.height / 2, width: self.view.frame.width, height: self.view.frame.height)
        catWalk1.transform = CGAffineTransform(rotationAngle: -.pi / 4)
        catWalk1.setPaws(type: catType)
        view.addSubview(catWalk1)
        view.sendSubviewToBack(catWalk1)
        catWalk1.translatesAutoresizingMaskIntoConstraints = true
        
        catWalk2 = CatWalk.instantiate()
        catWalk2.frame = CGRect(x: 100, y: self.view.frame.height / 2 + 100, width: self.view.frame.width / 2, height: self.view.frame.height / 2)
        catWalk2.transform = CGAffineTransform(rotationAngle: .pi / 4)
        catWalk2.setPaws(type: (catType + 1) % 4 + 1 )
        view.addSubview(catWalk2)
        view.sendSubviewToBack(catWalk2)
        catWalk2.translatesAutoresizingMaskIntoConstraints = true
    }
    
    @objc func didBecomeActive() {
        catWalk1.stopAnimation()
        catWalk2.stopAnimation()
        catWalk1.removeFromSuperview()
        catWalk2.removeFromSuperview()
        addCatWalk()
        catWalk1.startPawAnimation()
        catWalk2.startPawAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didBecomeActive()
    }
    
    
    
//    override func viewDidLayoutSubviews() {
//        catWalk1.frame = self.view.frame
//        catWalk1.transform = .identity
//        catWalk1.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
//    }


    
    @IBAction func startTapped(_ sender: Any) {
        startButton.isEnabled = false
        QuizCoordinator.shared.startQuiz() { [weak self] in
            self?.startButton.isEnabled = true
        }
    }

}
