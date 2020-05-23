//
//  GalleryView.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 15.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class GalleryView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: GalleryViewModel!
    private let imageViewModel = ImageViewModel<ImageRAMCache>(service: UIImageService(cache: ImageRAMCache.shared, policy: .loadCacheElseLoad))
    
    var selectedImage: CatImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GalleryViewModel() { index in
            self.onFetchCompleted(with: index)
        }
        setupCollectionView()
        fetch()
    }
    
    
    private func setupCollectionView() {
        collectionView.register(ThumbCell.self, forCellWithReuseIdentifier: ThumbCell.reuseID)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = MosaicLayout()
    }
    
    func fetch() {
        viewModel.fetch()
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }
        collectionView.insertItems(at: newIndexPathsToReload)
    }
    
    func makeMenu() -> UIMenu {
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
            
            if let image = self.selectedImage?.url, let url = URL(string: image) {
                self.imageViewModel.load(string: image) { [weak self] image in
                    guard let image = image else { return }

                    let vc = UIActivityViewController(activityItems: [url, image], applicationActivities: [])
                    DispatchQueue.main.async {
                        self?.present(vc, animated: true)
                    }
                
                }
            }
        }
        
        let mainMenu = UIMenu(title: "", children: [share])
        return mainMenu
    }
}

extension GalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbCell.reuseID, for: indexPath) as? ThumbCell {
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = GalleryFeedView()
        vc.catImage = viewModel.dataSource[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK:- Context Menu
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = NSString(string: viewModel.dataSource[indexPath.row].id)
        self.selectedImage = self.viewModel.dataSource[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
            return ImagePreviewView(imageUrl: self.selectedImage!.url, aspectRatio: CGFloat(self.selectedImage!.height ?? 1) / CGFloat(self.selectedImage!.width ?? 1))
        }, actionProvider: { suggestedActions in
            return self.makeMenu()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            
            if configuration.identifier is String {
                let viewController = GalleryFeedView()
                viewController.catImage = self.viewModel.dataSource.first(where: { $0.id == configuration.identifier as! String })
                self.show(viewController, sender: self)
            }
            
        }
    }
    
}

class ImagePreviewView: UIViewController {
    private static let imageViewModel = ImageViewModel<ImageRAMCache>(service: UIImageService(cache: ImageRAMCache.shared, policy: .loadCacheElseLoad))
    
    private let imageView = UIImageView()
    private var aspect: CGFloat = 1
    
    convenience init(imageUrl: String, aspectRatio: CGFloat) {
        self.init()
        imageView.image = UIImage.makeImage(from: UIColor.white)!
        
        Self.imageViewModel.load(string: imageUrl) { [weak self] image in
            guard let image = image else { return }
            self?.imageView.image = image
        }
        aspect = aspectRatio
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage.makeImage(from: UIColor.white)!
        
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let width = view.bounds.width
        let height = aspect * width
        preferredContentSize = CGSize(width: width, height: height)
    }
}
