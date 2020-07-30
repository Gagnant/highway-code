//
//  ResolutionMediaContentViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class ResolutionMediaContentViewController: UIViewController {

    let media: ResolutionMedia

    init(media: ResolutionMedia) {
        self.media = media
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
