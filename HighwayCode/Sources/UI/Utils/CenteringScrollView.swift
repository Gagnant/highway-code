//
//  CenteringScrollView.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 09.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class CenteringScrollView: UIScrollView {

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        updateInsets()
    }

    override var contentSize: CGSize {
        didSet { updateInsets() }
    }

    // MARK: -

    private func updateInsets() {
        let inset = CGSize(
            width: max(0, safeAreaLayoutGuide.layoutFrame.width - contentSize.width) / 2,
            height: max(0, safeAreaLayoutGuide.layoutFrame.height - contentSize.height) / 2
        )
        let insets = UIEdgeInsets(top: inset.height, left: inset.width, bottom: inset.height, right: inset.width)
        guard insets != contentInset else {
            return
        }
        contentInset = insets
    }

}

