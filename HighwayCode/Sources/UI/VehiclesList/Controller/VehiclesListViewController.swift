//
//  VehiclesListViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DifferenceKit

class VehiclesListViewController: UIViewController, IVehiclesListView {

    @IBOutlet private var contentCollectionView: UICollectionView!
    @IBOutlet private var activityIndicator: NVActivityIndicatorView!
    @IBOutlet private var missingContentContainer: UIView!

    private var vehiclesViewModels: [VehiclesListElementViewModel]
    private let presenter: IVehiclesListPresenter

    init(presenter: IVehiclesListPresenter) {
        self.presenter = presenter
        self.vehiclesViewModels = []
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureActivityIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.performWithoutAnimation(presenter.viewWillAppear)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }

    // MARK: - IVehiclesListView

    func update(viewModel: VehiclesListViewModel) {
        UIView.animate(withDuration: 0.2) {
            self.missingContentContainer.alpha = viewModel.isContentMissing ? 1.0 : 0.0
        }
        let changeset = StagedChangeset(source: vehiclesViewModels, target: viewModel.vehicles)
        contentCollectionView.reload(using: changeset) { [weak self] vehicles in
            self?.vehiclesViewModels = vehicles
        }
        setLoading(viewModel.isLoading)
    }

    // MARK: -

    @IBAction private func didTapAddVehicles() {
        presenter.didTapAddVehicles()
    }

    // MARK: -

    private func configureCollectionView() {
        contentCollectionView.register(
            VehiclesListElementCollectionCell.nib,
            forCellWithReuseIdentifier: VehiclesListElementCollectionCell.reuseIdentifier
        )
        contentCollectionView.contentInset.left = 16
        contentCollectionView.contentInset.right = 16
    }

    private func configureActivityIndicator() {
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = .gray
    }

    private func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

}

extension VehiclesListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehiclesViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VehiclesListElementCollectionCell.reuseIdentifier, for: indexPath
        ) as! VehiclesListElementCollectionCell
        let viewModel = vehiclesViewModels[indexPath.row]
        cell.configure(viewModel: viewModel)
        return cell
    }

}

extension VehiclesListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt path: IndexPath) -> CGSize {
        let height = collectionView.bounds.inset(by: collectionView.adjustedContentInset).height
        return CGSize(width: 200, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }

}

