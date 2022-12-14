//
//  TripsViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsViewController

final class TripsViewController: UIViewController {

    // MARK: Private properties
    private var floatingChangeButton = FloatingButton()

    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       return UICollectionView(frame: .zero, collectionViewLayout: layout)
   }()

    // MARK: Public properties
    var output: TripsViewOutput!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        setupCollectionView()
        setupFloatingAddButton()
        makeConstraints()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)

        let settingsButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapSettingsButton))

        let favouritesButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(didTapFavouritesButton))

        navigationItem.leftBarButtonItem = settingsButtonItem
        navigationItem.rightBarButtonItem = favouritesButtonItem
        title = L10n.trips
    }

    private func setupFloatingAddButton() {
        view.addSubview(floatingChangeButton)
        view.bringSubviewToFront(floatingChangeButton)
        floatingChangeButton.configure(title: L10n.edit)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.contentInset = TripsConstants.collectionInset

        collectionView.register(AddTripCell.self,
                                forCellWithReuseIdentifier: "AddTripCell")
        collectionView.register(TripCell.self,
                                forCellWithReuseIdentifier: "TripCell")
    }

    private func makeConstraints() {
        floatingChangeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(TripsConstants.FloationgChangeButton.bottomIndent)
            make.width.equalTo(TripsConstants.FloationgChangeButton.width)
            make.height.equalTo(TripsConstants.FloationgChangeButton.height)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    @objc
    private func didTapSettingsButton() {
        print("Settings button was tapped")
    }

    @objc
    private func didTapFavouritesButton() {
        print("Favourites button was tapped")
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension TripsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return TripsConstants.addCellSize
        } else {
            return TripsConstants.tripCellSize
        }
    }
}

extension TripsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 30, left: 0, bottom: 8, right: 0)
        } else {
            return UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        }
    }
}

extension TripsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        // TODO: use output
        } else {
            return 1
        }
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
            // TODO: use output
            tripCell.configure(data: TripCellDisplayData(picture: UIImage(asset: Asset.Assets.tripCellImage),
                                                         dates: "22.01.22-22.02.22",
                                                         route: "hahaha",
                                                         isInFavourites: false),
                               delegate: self)
            cell = tripCell
        }
        return cell
    }
}

extension TripsViewController: TripsViewInput {
}

extension TripsViewController: TripCellDelegate {
    // TODO: send data to presenter
    func didTapBookmarkButton() {
        return
    }
}

// MARK: Constants
private extension TripsViewController {

    struct TripsConstants {
        static let addCellSize = CGSize(width: 343, height: 72)
        static let tripCellSize = CGSize(width: 343, height: 272)

        static let collectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        struct FloationgChangeButton {
            static let width: CGFloat = 220.0
            static let height: CGFloat = 40.0
            static let borderRarius: CGFloat = 10.0
            static let bottomIndent: CGFloat = 15.0
        }
    }
}
