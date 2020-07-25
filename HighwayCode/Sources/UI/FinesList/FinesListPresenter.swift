//
//  FinesListPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

final class FinesListPresenter: IFinesListPresenter {

    private let resolutionsService: ResolutionsService
    private let paymentsService: PaymentsService
    private let router: IFinesListRouter

    weak var view: IFinesListView?

    init(router: IFinesListRouter, resolutionsService: ResolutionsService, paymentsService: PaymentsService) {
        self.router = router
        self.resolutionsService = resolutionsService
        self.paymentsService = paymentsService
    }

    // MARK: - FinesListPresenter

    func viewDidLoad() {
        configureView()
    }

    func viewWillAppear() {
        requireResources()
        updateResources()
    }

    func viewDidDisappear() {
        unrequireResources()
    }

    func didTapUpdate() {
        updateResources()
    }

    // MARK: - Private

    private func configureView() {
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListVehiclesViewModel(id: "vehicles-list"))
        ]
        elements += unpaidResolutionsElements + paidResolutionsElements + extinguishedResolutionsElements
        let viewModel = FinesListViewModel(
            title: NSLocalizedString("resolutions-list-navigation-title", comment: ""),
            elements: elements,
            isLoading: resolutionsService.resolutions.isLoading || paymentsService.orders.isLoading
        )
        view?.update(viewModel: viewModel)
    }

    private var unpaidResolutionsElements: [AnyFinesListElementViewModel] {
        let isIncluded: (Resolution) -> Bool = { [paymentsService] in
            let hasPaidOrder = paymentsService.isResolutionPaid(resolutionId: $0.id) ?? false
            return !($0.isPaid || hasPaidOrder)
        }
        guard let resolutions = resolutionsService.resolutions.value?.filter(isIncluded), !resolutions.isEmpty else {
            return []
        }
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListHeaderViewModel(id: "section-unpaid-header", name: NSLocalizedString("resolutions-list-unpaid-title", comment: "")))
        ]
        elements.append(contentsOf: resolutions.map(createViewModel))
        let tooltip = FinesListTooltipViewModel(
            id: "section-unpaid-tooltip",
            title: NSLocalizedString("resolutions-list-tooltip-unpaid-title", comment: ""),
            description: NSLocalizedString("resolutions-list-tooltip-unpaid-description", comment: "")
        )
        elements.append(.init(tooltip))
        return elements
    }

    private var paidResolutionsElements: [AnyFinesListElementViewModel] {
        let isIncluded: (Resolution) -> Bool = { [paymentsService] in
            let hasPaidOrder = paymentsService.isResolutionPaid(resolutionId: $0.id) ?? false
            return !$0.isPaid && hasPaidOrder
        }
        guard let resolutions = resolutionsService.resolutions.value?.filter(isIncluded), !resolutions.isEmpty else {
            return []
        }
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListHeaderViewModel(id: "section-paid-header", name: NSLocalizedString("resolutions-list-paid-title", comment: "")))
        ]
        elements.append(contentsOf: resolutions.map(createViewModel))
        let tooltip = FinesListTooltipViewModel(
            id: "section-paid-tooltip",
            title: NSLocalizedString("resolutions-list-tooltip-paid-title", comment: ""),
            description: NSLocalizedString("resolutions-list-tooltip-paid-description", comment: "")
        )
        elements.append(.init(tooltip))
        return elements
    }

    private var extinguishedResolutionsElements: [AnyFinesListElementViewModel] {
        guard let resolutions = resolutionsService.resolutions.value?.filter(\.isPaid), !resolutions.isEmpty else {
            return []
        }
        var elements: [AnyFinesListElementViewModel] = [
            .init(FinesListHeaderViewModel(id: "section-extinguished-header", name: NSLocalizedString("resolutions-list-extinguished-title", comment: "")))
        ]
        elements.append(contentsOf: resolutions.map(createViewModel))
        return elements
    }

    private func createViewModel(for resolution: Resolution) -> AnyFinesListElementViewModel {
        let hasPaidOrder = paymentsService.isResolutionPaid(
            resolutionId: resolution.id
        ) ?? false
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
            payAction: hasPaidOrder || resolution.isPaid ? nil : payAction
        )
        return AnyFinesListElementViewModel(viewModel)
    }

    private func requireResources() {
        let observation: () -> Void = { [weak self] in
            self?.configureView()
        }
        resolutionsService.resolutions.require(self, observation: observation)
        paymentsService.orders.require(self, observation: observation)
        configureView()
    }

    private func unrequireResources() {
        paymentsService.orders.unrequire(self)
        resolutionsService.resolutions.unrequire(self)
    }

    private func updateResources() {
        resolutionsService.resolutions.update()
        paymentsService.orders.update()
    }

}
