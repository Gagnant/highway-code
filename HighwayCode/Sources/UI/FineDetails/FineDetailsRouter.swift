//
//  FineDetailsRouter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

final class FineDetailsRouter: IFineDetailsRouter {

    weak var controller: UIViewController?

    func payment(resolutionId: Int) {
        let destination = PaymentBuilder.build(resolutionId: resolutionId)
        controller?.present(destination, animated: true, completion: nil)
    }

    func media(resolutionId: Int, mediaId: String) {
        let destination = ResolutionMediaBuilder.build(resolutionId: resolutionId, mediaId: mediaId)
        controller?.present(destination, animated: true, completion: nil)
    }
    
}
