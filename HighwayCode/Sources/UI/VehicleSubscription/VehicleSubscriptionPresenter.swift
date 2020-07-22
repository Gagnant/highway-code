//
//  VehicleSubscriptionPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class VehicleSubscriptionPresenter: IVehicleSubscriptionPresenter {

    private var document: String?
    private var vehicleNumber: String?


    private let router: IVehicleSubscriptionRouter
    private let resolutions: ResolutionsService

    weak var view: IVehicleSubscriptionView?

    init(router: IVehicleSubscriptionRouter, resolutions: ResolutionsService) {
        self.router = router
        self.resolutions = resolutions
    }

    // MARK: - IVehicleSubscriptionPresenter

    func viewDidLoad() {
        updateView()
    }

    func didChange(document: String) {
        self.document = document
        updateView()
    }

    func didChange(vehicle: String) {
        self.vehicleNumber = vehicle
        updateView()
    }

    func didTapCancel() {
        router.dismiss()
    }

    func didTapNext() {
        guard let document = self.document, let vehicleNumber = self.vehicleNumber else {
            NSLog("Car information is missing!")
            return
        }
        assert(!document.isEmpty && !vehicleNumber.isEmpty)
        view?.setLoading(true)
        resolutions.subscribe(document: document, vehicle: vehicleNumber, success: { [weak self] in
            self?.view?.setLoading(false)
            self?.router.next()
        }, error: { [weak self] error in
            self?.view?.setLoading(false)
            self?.router.error(message: error.localizedDescription)
        })
    }

    // MARK: - Private

    private func updateView() {
        let isDocumentValid = document.map { !$0.isEmpty } ?? false
        let isVehicleNumberValid = vehicleNumber.map { !$0.isEmpty } ?? false
        let viewModel = VehicleSubscriptionViewModel(
            isNextButtonEnabled: isDocumentValid && isVehicleNumberValid
        )
        view?.update(viewModel: viewModel)
    }

}
