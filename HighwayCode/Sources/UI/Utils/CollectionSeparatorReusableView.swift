//
//  CollectionSeparatorReusableView.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 23.03.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class CollectionSeparatorReusableView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        self.backgroundColor = .gray
    }

}
