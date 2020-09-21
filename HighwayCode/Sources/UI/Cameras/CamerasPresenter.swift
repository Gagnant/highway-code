//
//  CamerasPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

final class CamerasPresenter: ICamerasPresenter {

    private let camerasService: CamerasService
    private var locationAccessProvider: LocationAccessStatusProvider

    weak var view: ICamerasView?

    init(camerasService: CamerasService, locationAccessProvider: LocationAccessStatusProvider) {
        self.camerasService = camerasService
        self.locationAccessProvider = locationAccessProvider
    }

    // MARK: - ICamerasPresenter

    func viewWillAppear() {
        let camerasResource = camerasService.cameras
        camerasResource.require(self) { [weak self] in
            self?.updateView()
        }
        startLocationStatusMonitoring()
        camerasResource.update()
        updateView()
    }

    func viewDidAppear() {
        requestLocationAccessIfNeeded()
    }

    func viewDidDisappear() {
        locationAccessProvider.stop()
        camerasService.cameras.unrequire(self)
    }

    func didTapRefreshButton() {
        camerasService.cameras.update()
    }

    // MARK: - Private

    private func updateView() {
        let cameras = camerasService.cameras.value?.map { camera -> CameraViewModel in
            return .init(name: camera.name, address: camera.address, location: camera.location)
        }
        let viewModel = CamerasViewModel(
            cameras: cameras ?? [],
            locationAccess: locationAccessViewModel,
            isLoading: camerasService.cameras.isLoading
        )
        view?.update(with: viewModel)
    }

    private func requestLocationAccessIfNeeded() {
        guard locationAccessProvider.status == .notDetermined else {
            return
        }
        locationAccessProvider.requestWhenInUseAccess()
    }

    private func startLocationStatusMonitoring() {
        locationAccessProvider.onStatusChanged = { [weak self] in
            self?.updateView()
        }
        locationAccessProvider.start()
    }

    private var locationAccessViewModel: CamerasViewModel.LocationAccess {
        switch locationAccessProvider.status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .allowedAlways, .allowedWhenInUse:
            return .allowed
        case .disabled:
            return .disabled
        }
    }

}
