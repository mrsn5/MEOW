//
//  MosaicLayout.swift
//  CatTastUIKit
//
//  Created by San Byn Nguyen on 16.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

enum MosaicSegmentStyle {
    case threeThirds
    case twoThirdsOneThird
    case oneThirdTwoThirds
}

class MosaicLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    /// - Tag: PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        let count = collectionView.numberOfItems(inSection: 0)
        
        var currentIndex = 0
        var segment: MosaicSegmentStyle = .twoThirdsOneThird
        var lastFrame: CGRect = .zero
        
        let cvWidth = collectionView.bounds.size.width
        
        while currentIndex < count {
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY, width: cvWidth, height: cvWidth / 3.0 * CGFloat((2 - currentIndex % 2)))
            
            var segmentRects = [CGRect]()
            switch segment {
            case .threeThirds:
                segmentRects = [
                    CGRect(x: 0, y: segmentFrame.minY,
                           width: cvWidth / 3.0, height: segmentFrame.height),
                    CGRect(x: cvWidth / 3.0, y: segmentFrame.minY,
                           width: cvWidth / 3.0, height: segmentFrame.height),
                    CGRect(x: cvWidth / 3.0 * 2.0, y: segmentFrame.minY,
                           width: cvWidth / 3.0, height: segmentFrame.height)]
            case .twoThirdsOneThird:
                segmentRects = [
                    CGRect(x: 0, y: segmentFrame.minY,
                           width: cvWidth / 3.0 * 2.0, height: segmentFrame.height),
                    CGRect(x: cvWidth / 3.0 * 2.0, y: segmentFrame.minY,
                           width: cvWidth / 3.0, height: segmentFrame.height / 2.0),
                    CGRect(x: cvWidth / 3.0 * 2.0, y: segmentFrame.minY + segmentFrame.height / 2.0,
                           width: cvWidth / 3.0, height: segmentFrame.height / 2.0)]
                
            case .oneThirdTwoThirds:
                segmentRects = [
                    CGRect(x: 0, y: segmentFrame.minY,
                           width: cvWidth / 3.0, height: segmentFrame.height / 2.0),
                    CGRect(x: 0, y: segmentFrame.minY + segmentFrame.height / 2.0,
                           width: cvWidth / 3.0, height: segmentFrame.height / 2.0),
                    CGRect(x: cvWidth / 3.0, y: segmentFrame.minY,
                           width: cvWidth / 3.0 * 2.0, height: segmentFrame.height)]
            }
            
            // Create and cache layout attributes for calculated frames.
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame)
                
                currentIndex += 1
                lastFrame = rect
            }
            
            // Determine the next segment style.
            if currentIndex % 4 == 0 {
                segment = .twoThirdsOneThird
            } else if currentIndex % 2 == 0 {
                segment = .oneThirdTwoThirds
            } else {
                segment = .threeThirds
            }
            
        }
    }
    
    /// - Tag: CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    /// - Tag: ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    /// - Tag: LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    /// - Tag: LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        // Find any cell that sits within the query rect.
        guard let lastIndex = cachedAttributes.indices.last,
            let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }
        
        // Starting from the match, loop up and down through the array until all the attributes
        // have been added within the query rect.
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }
        
        return attributesArray
    }
    
    // Perform a binary search on the cached attributes array.
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
    
}
