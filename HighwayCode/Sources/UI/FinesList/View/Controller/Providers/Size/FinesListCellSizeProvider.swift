//
//  RadiatorValveGroupCellSizeProvider.swift
//  HighwayCode
//
//  Created by Andrew Vysotskyi on 22.03.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class FinesListCellSizeProvider: IFinesListElementCellSizeProvider, IFinesListElementViewModelVisitor {

    private lazy var resolutionTemplateCell = FinesListFineDetailsCollectionCell.instantiate()
    private lazy var headerTemplateCell = FinesListHeaderCollectionCell.instantiate()
    private lazy var tooltipTemplateCell = FinesListTooltipCollectionCell.instantiate()

    // MARK: -

    private let collectionView: UICollectionView

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    // MARK: -

    func size(for element: AnyFinesListElementViewModel) -> CGSize {
        return element.accept(visitor: self)
    }

    // MARK: - IFinesListElementViewModelVisitor

    func visit(viewModel: FinesListVehiclesViewModel) -> CGSize {
        return CGSize(width: adjustedComponentWidth, height: 150)
    }

    func visit(viewModel: FinesListFineDetailsViewModel) -> CGSize {
        resolutionTemplateCell.prepareForReuse()
        resolutionTemplateCell.configure(viewModel: viewModel)
        return size(for: resolutionTemplateCell.contentView)
    }

    func visit(viewModel: FinesListTooltipViewModel) -> CGSize {
        tooltipTemplateCell.prepareForReuse()
        tooltipTemplateCell.configure(viewModel: viewModel)
        return size(for: tooltipTemplateCell.contentView)
    }

    func visit(viewModel: FinesListHeaderViewModel) -> CGSize {
        headerTemplateCell.prepareForReuse()
        headerTemplateCell.configure(title: viewModel.name)
        return size(for: headerTemplateCell.contentView)
    }

    func visit(viewModel: FinesListActionViewModel) -> CGSize {
        return CGSize(width: adjustedComponentWidth, height: 72)
    }

    // MARK: - Private

    private func size(for view: UIView) -> CGSize {
        let targetSize = CGSize(width: adjustedComponentWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = view.systemLayoutSizeFitting(
            targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel
        )
        return CGSize(width: adjustedComponentWidth, height: size.height)
    }

    private var adjustedComponentWidth: CGFloat {
        return collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
    }

}
