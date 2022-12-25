//
//  TripsViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsViewController

final class TripsViewController: UIViewController {
    
    enum ScreenType {
        case usual
        case saved
    }

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

    // MARK: Public properties
    var output: TripsViewOutput!
    var tripsViewControllerType: ScreenType?

    // MARK: Lifecycle
    override func viewDidLoad() {
        output.viewDidAppear()
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        tabBarController?.tabBar.items?.forEach { $0.isEnabled = true }
        setupNavBar()
        setupCollectionView()
        makeConstraints()
    }
    

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        navigationItem.setHidesBackButton(true, animated: false)

        switch output.getScreenType() {
        case .usual:
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
            title = "Избранное"
        }
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.alwaysBounceVertical = true

        collectionView.register(AddTripCell.self,
                                forCellWithReuseIdentifier: "AddTripCell")
        collectionView.register(TripCell.self,
                                forCellWithReuseIdentifier: "TripCell")
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    @objc
    private func refresh() {
        output.viewDidAppear()
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
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        switch output.getScreenType() {
        case .usual:
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
            cell = addCell
        } else {
            guard let tripCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "TripCell",
                for: indexPath
            ) as? TripCell else {
                return cell
            }
            
            guard let data = output.getCellData(for: indexPath.row) else {
                return UICollectionViewCell()
            }
            tripCell.configure(data: data,
                               delegate: self, indexPath: indexPath)
            cell = tripCell
        }
        return cell
    }
}

extension TripsViewController: TripsViewInput {
    func endRefresh() {
        refreshControl.endRefreshing()
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
            self?.collectionView.reloadData()
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        self.collectionView.deleteItems(at: [indexPath])
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
