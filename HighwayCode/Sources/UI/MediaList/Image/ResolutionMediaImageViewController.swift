//
//  ResolutionMediaImageViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import SDWebImage

class ResolutionMediaImageViewController: ResolutionMediaContentViewController, UIScrollViewDelegate {

    @IBOutlet private var contentImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(media.type == .image)
        configureImageView()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentImageView
    }

    // MARK: -

    private func configureImageView() {
        contentImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        contentImageView.sd_imageTransition = .fade
        contentImageView.sd_setImage(with: media.url, completed: nil)
    }

}
