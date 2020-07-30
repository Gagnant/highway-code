//
//  VehicleFinesListInteractor.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

final class VehicleFinesListInteractor: FinesListInteractor, IVehicleFinesListInteractor {

    private let subscriptionId: Int

    init(resolutionsService: ResolutionsService, paymentsService: PaymentsService, subscriptionId: Int) {
        self.subscriptionId = subscriptionId
        super.init(resolutionsService: resolutionsService, paymentsService: paymentsService)
    }

    override var unpaidResolutions: [Resolution] {
        return super.unpaidResolutions.filter(isConnectedWith)
    }

    override var paidResolutions: [Resolution] {
        return super.paidResolutions.filter(isConnectedWith)
    }

    override var extinguishedResolutions: [Resolution] {
        return super.extinguishedResolutions.filter(isConnectedWith)
    }

    var subscription: VehicleSubscription? {
        return resolutionsService.subscription(id: subscriptionId)
    }

    func remove(success: @escaping () -> Void, failure: @escaping () -> Void) {
        resolutionsService.remove(subscriptionId: subscriptionId, success: success) { _ in failure() }
    }

    // MARK: -

    private func isConnectedWith(resolution: Resolution) -> Bool {
        let expectedVehicle = resolutionsService.subscription(id: subscriptionId)?.vehicle.plate
        return resolution.vehicle.plate == expectedVehicle
    }

}
