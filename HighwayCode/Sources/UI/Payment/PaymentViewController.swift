//
//  PaymentViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 26.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import Foundation
import WebKit
import NVActivityIndicatorView

class PaymentViewController: UIViewController {

    @IBOutlet private var contentWebView: WKWebView!
    @IBOutlet private var activityIndicatorView: NVActivityIndicatorView!

    private let resolutionId: Int
    private let paymentsService: PaymentsService

    init(resolutionId: Int, paymentsService: PaymentsService) {
        self.resolutionId = resolutionId
        self.paymentsService = paymentsService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoadingIndicator()
        createOrder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentWebView.stopLoading()
    }

    // MARK: -

    private func setLoading(_ isLoading: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.contentWebView.alpha = isLoading ? 0.0 : 1.0
        }
        isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
    }

    private func configureLoadingIndicator() {
        activityIndicatorView.type = .circleStrokeSpin
    }

    // MARK: - Presentation Logic

    private func createOrder() {
        setLoading(true)
        paymentsService.createOrder(for: resolutionId, success: didCreateOrder, failure: didFailToCreateOrder)
    }

    private func didCreateOrder(_ order: PaymentOrder) {
        let request = createRequest(for: order)
        contentWebView.navigationDelegate = self
        contentWebView.load(request)
    }

    private func didFailToCreateOrder() {
        // TODO: Display sad message.
        setLoading(false)
    }

    private func createRequest(for order: PaymentOrder) -> URLRequest {
        var components = URLComponents(string: "https://liqpay.ua/api/3/checkout")
        components!.queryItems = [
            URLQueryItem(name: "data", value: order.payment.data),
            URLQueryItem(name: "signature", value: order.payment.signature)
        ]
        return URLRequest(url: components!.url!)
    }

}

extension PaymentViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setLoading(false)
    }

}
