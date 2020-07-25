//
//  CamerasPresenter.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 21.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

final class CamerasPresenter: ICamerasPresenter {

    private let camerasService: CamerasService
    weak var view: ICamerasView?

    init(camerasService: CamerasService) {
        self.camerasService = camerasService
    }

    // MARK: - ICamerasPresenter

    func viewWillAppear() {
        let camerasResource = camerasService.cameras
        camerasResource.require(self) { [weak self] in
            self?.updateView()
        }
        camerasResource.update()
        updateView()
    }

    func viewDidDisappear() {
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
            isLoading: camerasService.cameras.isLoading
        )
        view?.update(with: viewModel)
    }

}
