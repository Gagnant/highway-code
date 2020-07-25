//
//  FineDetailsViewController.swift
//  HighwayCode
//
//  Created by Andrew Visotskyy on 24.07.2020.
//  Copyright © 2020 Gagnant. All rights reserved.
//

import UIKit
import MapKit

class FineDetailsViewController: UIViewController, IFineDetailsView {

    @IBOutlet private var rootScrollView: UIScrollView!
    @IBOutlet private var mediaContainerView: UIView!
    @IBOutlet private var mediaCollectionView: UICollectionView!
    @IBOutlet private var violationDateLabel: UILabel!
    @IBOutlet private var fineAmountLabel: UILabel!
    @IBOutlet private var reducedFineAmountLabel: UILabel!
    @IBOutlet private var paidStampImageView: UIImageView!
    @IBOutlet private var violationDetailsLabel: UILabel!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var paymentActionContainerView: UIView!
    @IBOutlet private var resolutionNumberLabel: UILabel!
    @IBOutlet private var resolutionDateLabel: UILabel!
    @IBOutlet private var vehiclePlateLabel: UILabel!

    private let presenter: IFineDetailsPresenter
    private var viewModel: FineDetailsViewModel?

    init(presenter: IFineDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefresh()
        configureNavigationItem()
        configureMediaCollectionView()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }

    // MARK: - FineDetailsViewController

    private lazy var currencyNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currencyAccounting
        numberFormatter.currencyCode = "UAH"
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy', 'HH':'ss"
        return dateFormatter
    }()

    func update(with viewModel: FineDetailsViewModel) {
        configureMap(location: viewModel.location)
        configureFineDetails(viewModel: viewModel)
        paymentActionContainerView.isHidden = viewModel.isPaymentApproved || viewModel.isPaid
        resolutionNumberLabel.text = viewModel.series + " " + viewModel.number
        resolutionDateLabel.text = dateFormatter.string(from: viewModel.resolutionDate)
        vehiclePlateLabel.text = viewModel.vehiclePlate
        self.viewModel = viewModel
        mediaCollectionView.reloadData()
    }

    func setLoading(_ isLoading: Bool) {
        isLoading ? rootScrollView.refreshControl?.beginRefreshing() : rootScrollView.refreshControl?.endRefreshing()
    }

    private func configureMap(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }

    private func configureFineDetails(viewModel: FineDetailsViewModel) {
        violationDateLabel.text = dateFormatter.string(from: viewModel.violationDate)
        violationDetailsLabel.text = viewModel.violationText
        paidStampImageView.isHidden = !viewModel.isPaymentApproved
        let strikethroughAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue, .strikethroughColor: #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1),
        ]
        fineAmountLabel.attributedText = NSAttributedString(
            string: currencyNumberFormatter.string(from: viewModel.amount as NSNumber) ?? "",
            attributes: strikethroughAttributes
        )
        fineAmountLabel.isHidden = viewModel.amount == viewModel.payAmount
        reducedFineAmountLabel.text = currencyNumberFormatter.string(from: viewModel.payAmount as NSNumber)
    }

    // MARK: - Private

    @IBAction private func didTapPayButton() {
        presenter.didTapPay()
    }

    @objc private func didTriggerRefresh() {
        presenter.didTapUpdate()
    }

    // MARK: -

    private func configureRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didTriggerRefresh), for: .valueChanged)
        rootScrollView.refreshControl = refreshControl
    }

    private func configureNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = NSLocalizedString("fine-details-navigation-title", comment: "")
    }

    private func configureMediaCollectionView() {
        mediaCollectionView.register(
            FineDetailsImageMediaCollectionCell.nib,
            forCellWithReuseIdentifier: FineDetailsImageMediaCollectionCell.reuseIdentifier
        )
        mediaCollectionView.register(
            FineDetailsVideoMediaCollectionCell.nib,
            forCellWithReuseIdentifier: FineDetailsVideoMediaCollectionCell.reuseIdentifier
        )
        mediaCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }

}

extension FineDetailsViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemHeight = collectionView.bounds.inset(by: collectionView.adjustedContentInset).height
        return CGSize(width: itemHeight, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.media.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemViewModel = self.viewModel?.media[indexPath.row] else {
            NSLog("Inconsistent controller state.")
            return UICollectionViewCell()
        }
        if itemViewModel.type == .image {
            return dequeueImageMediaCell(item: itemViewModel, indexPath: indexPath)
        }
        return dequeueVideoMediaCell(item: itemViewModel, indexPath: indexPath)
    }

    private func dequeueVideoMediaCell(item: FineDetailsViewModel.Media, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mediaCollectionView.dequeueReusableCell(
            withReuseIdentifier: FineDetailsVideoMediaCollectionCell.reuseIdentifier, for: indexPath
        ) as! FineDetailsVideoMediaCollectionCell
        cell.configure(viewModel: item)
        return cell
    }

    private func dequeueImageMediaCell(item: FineDetailsViewModel.Media, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mediaCollectionView.dequeueReusableCell(
            withReuseIdentifier: FineDetailsImageMediaCollectionCell.reuseIdentifier, for: indexPath
        ) as! FineDetailsImageMediaCollectionCell
        cell.configure(viewModel: item)
        return cell
    }

}
