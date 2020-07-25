//
//  VehiclesListPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 27.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

class VehiclesListPresenter: IVehiclesListPresenter {

    private let resolutionsService: ResolutionsService
    private let router: IVehiclesListRouter

    weak var view: IVehiclesListView?

    init(resolutionsService: ResolutionsService, router: IVehiclesListRouter) {
        self.resolutionsService = resolutionsService
        self.router = router
    }

    // MARK: - IVehiclesListPresenter

    func viewDidLoad() {
        updateView()
    }

    func viewWillAppear() {
        startObservations()
        updateView()
    }

    func viewDidDisappear() {
        endObservations()
    }

    func didTapAddVehicles() {
        router.subscription()
    }

    // MARK: - Private

    private func updateView() {
        let subscriptions = resolutionsService.subscriptions
        let elementsViewModels = subscriptions.value?.map { subscription -> VehiclesListElementViewModel in
            let action: () -> Void = { [weak self] in
                self?.router.resolutions(subscriptionId: subscription.id)
            }
            return VehiclesListElementViewModel(plate: subscription.vehicle.plate, document: subscription.document, action: action)
        }
        let viewModel = VehiclesListViewModel(
            vehicles: elementsViewModels ?? [],
            isLoading: subscriptions.isLoading && elementsViewModels == nil,
            isContentMissing: !subscriptions.isLoading && elementsViewModels == nil
        )
        view?.update(viewModel: viewModel)
    }

    private func startObservations() {
        let observation: () -> Void = { [weak self] in
            self?.updateView()
        }
        resolutionsService.subscriptions.require(self, observation: observation)
    }

    private func endObservations() {
        resolutionsService.subscriptions.unrequire(self)
    }

}
