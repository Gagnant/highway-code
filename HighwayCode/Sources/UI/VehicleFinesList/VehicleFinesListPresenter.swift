//
//  VehicleFinesListPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

final class VehicleFinesListPresenter: FinesListPresenter {

    private let interactor: IVehicleFinesListInteractor
    private let router: IVehicleFinesListRouter

    init(router: IVehicleFinesListRouter, interactor: IVehicleFinesListInteractor, subscriptionId: Int) {
        self.interactor = interactor
        self.router = router
        super.init(router: router, interactor: interactor)
    }

    override func configureView() {
        var elements: [AnyFinesListElementViewModel] = []
        elements += unpaidResolutionsElements + paidResolutionsElements + extinguishedResolutionsElements
        let actionElement = FinesListActionViewModel(
            id: "vehicle-action",
            title: NSLocalizedString("vehicle-resolutions-action-remove", comment: ""),
            isDestructive: true,
            handler: TaggedClosureBox(id: "vehicle-action") { [weak self] in self?.removeSubscription() }
        )
        elements.append(AnyFinesListElementViewModel(actionElement))
        let viewModel = FinesListViewModel(
            title: interactor.subscription?.vehicle.plate ?? "",
            elements: elements,
            isRefreshing: interactor.isLoading
        )
        view?.update(viewModel: viewModel)
    }

    // MARK: -

    private func removeSubscription() {
        let confirmation: () -> Void = { [interactor, router, view] in
            let success = {
                view?.setLoading(false)
                router.back()
            }
            let failure = {
                view?.setLoading(false)
                router.error()
            }
            view?.setLoading(true)
            interactor.remove(success: success, failure: failure)
        }
        router.removal(confirmation: confirmation)
    }

}
