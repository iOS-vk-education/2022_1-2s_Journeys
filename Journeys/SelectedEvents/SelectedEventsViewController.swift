//
//  SelectedEventsViewController.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

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
        segmentControl.isHidden = true
        segmentControl.backgroundColor = UIColor(asset: Asset.Colors.BaseColors.similarToThemeColor)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var collectionViewFavorites: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var placeHolder1: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока пусто :("
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private lazy var placeHolder2: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока пусто :("
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private lazy var collectionViewCreated: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        view.addSubview(segmentControl)
        collectionViewCreated.isHidden = true
        segmentControl.selectedSegmentIndex = 0
        setupCollectionView(collectionView: collectionViewFavorites)
        segmentControl.frame = CGRect(x: 50.0, y: 55.0, width: view.bounds.width, height: 0)
        collectionViewCreated.addSubview(placeHolder2)
        collectionViewFavorites.addSubview(placeHolder1)
        makeConstraints()
        setupTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        output?.didLoadView()
        super.viewWillAppear(animated)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)
        let exitButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapExitButton))

        navigationItem.leftBarButtonItem = exitButtonItem
        title = L10n.favorites
    }
    
    private func setupCollectionView(collectionView: UICollectionView) {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(asset: Asset.Colors.Background.dimColor)
        collectionView.register(FavoriteEventCell.self, forCellWithReuseIdentifier: "FavoriteEventCell")
        makeConstanceCollectionView(collectionView: collectionView)
    }

    private func makeConstraints() {
        placeHolder1.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }

    private func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func obtainFavorites() {
        collectionViewFavorites.reloadData()
    }
    
    func obtainCreated() {
        collectionViewCreated.reloadData()
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
            self.output?.didSelectAgreeAlertAction(cellIndexPath: cellIndexPath)
        })
        alert.addAction(UIAlertAction(title: disagreeActionTitle, style: .default))
        present(alert, animated: true)
    }
    
    private func makeConstanceCollectionView(collectionView: UICollectionView) {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl).inset(40)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    @objc
    func switchValueDidChange(sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            title = L10n.favorites
            setupCollectionView(collectionView: collectionViewFavorites)
            output?.didswitshOnFavoretes()
            collectionViewCreated.isHidden = true
            collectionViewFavorites.isHidden = false
        case 1:
            title = L10n.created
            setupCollectionView(collectionView: collectionViewCreated)
            output?.didSwitshOnCreated()
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
    
    @objc
    private func didTapScreen() {
        output?.didTapScreen()
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

extension SelectedEventsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if let countOfSection = output?.countOfFavorites() {
                if countOfSection == 0 {
                    placeHolder1.isHidden = false
                } else {
                    placeHolder1.isHidden = true
                }
            } else {
                placeHolder1.isHidden = false
            }
            return output?.countOfFavorites() ?? 0
        case 1:
            if let countOfSection = output?.countOfFavorites() {
                if countOfSection == 0 {
                    placeHolder2.isHidden = false
                } else {
                    placeHolder2.isHidden = true
                }
            } else {
                placeHolder2.isHidden = false
            }
            return output?.countOfCreated() ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            var cell = UICollectionViewCell()
            guard let eventCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FavoriteEventCell",
                for: indexPath
            ) as? FavoriteEventCell else {
                return cell
            }
            
            guard let data = output?.displayingCreatedEvent(for: indexPath.section, cellType: .favoretes) else {
                return UICollectionViewCell()
            }
            eventCell.configure(data: data, delegate: self, indexPath: indexPath)
            cell = eventCell
            return cell
        case 1:
            var cell = UICollectionViewCell()
            guard let eventCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FavoriteEventCell",
                for: indexPath
            ) as? FavoriteEventCell else {
                return cell
            }
            
            guard let data = output?.displayingCreatedEvent(for: indexPath.section, cellType: .created) else {
                return UICollectionViewCell()
            }
            eventCell.configure(data: data, delegate: self, indexPath: indexPath)
            cell = eventCell
            return cell
        default:
            var cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            output?.didTapFavoriteCell(at: indexPath)
        case 1:
            output?.didTapCreatedCell(at: indexPath)
            
        default:
            return
        }
    }

}

extension SelectedEventsViewController: SelectedEventsViewInput {
    
    func setupFavoriteCellImage(at indexPath: IndexPath, image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let cell = self.collectionViewFavorites.cellForItem(at: indexPath) as? FavoriteEventCell else { return }
            cell.setupImageFav(image)
        }
    }
    
    func setupCreatedCellImage(at indexPath: IndexPath, image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let cell = self.collectionViewCreated.cellForItem(at: indexPath) as? FavoriteEventCell else { return }
            cell.setupImageCre(image)
        }
    }
    
    func reloadImage() {
        collectionViewCreated.reloadData()
    }
    
    func show(error: Error) {
        let alertViewController = UIAlertController(title: L10n.error, message: error.localizedDescription, preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alertViewController, animated: true)
    }
    
    func reloadFavorites() {
        self.obtainFavorites()
    }
    
    func reloadCreated() {
        self.obtainCreated()
    }
    
}

extension SelectedEventsViewController: FavoriteEventCellDelegate {
    func didTapLikeButton(_ indexPath: IndexPath) {
        output?.didTapLikeButton(at: indexPath)
    }

    func didTapEditButton(_ indexPath: IndexPath) {
        output?.didTapEditingButton(at: indexPath)
    }

    func didTapDeleteButton(_ indexPath: IndexPath) {
        output?.didTapDeleteButton(at: indexPath)
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
