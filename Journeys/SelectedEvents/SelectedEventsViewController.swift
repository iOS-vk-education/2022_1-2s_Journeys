//
//  SelectedEventsViewController.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation
import UIKit

final class SelectedEventsViewController: UIViewController {
    var output: SelectedEventsViewOutput?
    
    lazy var segmentControl:  UISegmentedControl =  {
        let segmentControl = UISegmentedControl(items: [L10n.favorites, L10n.created])
        segmentControl.layer.cornerRadius = 10
        segmentControl.backgroundColor = UIColor(asset: Asset.Colors.BaseColors.similarToThemeColor)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var collectionViewFavorites: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var collectionViewCreated: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        let exitButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapExitButton))

        navigationItem.leftBarButtonItem = exitButtonItem
        title = L10n.favorites
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        view.addSubview(segmentControl)
        setupCollectionView(collectionView: collectionViewFavorites)
        segmentControl.frame = CGRect(x: 50.0, y: 70.0, width: view.bounds.width, height: 30.0)
        makeConstraints()
    }
    
    private func setupCollectionView(collectionView: UICollectionView) {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.contentInset = SelectedEventsConstants.collectionInset
        collectionView.register(FavoriteEventCell.self, forCellWithReuseIdentifier: "FavoriteEventCell")
        makeConstanceCollectionView(collectionView: collectionView)
    }
    
    @objc
    func switchValueDidChange(sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            title = L10n.favorites
            collectionViewCreated.isHidden = true
            collectionViewFavorites.isHidden = false
        case 1:
            title = L10n.created
            setupCollectionView(collectionView: collectionViewCreated)
            collectionViewFavorites.isHidden = true
            collectionViewCreated.isHidden = false
        default:
            break
        }
    }
    
    @objc
    func didTapExitButton() {
        output?.didTapCloseButton()
    }
    
    private func makeConstraints() {
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func makeConstanceCollectionView(collectionView: UICollectionView) {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl).inset(40)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

extension SelectedEventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SelectedEventsConstants.photoCellSize
    }
}

extension SelectedEventsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
    }
}

extension SelectedEventsViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            var cell = UICollectionViewCell()
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FavoriteEventCell",
                for: indexPath
            ) as? FavoriteEventCell else {
                return cell
            }
            placemarkCell.configure(data: FavoriteEventCell.DisplayData(picture: UIImage(asset: Asset.Assets.TripCell.tripCellImage2)!,
                                                                        startDate: "22.05.2023   03:58",
                                                                        endDate: "22.05.2023   03:58",
                                                                        name: "Читательский клуб",
                                                                        address: "Милицейская, 11",
                                                                        isInFavourites: true,
                                                                        cellType: .favoretes), delegate: self, indexPath: indexPath)
            cell = placemarkCell
            return cell
        case 1:
            var cell = UICollectionViewCell()
            guard let placemarkCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FavoriteEventCell",
                for: indexPath
            ) as? FavoriteEventCell else {
                return cell
            }
            placemarkCell.configure(data: FavoriteEventCell.DisplayData(picture: UIImage(asset: Asset.Assets.TripCell.tripCellImage2)!,
                                                                        startDate: "22.05.2023   03:58",
                                                                        endDate: "22.05.2023   03:58",
                                                                        name: "Читательский клуб",
                                                                        address: "Милицейская, 11",
                                                                        isInFavourites: true,
                                                                        cellType: .created), delegate: self, indexPath: indexPath)
            cell = placemarkCell
            return cell
        default:
            var cell = UICollectionViewCell()
            return cell
        }
    }
}

extension SelectedEventsViewController: SelectedEventsViewInput {
}

extension SelectedEventsViewController: FavoriteEventCellDelegate {
    func didTapLikeButton(_ indexPath: IndexPath) {
        
    }
    
    func didTapEditButton(_ indexPath: IndexPath) {
        
    }
    
    func didTapDeleteButton(_ indexPath: IndexPath) {
        
    }
    
}

private extension SelectedEventsViewController {

    struct SelectedEventsConstants {
        static let addCellSize = CGSize(width: 343, height: 66)
        static let photoCellSize = CGSize(width: 343, height: 157)
        static let tripCellSize = CGSize(width: 343, height: 55)
        static let miniCellSize = CGSize(width: 165, height: 50)
        

        static let collectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        static let numberOfSection = 10
    }
}
