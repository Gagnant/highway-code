//
//  FineDetailsPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class FineDetailsPresenter: IFineDetailsPresenter {

    private let router: IFineDetailsRouter
    private let resolutionId: Int
    private let resolutionsService: ResolutionsService
    private let paymentsService: PaymentsService

    weak var view: IFineDetailsView?

    init(router: IFineDetailsRouter, resolutionId: Int, resolutionsService: ResolutionsService, paymentsService: PaymentsService) {
        self.router = router
        self.resolutionId = resolutionId
        self.resolutionsService = resolutionsService
        self.paymentsService = paymentsService
    }

    // MARK: - IFineDetailsPresenter

    func viewDidLoad() {
        updateView()
    }

    func viewWillAppear() {
        subscribeForUpdates()
        updateView()
    }

    func viewDidDisappear() {
        unsubscribeFromUpdates()
    }

    func didTapUpdate() {
        resolutionsService.resolutions.update()
    }

    func didTapPay() {
        router.payment(resolutionId: resolutionId)
    }

    // MARK: -

    private func subscribeForUpdates() {
        let observation: () -> Void = { [weak self] in
            self?.updateView()
        }
        resolutionsService.resolutions.require(self, observation: observation)
        paymentsService.orders.require(self, observation: observation)
    }

    private func unsubscribeFromUpdates() {
        resolutionsService.resolutions.unrequire(self)
        paymentsService.orders.unrequire(self)
    }

    private func updateView() {
        let resolutionsResource = resolutionsService.resolutions
        let _resolution = resolutionsResource.value?.first { [resolutionId] in
            return $0.id == resolutionId
        }
        guard let resolution = _resolution else {
            NSLog("Resolution with given id is missing.")
            return
        }
        let mediaViewModels = resolution.media.map { media -> FineDetailsViewModel.Media in
            return .init(type: media.type == .image ? .image : .video, url: media.url, action: nil)
        }
        let viewModel = FineDetailsViewModel(
            series: resolution.series,
            number: resolution.number,
            vehiclePlate: resolution.vehicle.plate,
            violationText: resolution.violationText,
            violationDate: resolution.violationDate,
            resolutionDate: resolution.resolutionDate,
            location: resolution.location,
            media: mediaViewModels,
            amount: resolution.amount,
            payAmount: resolution.payAmount,
            isPaid: paymentsService.isResolutionPaid(resolutionId: resolutionId) ?? false,
            isPaymentApproved: resolution.isPaid
        )
        view?.setLoading(resolutionsResource.isLoading)
        view?.update(with: viewModel)
    }

}
