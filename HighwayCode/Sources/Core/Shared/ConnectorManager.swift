//
//  ConnectorManager.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

struct ConnectorManager {

    /// Subscription connector.
    let http: HttpConnector

    /// Subscriptions connector.
    let subscription: SubscriptionConnector

    /// Callable connector.
    let callable: CallableConnector

}
