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
    
    private let imageViewModel = ImageViewModel<ImageRAMCache>(service: UIImageService(cache: ImageRAMCache.shared, policy: .loadCacheElseLoad))
    private var selectedImage: CatImage?
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = viewModel.dataSource[indexPath.row]
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

