//
//  FinesListRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class FinesListRouter: IFinesListRouter {

    weak var controller: UIViewController?

    func resolution(id: Int) {
        let destination = FineDetailsBuilder.build(resolutionId: id)
        controller?.navigationController?.pushViewController(destination, animated: true)
    }

    func payment(resolutionId: Int) {
        let destination = PaymentBuilder.build(resolutionId: resolutionId)
        controller?.present(destination, animated: true, completion: nil)
    }

}
