//
//  FinesListInteractor.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation

class FinesListInteractor: IFinesListInteractor {

    let resolutionsService: ResolutionsService
    let paymentsService: PaymentsService

    init(resolutionsService: ResolutionsService, paymentsService: PaymentsService) {
        self.resolutionsService = resolutionsService
        self.paymentsService = paymentsService
    }

    // MARK: -

    weak var delegate: FinesListInteractorDelegate?

    func start() {
        let observation: () -> Void = { [weak self] in
            self?.delegate?.didChangeContent()
        }
        resolutionsService.resolutions.require(self, observation: observation)
        paymentsService.orders.require(self, observation: observation)
    }

    func stop() {
        paymentsService.orders.unrequire(self)
        resolutionsService.resolutions.unrequire(self)
    }

    func update() {
        resolutionsService.resolutions.update()
        resolutionsService.subscriptions.update()
        paymentsService.orders.update()
    }

    var isLoading: Bool {
        return resolutionsService.resolutions.isLoading || paymentsService.orders.isLoading
    }

    var unpaidResolutions: [Resolution] {
        let isIncluded: (Resolution) -> Bool = {
            return !self.isPaid(resolutionId: $0.id) && !$0.isExtinguished
        }
        return resolutionsService.resolutions.value?.filter(isIncluded) ?? []
    }

    var paidResolutions: [Resolution] {
        let isIncluded: (Resolution) -> Bool = {
            return self.isPaid(resolutionId: $0.id) && !$0.isExtinguished
        }
        return resolutionsService.resolutions.value?.filter(isIncluded) ?? []
    }

    var extinguishedResolutions: [Resolution] {
        return resolutionsService.resolutions.value?.filter(\.isExtinguished) ?? []
    }

    func isExtinguished(resolutionId id: Int) -> Bool {
        return resolutionsService.resolution(id: id)?.isExtinguished ?? false
    }

    func isPaid(resolutionId id: Int) -> Bool {
        return paymentsService.isResolutionPaid(resolutionId: id) ?? false
    }

}
