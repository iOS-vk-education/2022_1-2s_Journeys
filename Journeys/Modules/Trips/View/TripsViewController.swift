//
//  TripsViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsViewController

enum TripsCellType {
    case skeleton
    case usual
}

final class TripsViewController: UIViewController {

    // MARK: Private properties
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       return UICollectionView(frame: .zero, collectionViewLayout: layout)
   }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let loadingView = LoadingView()
    private var placeholderView = UIView()
    
    private lazy var cellsType: TripsCellType = {
        output.getCellType()
    }()

    // MARK: Public properties
    var output: TripsViewOutput!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewWillAppear()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        placeholderView.isHidden = true
        setupNavBar()
        setupCollectionView()
        makeConstraints()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        output.viewWillAppear()
//    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        navigationItem.setHidesBackButton(true, animated: false)

        switch output.tripsType {
        case .all:
            let buttonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapFavouritesButton))
            
            navigationItem.rightBarButtonItem = buttonItem
            title = L10n.trips
        case .saved:
            let buttonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBackButton))
            
            navigationItem.leftBarButtonItem = buttonItem
            title = L10n.saved
        }
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.alwaysBounceVertical = true

        collectionView.register(AddTripCell.self,
                                forCellWithReuseIdentifier: "AddTripCell")
        collectionView.register(TripCell.self,
                                forCellWithReuseIdentifier: "TripCell")
        collectionView.register(SkeletonTripCell.self,
                                forCellWithReuseIdentifier: "SkeletonTripCell")
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        view.bringSubviewToFront(loadingView)
    }

    @objc
    private func refresh() {
        output.refreshView()
    }
    
    @objc
    private func didTapBackButton() {
        output.didTapBackBarButton()
    }

    @objc
    private func didTapFavouritesButton() {
        output.didTapSavedBarButton()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TripsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return Constants.addCellSize
        } else {
            return Constants.tripCellSize
        }
    }
}

extension TripsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        output.didSelectCell(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch output.tripsType {
        case .all:
            if section == 0 {
                return UIEdgeInsets(top: 30, left: 0, bottom: 8, right: 0)
            } else {
                return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            }
        case .saved:
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
            } else {
                return UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            cell.alpha = 0
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    cell.alpha = 1
                })
        }
    }
    
}

extension TripsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        output.getCellsCount(for: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.section == 0 {
            guard let addCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AddTripCell",
                for: indexPath
            ) as? AddTripCell else {
                return cell
            }
            return addCell
        }
        switch cellsType {
        case .skeleton:
            guard let skeletonCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SkeletonTripCell",
                for: indexPath
            ) as? SkeletonTripCell else {
                return cell
            }
            cell = skeletonCell
        case .usual:
            guard let tripCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TripCell",
                for: indexPath
            ) as? TripCell else {
                return cell
            }
            
            guard let data = output.getCellData(for: indexPath.row) else {
                return tripCell
            }
            tripCell.configure(data: data,
                               delegate: self, indexPath: indexPath)
            cell = tripCell
        default:
            break
        }
        return cell
    }
}

extension TripsViewController: TripsViewInput {
    func endRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        present(alert, animated: true)
    }
    
    func showChoiceAlert(title: String,
                         message: String,
                         agreeActionTitle: String,
                         disagreeActionTitle: String,
                         cellIndexPath: IndexPath) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: agreeActionTitle, style: .default) { _ in
            self.output.didSelectAgreeAlertAction(cellIndexPath: cellIndexPath)
        })
        alert.addAction(UIAlertAction(title: disagreeActionTitle, style: .default))
        present(alert, animated: true)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.cellsType = self.output.getCellType()
            self.collectionView.reloadData()
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        collectionView.deleteItems(at: [indexPath])
    }
    
    func moveCell(from: IndexPath, to: IndexPath) {
//        guard let tripCell = collectionView.cellForItem(at: from) as? TripCell else { return }
        collectionView.moveItem(at: from, to: to)
//        tripCell.changeIndexPath(to: to)
    }
    
    func showLoadingView() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        view.bringSubviewToFront(loadingView)
    }
    
    func hideLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.removeFromSuperview()
        }
    }
    
    func changeIsSavedCellStatus(at indexPath: IndexPath, status: Bool) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TripCell else { return }
        cell.changeIsSavedStatus(status: status)
    }

    func setupCellImage(at indexPath: IndexPath, image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? TripCell else { return }
            cell.setupImage(image)
        }
    }
}

extension TripsViewController: TransitionHandlerProtocol {
    func embedPlaceholder(_ viewController: UIViewController) {
        guard let placeholderViewController = viewController as? PlaceholderViewController else { return }

        guard placeholderView.isHidden == true else {
            return
        }
        placeholderViewController
            .configure(with: PlaceholderViewController.DisplayData(title: L10n.noTrips,
                                                                   imageName: "TripsPlaceholder"))
        addChild(placeholderViewController)
        placeholderViewController.didMove(toParent: self)
        placeholderView = placeholderViewController.view
        collectionView.addSubview(placeholderView)
        placeholderView.isHidden = false
        placeholderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    func showPlaceholder() {
        placeholderView.isHidden = false
    }
    
    func hidePlaceholder() {
        placeholderView.isHidden = true
    }
}

extension TripsViewController: TripCellDelegate {
    func didTapEditButton(_ indexPath: IndexPath) {
        output.didTapEditButton(at: indexPath)
    }
    
    func didTapDeleteButton(_ indexPath: IndexPath) {
        output.didTapDeleteButton(at: indexPath)
    }
    
    func didTapBookmarkButton(_ indexPath: IndexPath) {
        output.didTapCellBookmarkButton(at: indexPath)
    }
}


// MARK: Constants
private extension TripsViewController {

    enum Constants {
        static let addCellSize = CGSize(width: 343, height: 72)
        static let tripCellSize = CGSize(width: 343, height: 272)
    }
}
