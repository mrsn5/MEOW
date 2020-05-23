//
//  HorizontalFeed.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 21.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class HorizontalBreedList: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [Breed] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(BreedCell.nib, forCellWithReuseIdentifier: BreedCell.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 50)
        let width = frame.width / 3.5
        flow.itemSize = CGSize(width: width, height: collectionView.frame.height)
        //        flow.minimumInteritemSpacing = 5
//        flow.minimumLineSpacing = 5
    }
}

extension HorizontalBreedList: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedCell.reuseID, for: indexPath) as? BreedCell {
            
            cell.configure(dataSource[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
