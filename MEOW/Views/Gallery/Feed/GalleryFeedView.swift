//
//  GalleryFeedView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 16.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class GalleryFeedView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topBar: UIView!
    var catImage: CatImage!
    
    var viewModel: GalleryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GalleryViewModel(dataSource: [catImage]) { index in
            self.onFetchCompleted(with: index)
        }
        fetch()
        setupCollectionView()
    }
    
    private func fetch() {
        viewModel.fetch(categoryIds: catImage.categories?.map { $0.id } ?? [])
    }
    
    private func setupCollectionView() {
        collectionView.register(GalleryFeedCell.nib, forCellWithReuseIdentifier: GalleryFeedCell.reuseID)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
        
        let layout = UICollectionViewFlowLayout()
        
        
        layout.sectionInset = UIEdgeInsets(top: collectionView.frame.height / 2 - CGFloat(catImage.getHeight(from: Int(collectionView.frame.width))) / 2 - topBar.frame.height, left: 0, bottom: 100, right: 0)
        collectionView.collectionViewLayout = layout
    }
    
//    func setupTobBar() {
//        let layer = CAGradientLayer()
//        layer.name = "gradbar"
//        layer.frame = topBar.frame
//        layer.colors = [UIColor(named: "background")!.cgColor, UIColor(named: "background")!.withAlphaComponent(0.0).cgColor]
//        layer.startPoint = .init(x: 0.5, y: -1.0)
//        layer.endPoint = .init(x: 0.5, y: 1.0)
//
////        for l in view.layer.sublayers ?? [] {
////            if l.name == "gradbar" {
////                 l.removeFromSuperlayer()
////            }
////        }
//
//        view.layer.insertSublayer(layer, below: topBar.layer)
//    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        setupTobBar()
//    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        collectionView.insertItems(at: newIndexPathsToReload)
    }
}


extension GalleryFeedView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryFeedCell.reuseID, for: indexPath) as? GalleryFeedCell {
            cell.configure(viewModel.dataSource[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.dataSource.count - 5 < indexPath.row {
            fetch()
        }
    }
    
}

extension GalleryFeedView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = viewModel.dataSource[indexPath.row]
        guard let _ = image.width, let _ = image.height else {
            return CGSize(width: self.view.bounds.width, height: self.view.bounds.width / 3 * 2)
        }
        return CGSize(width: self.view.bounds.width, height: CGFloat(image.getHeight(from: Int(self.view.bounds.width))))
    }
}

