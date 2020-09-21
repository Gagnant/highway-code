//
//  LocationStatusProvider.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 25.08.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

enum LocationAccessStatus {

    /// User has not yet made a choice with regards to this application.
    case notDetermined

    /// This application is not authorized to use location services.  Due
    /// to active restrictions on location services, the user cannot change
    /// this status, and may not have personally denied authorization
    case restricted

    /// User has explicitly denied authorization for this application, or
    /// location services are disabled in Settings.
    case denied

    /// User has granted authorization to use their location at any
    /// time.  Your app may be launched into the background by
    /// monitoring APIs such as visit monitoring, region monitoring,
    /// and significant location change monitoring.
    case allowedAlways

    /// User has granted authorization to use their location only while
    /// they are using your app.
    case allowedWhenInUse

    /// Indicating whether location services are disabled on the device.
    ///
    /// Users can enable or disable location services by toggling the
    /// Location Services switch in Settings > Privacy.
    case disabled

}

protocol LocationAccessStatusProvider {

    /// Current access status.
    var status: LocationAccessStatus { get }

    /// Invoked each time status changes.
    var onStatusChanged: (() -> Void)? { get set }

    /// Starts changes observation.
    func start()

    /// Stops changes observation.
    func stop()

    /// Requests the user’s permission to use location services while the
    /// app is in use.
    ///
    /// You must call this method or requestAlwaysAccess() before you
    /// can receive location-related information. You may call
    /// requestWhenInUseAccess() whenever the current authorization
    /// status is not determined.
    ///
    /// - Important:
    /// Your app must be in the foreground to show a location authorization
    /// prompt.
    /// This method runs asynchronously and prompts the user to grant
    /// permission to the app to use location services. The user prompt
    /// contains the text from the NSLocationWhenInUseUsageDescription
    /// key in your app Info.plist file, and the presence of that key is required
    /// when calling this method. The user prompt displays the following
    /// options, which determine the authorization your app can receive.
    func requestWhenInUseAccess()

    /// Requests the user’s permission for location services whether or
    /// not the app is in use.
    ///
    /// You must call this method or the requestWhenInUseAccess()
    /// method before you can receive location information. You may call
    /// requestAlwaysAccess() when the current authorization state is
    /// either: Not Determined, or When in Use.
    ///
    /// - Important:
    /// Your app must be in the foreground to show a location authorization
    /// prompt.
    /// The requestAlwaysAccess() method runs asynchronously. It prompts
    /// the user to grant permission to the app to use location services at any
    /// time, including when the user doesn’t know the app is running. To call
    /// this method, you must have NSLocationAlwaysUsageDescription
    /// and NSLocationWhenInUseUsageDescription keys in your app’s
    /// Info.plist file.
    func requestAlwaysAccess()

}

import CoreLocation

final class CoreLocationAccessStatusProvider: NSObject, LocationAccessStatusProvider, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?

    // MARK: - LocationAccessStatusObserver

    var status: LocationAccessStatus {
        if !CLLocationManager.locationServicesEnabled() {
            return .disabled
        }
        switch CLLocationManager.authorizationStatus() {
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorizedAlways:
            return .allowedAlways
        case .authorizedWhenInUse:
            return .allowedWhenInUse
        default:
            return .notDetermined
        }
    }

    var onStatusChanged: (() -> Void)?

    func start() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        self.locationManager = locationManager
    }

    func stop() {
        locationManager?.delegate = nil
        locationManager = nil
    }

    func requestAlwaysAccess() {
        assert(locationManager != nil)
        locationManager?.requestAlwaysAuthorization()
    }

    func requestWhenInUseAccess() {
        assert(locationManager != nil)
        locationManager?.requestWhenInUseAuthorization()
    }

    // MARK: - CBCentralManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onStatusChanged?()
    }

}
