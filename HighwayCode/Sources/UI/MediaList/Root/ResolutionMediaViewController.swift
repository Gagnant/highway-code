//
//  ResolutionMediaViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class ResolutionMediaViewController: UIViewController {

    @IBOutlet private var contentTitleLabel: UILabel!

    private let resolutionsService: ResolutionsService
    private let mediaId: String
    private let resolutionId: Int

    init(resolutionId: Int, mediaId: String, resolutionsService: ResolutionsService) {
        self.resolutionId = resolutionId
        self.mediaId = mediaId
        self.resolutionsService = resolutionsService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageController()
        configureViewControllers()
        updateNavigationItem()
    }

    // MARK: -

    @IBAction private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    /// Should be invoked to perform initial controllers configuration.
    private func configureViewControllers() {
        let _referenceMediaIndex = mediaItems.first { $0.id == mediaId } ?? mediaItems.first
        guard let referenceMedia = _referenceMediaIndex else {
            NSLog("Inconsistent state.")
            return
        }
        let contentController = self.contentController(for: referenceMedia)
        contentPageController.setViewControllers([contentController], direction: .forward, animated: false, completion: nil)
    }

    private func updateNavigationItem() {
        let referenceMediaController = contentPageController.viewControllers?.first as! ResolutionMediaContentViewController
        let referenceMedia = referenceMediaController.media
        let _referenceMediaIndex = mediaItems.firstIndex {
            $0.id == referenceMedia.id
        }
        guard let referenceMediaIndex = _referenceMediaIndex else {
            return
        }
        let localizedTitle = String.localizedStringWithFormat(
            NSLocalizedString("resolution-media-title-connector", comment: ""), referenceMediaIndex + 1, mediaItems.count
        )
        contentTitleLabel.text = localizedTitle
    }

    private lazy var contentPageController: UIPageViewController = {
        let options: [UIPageViewController.OptionsKey: Any] = [
            .interPageSpacing: 10,
            .spineLocation: UIPageViewController.SpineLocation.none
        ]
        let controller = UIPageViewController(
            transitionStyle: .scroll, navigationOrientation: .horizontal, options: options
        )
        return controller
    }()

    private func configurePageController() {
        contentPageController.dataSource = self
        contentPageController.delegate = self
        addChild(contentPageController)
        contentPageController.view.translatesAutoresizingMaskIntoConstraints = true
        contentPageController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentPageController.view.frame = view.bounds
        view.addSubview(contentPageController.view)
        view.sendSubviewToBack(contentPageController.view)
        contentPageController.didMove(toParent: self)
    }

    // MARK: -

    private lazy var mediaItems: [ResolutionMedia] = {
        return resolutionsService.resolution(id: resolutionId)?.media ?? []
    }()

    private func contentController(for media: ResolutionMedia) -> ResolutionMediaContentViewController {
        if media.type == .image {
            return ResolutionMediaImageViewController(media: media)
        }
        return ResolutionMediaVideoViewController(media: media)
    }

    private func media(after referenceMedia: ResolutionMedia) -> ResolutionMedia? {
        let _referenceMediaIndex = mediaItems.firstIndex {
            $0.id == referenceMedia.id
        }
        guard let referenceMediaIndex = _referenceMediaIndex, referenceMediaIndex + 1 < mediaItems.count, !mediaItems.isEmpty else {
            return nil
        }
        return mediaItems[referenceMediaIndex + 1]
    }

    private func media(before referenceMedia: ResolutionMedia) -> ResolutionMedia? {
        let _referenceMediaIndex = mediaItems.firstIndex {
            $0.id == referenceMedia.id
        }
        guard let referenceMediaIndex = _referenceMediaIndex, referenceMediaIndex - 1 >= 0, !mediaItems.isEmpty else {
            return nil
        }
        return mediaItems[referenceMediaIndex - 1]
    }

}

extension ResolutionMediaViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        updateNavigationItem()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let referenceMediaController = viewController as! ResolutionMediaContentViewController
        return media(before: referenceMediaController.media).map(contentController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let referenceMediaController = viewController as! ResolutionMediaContentViewController
        return media(after: referenceMediaController.media).map(contentController)
    }

}
