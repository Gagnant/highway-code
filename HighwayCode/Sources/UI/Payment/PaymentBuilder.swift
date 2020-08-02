//
//  PaymentBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 26.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class PaymentBuilder {

    static func build(resolutionId: Int) -> UIViewController {
        let controller = PaymentViewController(
            resolutionId: resolutionId, paymentsService: Core.shared.payments
        )
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }

}
