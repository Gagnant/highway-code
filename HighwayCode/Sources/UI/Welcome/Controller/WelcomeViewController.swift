//
//  WelcomeViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 30.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WelcomeViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet private var continueContainerView: UIView!

    private let authService: AuthenticationService
    private let router: IWelcomeRouter

    init(router: IWelcomeRouter, authenticationService: AuthenticationService) {
        self.authService = authenticationService
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    // MARK: -

    @IBAction private func didTapContinue() {
        let success: () -> Void = { [weak self] in
            self?.router.next()
            self?.setLoading(false)
        }
        let failure: () -> Void = { [weak self] in
            self?.router.error()
            self?.setLoading(false)
        }
        setLoading(true)
        authService.authenticate(success: success, failure: failure)
    }

    private func setLoading(_ isLoading: Bool) {
        isLoading ? startAnimating(type: .circleStrokeSpin) : stopAnimating()
    }

    private func updateView() {
        continueContainerView.isHidden = false
    }

}
