//
//  SubscriptionRequest.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 28.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct SubscriptionRequest: Encodable {

    /// Docuement.
    let document: String

    /// Should be associated with user on remote.
    let savePersistent: Bool

    /// Vehicle plate.
    let vehiclePlate: String

}
