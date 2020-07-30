//
//  VehicleSubscriptionViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 22.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import NVActivityIndicatorViewExtended

class VehicleSubscriptionViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet private var documentTextField: UITextField!
    @IBOutlet private var vehicleTextField: UITextField!
    @IBOutlet private var documentContainerView: UIView!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var contentScrollView: UIScrollView!

    private lazy var keyboardManager = {
        return KeyboardAvoidanceManager(scrollView: contentScrollView, distance: 16)
    }()

    private let presenter: IVehicleSubscriptionPresenter

    init(presenter: IVehicleSubscriptionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardManager.stop()
    }

    // MARK: - Actions

    @IBAction private func didChangeDocument() {
        presenter.didChange(document: documentTextField.text ?? "")
    }

    @IBAction private func didChangeVehicle() {
        presenter.didChange(vehicle: vehicleTextField.text ?? "")
    }

    @IBAction private func didTapNextButton() {
        presenter.didTapNext()
    }

    @IBAction private func didTapContent() {
        view.endEditing(true)
    }

    @objc private func didTapCancelButton() {
        presenter.didTapCancel()
    }

    // MARK: -

    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton)
        )
        navigationItem.title = NSLocalizedString("vehicle-subscription-navigation-title", comment: "")
        navigationItem.largeTitleDisplayMode = .never
    }

}

extension VehicleSubscriptionViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == vehicleTextField {
            documentTextField.becomeFirstResponder()
            return false
        } else if textField === documentTextField {
            presenter.didTapNext()
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === vehicleTextField {
            keyboardManager.setTrackedView(documentContainerView)
        } else if textField === documentTextField {
            keyboardManager.setTrackedView(nextButton)
        }
        return true
    }

}

extension VehicleSubscriptionViewController: IVehicleSubscriptionView {

    func update(viewModel: VehicleSubscriptionViewModel) {
        nextButton.isEnabled = viewModel.isNextButtonEnabled
        nextButton.alpha = viewModel.isNextButtonEnabled ? 1.0 : 0.7
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            startAnimating(type: .circleStrokeSpin)
            view.endEditing(true)
        } else {
            stopAnimating()
        }
    }
    
}
