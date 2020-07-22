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

    private let isSkipAvailable: Bool
    private let presenter: IVehicleSubscriptionPresenter

    init(presenter: IVehicleSubscriptionPresenter, isSkipAvailable: Bool) {
        self.presenter = presenter
        self.isSkipAvailable = isSkipAvailable
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        configureTextFields()
//        configureKeyboardBehaviour()
        configureNavigationItem()
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

    @objc private func didTapCancelButton() {
        presenter.didTapCancel()
    }

    // MARK: -

    //    private func configureTextFields() {
    //        let barcodeStringAttributes: [NSAttributedString.Key: Any] = [
    //            .font: UIFont(name: "OpenSans-Light", size: 15) as Any,
    //            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) as Any
    //        ]
    //        let amountStringAttributes: [NSAttributedString.Key: Any] = [
    //            .font: UIFont(name: "OpenSans-Light", size: 15) as Any,
    //            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) as Any
    //        ]
    //        barcodeTextField.attributedPlaceholder = NSAttributedString(string: "REQUIRED", attributes: barcodeStringAttributes)
    //        amountTextField.attributedPlaceholder = NSAttributedString(string: "REQUIRED", attributes: amountStringAttributes)
    //        currencyTextField.inputView = currencyPickerView
    //    }

    private func configureNavigationItem() {
        navigationItem.title = NSLocalizedString("screen-vehicle-subscription-navigation-title", comment: "")
        navigationItem.largeTitleDisplayMode = .always
        guard isSkipAvailable else {
            return
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton)
        )
    }

}

extension VehicleSubscriptionViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == vehicleTextField {
            documentTextField.becomeFirstResponder()
            return false
        }
        return true
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField === currencyTextField {
//            // Ensures that currency can be modified only programmatically.
//            return false
//        } else if textField === amountTextField {
//            let currentText = textField.text as NSString? ?? ""
//            let desiredText = currentText.replacingCharacters(in: range, with: string)
//            return desiredText.isEmpty ? true : decimalValue(of: desiredText) != nil
//        }
//        return true
//    }

}

extension VehicleSubscriptionViewController: IVehicleSubscriptionView {

    func update(viewModel: VehicleSubscriptionViewModel) {
        nextButton.isEnabled = viewModel.isNextButtonEnabled
    }

    func setLoading(_ isLoading: Bool) {
        isLoading ? startAnimating(type: .circleStrokeSpin) : stopAnimating()
    }

    //    func update(viewModel: BagDetailsViewModel) {
    //        barcodeTextField.text = viewModel.barcode
    //        if amountTextField.text.flatMap(decimalValue) != viewModel.amount {
    //            amountTextField.text = viewModel.amount.flatMap(stringValue)
    //        }
    //        updateCurrencies(viewModel: viewModel)
    //        nextButton.isEnabled = viewModel.isNextEnabled
    //    }
    //
    //    func setLoading(_ isLoading: Bool) {
    //        isLoading ? startAnimating(type: .circleStrokeSpin) : stopAnimating()
    //    }
    //
    //    private func updateCurrencies(viewModel: BagDetailsViewModel) {
    //        if viewModel.currencies == nil || viewModel.selectedCurrency == nil {
    //            currencyTextField.endEditing(true)
    //            currencyTextField.isHidden = true
    //            currencyLoadingIndicator.startAnimating()
    //        } else {
    //            currencyTextField.isHidden = false
    //            currencyLoadingIndicator.stopAnimating()
    //        }
    //        currencyTextField.text = viewModel.selectedCurrency?.currencyCode
    //        if currencies != viewModel.currencies {
    //            currencies = viewModel.currencies
    //            currencyPickerView.reloadAllComponents()
    //        }
    //        let selectedIndex = viewModel.selectedCurrency.flatMap { currencies?.firstIndex(of: $0) }
    //        if let index = selectedIndex, currencyPickerView.selectedRow(inComponent: 0) != index  {
    //            currencyPickerView.selectRow(index, inComponent: 0, animated: true)
    //        }
    //    }

    
}

//import UIKit
//import NVActivityIndicatorView
//
//class BagDetailsViewController: UIViewController, NVActivityIndicatorViewable {
//
//    @IBOutlet private var barcodeTextField: UITextField!
//    @IBOutlet private var amountTextField: UITextField!
//    @IBOutlet private var nextButton: UIButton!
//    @IBOutlet private var currencyTextField: UITextField!
//    @IBOutlet private var currencyPickerView: UIPickerView!
//    @IBOutlet private var currencyLoadingIndicator: UIActivityIndicatorView!
//
//    private lazy var keyboardAvoidanceConstraint = {
//        // Attention: doneButton should have Y position constraint priority set to @250 in elsewhere.
//        return nextButton.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
//    }()
//
//    private let presenter: IBagDetailsPresenter
//    private var currencies: [BagDetailsCurrencyViewModel]?
//
//    // MARK: -
//
//    init(presenter: IBagDetailsPresenter) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureTextFields()
//        configureKeyboardBehaviour()
//        presenter.viewDidLoad()
//    }
//
//    // MARK: - Actions
//
//    @IBAction private func didUpdateBarcode() {
//        presenter.didChangeBarcode(barcodeTextField.text ?? "")
//    }
//
//    @IBAction private func didUpdateAmount() {
//        let amout = amountTextField.text.flatMap(decimalValue)
//        presenter.didChangeAmount(amout)
//    }
//
//    @IBAction private func didTapCancelButton() {
//        presenter.didTapCancelButton()
//    }
//
//    @IBAction private func didTapNextButton() {
//        presenter.didTapNextButton()
//    }
//
//    @objc private func didTapContent() {
//        view.endEditing(true)
//    }
//
//    // MARK: - Private
//
//    private func configureTextFields() {
//        let barcodeStringAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont(name: "OpenSans-Light", size: 15) as Any,
//            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) as Any
//        ]
//        let amountStringAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont(name: "OpenSans-Light", size: 15) as Any,
//            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) as Any
//        ]
//        barcodeTextField.attributedPlaceholder = NSAttributedString(string: "REQUIRED", attributes: barcodeStringAttributes)
//        amountTextField.attributedPlaceholder = NSAttributedString(string: "REQUIRED", attributes: amountStringAttributes)
//        currencyTextField.inputView = currencyPickerView
//    }
//
//    private func configureKeyboardBehaviour() {
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapContent))
//        view.addGestureRecognizer(gesture)
//        keyboardAvoidanceConstraint.isActive = true
//    }
//
//    private func decimalValue(of string: String) -> Decimal? {
//        let formatter = DecimalNumberFormatter()
//        formatter.generatesDecimalNumbers = true
//        return formatter.number(from: string)?.decimalValue
//    }
//
//    private func stringValue(of number: Decimal) -> String? {
//        let formatter = DecimalNumberFormatter()
//        formatter.numberStyle = .decimal
//        return formatter.string(from: NSDecimalNumber(decimal: number))
//    }
//
//}
//
//extension BagDetailsViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == barcodeTextField {
//            amountTextField.becomeFirstResponder()
//            return false
//        }
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField === currencyTextField {
//            // Ensures that currency can be modified only programmatically.
//            return false
//        } else if textField === amountTextField {
//            let currentText = textField.text as NSString? ?? ""
//            let desiredText = currentText.replacingCharacters(in: range, with: string)
//            return desiredText.isEmpty ? true : decimalValue(of: desiredText) != nil
//        }
//        return true
//    }
//
//}
//
//extension BagDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return currencies?.count ?? 0
//    }
//
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        var attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont(name: "Roboto-Light", size: 15) as Any,
//            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) as Any
//        ]
//        if #available(iOS 13.0, *) {
//            attributes[.foregroundColor] = UIColor.label
//        }
//        guard let currencyCode = currencies?[row].currencyCode, let currencyDescription = Locale.current.localizedString(forCurrencyCode: currencyCode) else {
//            return nil
//        }
//        return NSAttributedString(string: currencyDescription, attributes: attributes)
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedCurrency = currencies?[row]
//        selectedCurrency?.action?()
//    }
//
//}
//
//extension BagDetailsViewController: IBagDetailsView {
//
//    func update(viewModel: BagDetailsViewModel) {
//        barcodeTextField.text = viewModel.barcode
//        if amountTextField.text.flatMap(decimalValue) != viewModel.amount {
//            amountTextField.text = viewModel.amount.flatMap(stringValue)
//        }
//        updateCurrencies(viewModel: viewModel)
//        nextButton.isEnabled = viewModel.isNextEnabled
//    }
//
//    func setLoading(_ isLoading: Bool) {
//        isLoading ? startAnimating(type: .circleStrokeSpin) : stopAnimating()
//    }
//
//    private func updateCurrencies(viewModel: BagDetailsViewModel) {
//        if viewModel.currencies == nil || viewModel.selectedCurrency == nil {
//            currencyTextField.endEditing(true)
//            currencyTextField.isHidden = true
//            currencyLoadingIndicator.startAnimating()
//        } else {
//            currencyTextField.isHidden = false
//            currencyLoadingIndicator.stopAnimating()
//        }
//        currencyTextField.text = viewModel.selectedCurrency?.currencyCode
//        if currencies != viewModel.currencies {
//            currencies = viewModel.currencies
//            currencyPickerView.reloadAllComponents()
//        }
//        let selectedIndex = viewModel.selectedCurrency.flatMap { currencies?.firstIndex(of: $0) }
//        if let index = selectedIndex, currencyPickerView.selectedRow(inComponent: 0) != index  {
//            currencyPickerView.selectRow(index, inComponent: 0, animated: true)
//        }
//    }
//
//}
