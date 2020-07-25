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
    @IBOutlet private var nextButton: UIButton!

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
        navigationItem.largeTitleDisplayMode = .always
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

}

extension VehicleSubscriptionViewController: IVehicleSubscriptionView {

    func update(viewModel: VehicleSubscriptionViewModel) {
        nextButton.isEnabled = viewModel.isNextButtonEnabled
        nextButton.alpha = viewModel.isNextButtonEnabled ? 1.0 : 0.7
    }

    func setLoading(_ isLoading: Bool) {
        isLoading ? startAnimating(type: .circleStrokeSpin) : stopAnimating()
    }
    
}
