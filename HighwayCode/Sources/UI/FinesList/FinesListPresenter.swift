//
//  FinesListPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class FinesListPresenter: IFinesListPresenter, FinesListInteractorDelegate {

    private let router: IFinesListRouter
    private var interactor: IFinesListInteractor

    /// View.
    weak var view: IFinesListView?

    init(router: IFinesListRouter, interactor: IFinesListInteractor) {
        self.router = router
        self.interactor = interactor
    }

    // MARK: - FinesListPresenter

    func viewDidLoad() {
        interactor.delegate = self
        configureView()
    }

    func viewWillAppear() {
        interactor.start()
    }

    func viewDidDisappear() {
        interactor.stop()
    }

    func didTapUpdate() {
        interactor.update()
    }

    func didChangeContent() {
        configureView()
    }

    // MARK: -

    func configureView() {
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListVehiclesViewModel(id: "vehicles-list"))
        ]
        elements += unpaidResolutionsElements + paidResolutionsElements + extinguishedResolutionsElements
        let viewModel = FinesListViewModel(
            title: Localized.Screen.ResolutionsList.navigationTitle,
            elements: elements,
            isRefreshing: interactor.isLoading
        )
        view?.update(viewModel: viewModel)
    }

    // MARK: - Private

    var unpaidResolutionsElements: [AnyFinesListElementViewModel] {
        let resolutions = interactor.unpaidResolutions
        guard !resolutions.isEmpty else {
            return []
        }
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListHeaderViewModel(
                id: "section-unpaid-header", name: Localized.Screen.ResolutionsList.unpaidTitle
            ))
        ]
        elements.append(contentsOf: resolutions.map(createViewModel))
        let tooltip = FinesListTooltipViewModel(
            id: "section-unpaid-tooltip",
            title: Localized.Screen.ResolutionsList.Tooltip.unpaidTitle,
            description: Localized.Screen.ResolutionsList.Tooltip.unpaidDescription
        )
        elements.append(.init(tooltip))
        return elements
    }

    var paidResolutionsElements: [AnyFinesListElementViewModel] {
        let resolutions = interactor.paidResolutions
        guard !resolutions.isEmpty else {
            return []
        }
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListHeaderViewModel(
                id: "section-paid-header", name: Localized.Screen.ResolutionsList.paidTitle
            ))
        ]
        elements.append(contentsOf: resolutions.map(createViewModel))
        let tooltip = FinesListTooltipViewModel(
            id: "section-paid-tooltip",
            title: Localized.Screen.ResolutionsList.Tooltip.paidTitle,
            description: Localized.Screen.ResolutionsList.Tooltip.paidDescription
        )
        elements.append(.init(tooltip))
        return elements
    }

    var extinguishedResolutionsElements: [AnyFinesListElementViewModel] {
        let resolutions = interactor.extinguishedResolutions
        guard !resolutions.isEmpty else {
            return []
        }
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListHeaderViewModel(
                id: "section-extinguished-header", name: Localized.Screen.ResolutionsList.extinguishedTitle
            ))
        ]
        elements.append(contentsOf: resolutions.map(createViewModel))
        return elements
    }

    private func createViewModel(for resolution: Resolution) -> AnyFinesListElementViewModel {
        let mainAction = TaggedClosureBox(id: "action-main") { [router] in
            router.resolution(id: resolution.id)
        }
        let payAction = TaggedClosureBox(id: "action-pay") { [router] in
            router.payment(resolutionId: resolution.id)
        }
        let viewModel = FinesListFineDetailsViewModel(
            id: String(resolution.id),
            amount: resolution.amount,
            payAmount: resolution.payAmount,
            vehicleNumber: resolution.vehicle.plate,
            date: resolution.violationDate,
            mainAction: mainAction,
            payAction: interactor.isPaid(resolutionId: resolution.id) || resolution.isExtinguished ? nil : payAction
        )
        return AnyFinesListElementViewModel(viewModel)
    }

}
