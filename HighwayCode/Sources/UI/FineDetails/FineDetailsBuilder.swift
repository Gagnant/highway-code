//
//  FineDetailsBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class FineDetailsBuilder {

    static func build(resolutionId: Int) -> UIViewController {
        let router = FineDetailsRouter()
        let presenter = FineDetailsPresenter(
            router: router,
            resolutionId: resolutionId,
            resolutionsService: Core.shared.resolutions,
            paymentsService: Core.shared.payments
        )
        let controller = FineDetailsViewController(presenter: presenter)
        presenter.view = controller
        router.controller = controller
        return controller
    }

}
