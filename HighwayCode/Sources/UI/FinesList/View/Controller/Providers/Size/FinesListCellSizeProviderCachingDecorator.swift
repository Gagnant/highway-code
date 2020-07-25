//
//  FinesListCellSizeProviderCachingDecorator.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 29.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class FinesListCellSizeProviderCachingDecorator: IFinesListElementCellSizeProvider {

    private struct ElementSizeCache {

        /// Elements.
        let element: AnyFinesListElementViewModel

        /// Size.
        let size: CGSize

    }

    private let provider: IFinesListElementCellSizeProvider
    private var cache: [AnyHashable: ElementSizeCache]

    init(provider: IFinesListElementCellSizeProvider) {
        self.provider = provider
        self.cache = [:]
    }

    // MARK: -

    /// Removes all cached values.
    func reset() {
        cache.removeAll()
    }

    func size(for element: AnyFinesListElementViewModel) -> CGSize {
        if let cache = cache[element.differenceIdentifier], cache.element.isContentEqual(to: element) {
            return cache.size
        }
        let sizeCache = ElementSizeCache(element: element, size: provider.size(for: element))
        self.cache[element.differenceIdentifier] = sizeCache
        return sizeCache.size
    }

}
