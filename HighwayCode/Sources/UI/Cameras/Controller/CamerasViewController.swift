//
//  CamerasViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import MapKit

class CamerasViewController: UIViewController, ICamerasView {

    @IBOutlet private var camerasMapView: MKMapView!
    private let presenter: ICamerasPresenter

    init(presenter: ICamerasPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTabBar()
        configureCameraView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }

    // MARK: -

    @objc private func didTapRefreshButton() {
        presenter.didTapRefreshButton()
    }

    // MARK: -

    func update(with viewModel: CamerasViewModel) {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }


        let existingAnot = camerasMapView.annotations.compactMap { $0 as? CameraAnnotation }

        let removed = existingAnot.filter { annot -> Bool in
            return !viewModel.cameras.contains(annot.camera)
        }
        camerasMapView.removeAnnotations(removed)

        let added = viewModel.cameras.filter { camera -> Bool in
            return !existingAnot.map { $0.camera }.contains(camera)
        }.map(CameraAnnotation.init)


        camerasMapView.addAnnotations(added)


    }

    // MARK: -

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        return view
    }()

    private func configureNavigationBar() {
        navigationItem.title = NSLocalizedString("screen-cameras-navigation-title", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefreshButton)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }

    private func configureTabBar() {
        precondition(navigationController?.viewControllers.first == self)
        navigationController?.tabBarItem.title = NSLocalizedString("screen-cameras-tab-title", comment: "")

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        let image = renderer.image { context in
            #imageLiteral(resourceName: "SpeedCamera").draw(in: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        }
        navigationController?.tabBarItem.image = image
    }

    private func configureCameraView() {
        camerasMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MarkerAnnotationView")
    }

}

extension CamerasViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CameraAnnotation else {
            return nil
        }
        let annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "MarkerAnnotationView", for: annotation
        ) as! MKMarkerAnnotationView
        annotationView.titleVisibility = .hidden
        annotationView.subtitleVisibility = .adaptive
        annotationView.glyphImage = #imageLiteral(resourceName: "SpeedCamera")
        return annotationView
    }

}
