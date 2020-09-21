//
//  RadiatorValveGroupCellProvider.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 22.03.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

protocol IFinesListCellProvider: class {

    /// Prepares provider for upcomming work.
    func prepare(controller: UIViewController, view: UICollectionView)

    /// Returns cell for given item.
    func cell<Item: IFinesListElementViewModel>(for item: Item, at indexPath: IndexPath) -> UICollectionViewCell

}

final class FinesListCellProvider: IFinesListElementViewModelVisitor, IFinesListCellProvider {

    private weak var collectionView: UICollectionView?
    private weak var controller: UIViewController?

    // MARK: - IFinesListCellProvider

    private var currentIndexPath: IndexPath!

    func prepare(controller: UIViewController, view: UICollectionView) {
        self.collectionView = view
        self.controller = controller
        // TODO: Instead of registering and using vehicles cell directly DI should be used to
        // hide implementation details.
        view.register(
            FinesListVehiclesCell.self,
            forCellWithReuseIdentifier: FinesListVehiclesCell.reuseIdentifier
        )
        view.register(reusableCell: FinesListFineDetailsCollectionCell.self)
        view.register(reusableCell: FinesListHeaderCollectionCell.self)
        view.register(reusableCell: FinesListActionCollectionCell.self)
        view.register(reusableCell: FinesListTooltipCollectionCell.self)
    }

    func cell<Item: IFinesListElementViewModel>(for item: Item, at indexPath: IndexPath) -> UICollectionViewCell {
        currentIndexPath = indexPath
        let cell = item.accept(visitor: self)
        currentIndexPath = nil
        return cell
    }

    // MARK: - IFinesListElementViewModelVisitor

    func visit(viewModel: FinesListVehiclesViewModel) -> UICollectionViewCell {
        let cell = collectionView!.dequeueReusableCell(
            withReuseIdentifier: FinesListVehiclesCell.reuseIdentifier, for: currentIndexPath
        )
        let vehiclesCell = cell as! FinesListVehiclesCell
        vehiclesCell.configure(with: controller!)
        return cell
    }

    func visit(viewModel: FinesListFineDetailsViewModel) -> UICollectionViewCell {
        let cell = collectionView!.dequeueReusableCell(
            withReuseIdentifier: FinesListFineDetailsCollectionCell.reuseIdentifier, for: currentIndexPath
        )
        let descriptionCell = cell as? FinesListFineDetailsCollectionCell
        descriptionCell?.configure(viewModel: viewModel)
        return cell
    }

    func visit(viewModel: FinesListTooltipViewModel) -> UICollectionViewCell {
        let cell = collectionView!.dequeueReusableCell(
            withReuseIdentifier: FinesListTooltipCollectionCell.reuseIdentifier, for: currentIndexPath
        )
        let descriptionCell = cell as? FinesListTooltipCollectionCell
        descriptionCell?.configure(viewModel: viewModel)
        return cell
    }

    func visit(viewModel: FinesListHeaderViewModel) -> UICollectionViewCell {
        let cell = collectionView!.dequeueReusableCell(
            withReuseIdentifier: FinesListHeaderCollectionCell.reuseIdentifier, for: currentIndexPath
        )
        let headerCell = cell as? FinesListHeaderCollectionCell
        headerCell?.configure(title: viewModel.name)
        return cell
    }

    func visit(viewModel: FinesListActionViewModel) -> UICollectionViewCell {
        let cell = collectionView!.dequeueReusableCell(
            withReuseIdentifier: FinesListActionCollectionCell.reuseIdentifier, for: currentIndexPath
        )
        let actionCell = cell as? FinesListActionCollectionCell
        actionCell?.configure(viewModel: viewModel)
        return cell
    }

}
