//
//  BreedDetailsVIew.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 18.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class BreedDetailsView: UIViewController {
    
    
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var hashtagsLabel: UILabel!
    
    private var images: [UIImage] = []
    private var breed: Breed!
    private var currentIndex = 0
    
    private var viewModel = BreedDetailsViewModel()
    
    init(breed: Breed) {
        super.init(nibName: String(describing: Self.self), bundle: nil)
        self.breed = breed
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = UIColor(named: "light shadow") ?? UIColor.systemBackground
        configure()
    }
    
    func configure() {
        activityIndicator.startAnimating()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 0
        breedLabel.text = breed.name
        altLabel.text = breed.altNames
        hashtagsLabel.text = breed.trueFacts().map { "#\($0)" }.joined(separator: " ")
        countryLabel.text = (breed.countryCode?.flag() ?? "") + " " + (breed.origin ?? "")
        
        imageView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(swipe(_:)))
        imageView.addGestureRecognizer(gesture)
        
        viewModel.fetch(breed: breed) { [weak self] catImages in
            self?.pageControl.numberOfPages = catImages?.count ?? 0
            self?.showImage(at: 0)
        }
    }
    
    func showImage(at: Int) {
        currentIndex = (at + viewModel.catImages.count) % viewModel.catImages.count
        activityIndicator.isHidden = false
        
        self.viewModel.cancelLast()
        self.pageControl.currentPage = self.currentIndex
        self.viewModel.load(string: viewModel.catImages[currentIndex].url) { [weak self] image in
            guard let image = image else { return }
            guard let size = self?.imageView.frame.size else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                let resized = image.resizeFillImage(for: size)
                DispatchQueue.main.async {
                    self?.imageView.image = resized
                    self?.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    func backTapped() {
        currentIndex -= 1
        showImage(at: currentIndex)
    }
    
    func nextTapped() {
        currentIndex += 1
        showImage(at: currentIndex)
    }
    
    
    var lastPoints: [CGPoint] = []
    @objc func swipe(_ sender : UIPanGestureRecognizer) {
        let point = sender.translation(in: self.view)
        switch sender.state {
        case .ended:
            let diff = (lastPoints.first?.x ?? 0) - (lastPoints.last?.x ?? 0)
            if diff < -50 {
                backTapped()
            }
            
            if diff > 50 {
                nextTapped()
            }
            lastPoints = []
        case .changed:
            lastPoints.append(point)
            if lastPoints.count > 20 {
                lastPoints.removeFirst()
            }
        default:
            break
        }
    }
}
