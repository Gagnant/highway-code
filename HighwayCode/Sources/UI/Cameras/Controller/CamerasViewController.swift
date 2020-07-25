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
        viewModel.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        updateAnnotations(viewModel: viewModel)
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

    private func configureCameraView() {
        camerasMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MarkerAnnotationView")
    }

    private func updateAnnotations(viewModel: CamerasViewModel) {
        let currentAnnotations = camerasMapView.annotations.compactMap {
            $0 as? CameraAnnotation
        }
        let replacementCameras = Set(viewModel.cameras)
        let removedAnnotations = currentAnnotations.filter {
            !replacementCameras.contains($0.camera)
        }
        camerasMapView.removeAnnotations(removedAnnotations)
        let currentCameras = Set(currentAnnotations.map(\.camera))
        let addedAnnotations = replacementCameras.subtracting(currentCameras).map(CameraAnnotation.init)
        camerasMapView.addAnnotations(addedAnnotations)
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
        annotationView.animatesWhenAdded = true
        return annotationView
    }

}
