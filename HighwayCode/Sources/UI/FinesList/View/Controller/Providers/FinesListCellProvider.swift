//
//  RadiatorValveGroupCellProvider.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 22.03.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

struct FinesListCellProvider: IFinesListElementViewModelVisitor {

    private let collectionView: UICollectionView
    private let indexPath: IndexPath
    private let controller: UIViewController
    private let vehiclesListControllerFactory: VehiclesListControllerFactory

    init(collectionView: UICollectionView, controller: UIViewController, vehiclesListControllerFactory: VehiclesListControllerFactory, indexPath: IndexPath) {
        self.collectionView = collectionView
        self.indexPath = indexPath
        self.vehiclesListControllerFactory = vehiclesListControllerFactory
        self.controller = controller
    }

    // MARK: - FinesListCellProvider

    func visit(viewModel: FinesListVehiclesViewModel) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HostingCollectionCell.reuseIdentifier, for: indexPath
        )
        let hostingCell = cell as! HostingCollectionCell
        hostingCell.configure(hosted: vehiclesListControllerFactory.vehiclesListController(), parent: controller)
        return cell
    }

    func visit(viewModel: FinesListFineDetailsViewModel) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FinesListFineDetailsCollectionCell.reuseIdentifier, for: indexPath
        )
        let descriptionCell = cell as? FinesListFineDetailsCollectionCell
        descriptionCell?.configure(viewModel: viewModel)
        return cell
    }

    func visit(viewModel: FinesListTooltipViewModel) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FinesListTooltipCollectionCell.reuseIdentifier, for: indexPath
        )
        let descriptionCell = cell as? FinesListTooltipCollectionCell
        descriptionCell?.configure(viewModel: viewModel)
        return cell
    }

    func visit(viewModel: FinesListHeaderViewModel) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FinesListHeaderCollectionCell.reuseIdentifier, for: indexPath
        )
        let headerCell = cell as? FinesListHeaderCollectionCell
        headerCell?.configure(title: viewModel.name)
        return cell
    }

    func visit(viewModel: FinesListActionViewModel) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FinesListActionCollectionCell.reuseIdentifier, for: indexPath
        )
        let actionCell = cell as? FinesListActionCollectionCell
        actionCell?.configure(viewModel: viewModel)
        return cell
    }

}

protocol VehiclesListControllerFactory {

    /// Creates vehicles list controller.
    func vehiclesListController() -> UIViewController

}
