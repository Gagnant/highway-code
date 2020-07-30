//
//  ResolutionMediaBuilder.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit

class ResolutionMediaBuilder {
    
    static func build(resolutionId: Int, mediaId: String) -> UIViewController {
        let controller = ResolutionMediaViewController(
            resolutionId: resolutionId,
            mediaId: mediaId,
            resolutionsService: Core.shared.resolutionsService
        )
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
}
