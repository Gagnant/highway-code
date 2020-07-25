//
//  CollectionViewDecoratedFlowLayout.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 23.03.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

extension UICollectionView {

    /// A decoration view that identifies the separator between items in a given section.
    static var elementKindSeparator: String { "UICollectionView.elementKindSeparator" }

}

protocol CollectionViewDelegateDecoratedFlowLayout: UICollectionViewDelegateFlowLayout {

    /// Asks the delegate if the section items should be decorated.
    /// - Parameters:
    ///   - collectionView: The collection view object displaying the layout.
    ///   - layout: The layout object requesting the information.
    ///   - section: The index number of the section.
    func collectionView(
        _ collectionView: UICollectionView, layout: UICollectionViewLayout, shouldDecorateSection section: Int
    ) -> Bool

}

class CollectionViewDecoratedFlowLayout: UICollectionViewFlowLayout {

    private var delegate: CollectionViewDelegateDecoratedFlowLayout? {
        return collectionView?.delegate as? CollectionViewDelegateDecoratedFlowLayout
    }

    private var separatorAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    override func prepare() {
        super.prepare()
        generateSeparatorsAttributes()
    }

    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything || context.invalidatedItemIndexPaths != nil {
            separatorAttributes.removeAll()
        }
        super.invalidateLayout(with: context)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // This method has a complexity of O(n) so a better solution should be used
        // when performance becomes critical. Attributes can be stored in a flat
        // array sorted by origin. As a result, it will be possible to use binary
        // sort O(log n) to find attributes inside the given rectangle.
        let separatorAttributes = self.separatorAttributes.values.filter {
            $0.frame.intersects(rect)
        }
        let attributes = super.layoutAttributesForElements(in: rect) ?? []
        return separatorAttributes + attributes
    }

    override func layoutAttributesForDecorationView(
        ofKind elementKind: String, at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath) {
            return attributes
        }
        return separatorAttributes[indexPath]
    }

}

extension CollectionViewDecoratedFlowLayout {

    private func generateSeparatorsAttributes() {
        guard let collectionView = self.collectionView, separatorAttributes.isEmpty else {
            return
        }
        let size = CGSize(width: collectionView.bounds.width, height: 1)
        stride(from: 0, to: collectionView.numberOfSections, by: 1).filter { section -> Bool in
            return delegate?.collectionView(collectionView, layout: self, shouldDecorateSection: section) ?? false
        }.flatMap { section in
            return generateSeparatorsAttributes(for: section, size: size)
        }.forEach { attributes in
            separatorAttributes[attributes.indexPath] = attributes
        }
    }

    private func generateSeparatorsAttributes(for section: Int, size: CGSize) -> [UICollectionViewLayoutAttributes] {
        let itemsCount = collectionView?.numberOfItems(inSection: section) ?? 0
        let itemsFrames = stride(from: 0, to: itemsCount, by: 1).compactMap { row -> CGRect? in
            let indexPath = IndexPath(row: row, section: section)
            return layoutAttributesForItem(at: indexPath)?.frame
        }
        var separatorsLocations = stride(from: 0, to: itemsFrames.count - 1, by: 1).map { index -> CGFloat in
            let frameA = itemsFrames[index]
            let frameB = itemsFrames[index + 1]
            return frameA.maxY + (frameB.minY - frameA.maxY) / 2 - size.height
        }
        if let item = itemsFrames.first {
            separatorsLocations.insert(item.minY, at: 0)
        }
        if let item = itemsFrames.last {
            separatorsLocations.append(item.maxY - size.height)
        }
        let attributes = separatorsLocations.enumerated().map { object -> UICollectionViewLayoutAttributes in
            let attributes = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: UICollectionView.elementKindSeparator,
                with: IndexPath(row: object.offset, section: section)
            )
            attributes.frame.size = size
            attributes.frame.origin.y = object.element
            attributes.zIndex = 1
            return attributes
        }
        return attributes
    }

}
