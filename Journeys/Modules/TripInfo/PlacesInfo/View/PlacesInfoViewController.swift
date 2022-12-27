//
//  PlacesIngoViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 14/12/2022.
//

import UIKit
import Foundation
import SnapKit

enum SectionType {
    case route
    case weather(String)
    case events
}

// MARK: - PlacesIngoViewController

final class PlacesInfoViewController: UIViewController {

    var output: PlacesInfoViewOutput!
    
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 18, left: 0, bottom: 35, right: 0)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        return collectionView
   }()
    
    private let loadingView = LoadingView()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(mainCollectionView)

        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self

        mainCollectionView.contentSize = CGSize(width: mainCollectionView.frame.width,
                                                height: mainCollectionView.frame.height)
        mainCollectionView.register(ShortRouteCell.self,
                                    forCellWithReuseIdentifier: "ShortRouteCell")
        mainCollectionView.register(WeatherCollection.self,
                                    forCellWithReuseIdentifier: "WeatherCollection")
        mainCollectionView.register(NoPlacesForWeatherCell.self,
                                    forCellWithReuseIdentifier: "NoPlacesForWeatherCell")
        mainCollectionView.register(MainCollectionHeader.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: "MainCollectionHeader")
    }
    
    
    private func setupConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        view.bringSubviewToFront(loadingView)
    }
}

extension PlacesInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: mainCollectionView.frame.width, height: 25)
    }
}

extension PlacesInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = mainCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainCollectionHeader", for: indexPath) as? MainCollectionHeader {
            
            sectionHeader.configure(title: output.getHeaderText(for: indexPath))
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.getMainCollectionCellsCount(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch indexPath.section {
        case 0:
            guard let routeCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ShortRouteCell",
                                                                     for: indexPath) as? ShortRouteCell else {
                return cell
            }
            guard let data = output.getRoutelData() else {
                return UICollectionViewCell()
            }
            routeCell.configure(data: data)
            cell = routeCell
        case 1:
            if output.isEmptyCellNeed() {
                guard let emptyCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "NoPlacesForWeatherCell",
                                                                         for: indexPath) as? NoPlacesForWeatherCell else {
                    return UICollectionViewCell()
                }
                emptyCell.configure(text: output.getEmptyCellData())
                return emptyCell
            }
            guard let weatherCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollection",
                                                                       for: indexPath) as? WeatherCollection else {
                return cell
            }
            guard let data = output.getWeatherCollectionDisplayData(indexPath.row) else {
                return UICollectionViewCell()
            }
            weatherCell.configure(data: data, delegate: self, indexPath: indexPath)
            cell = weatherCell
        default:
            return cell
        }
        return cell
    }
}

extension PlacesInfoViewController: PlacesInfoViewInput {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                              message: message,
                              preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.mainCollectionView.reloadData()
        }
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
}

private extension PlacesInfoViewController {
    enum Constants {
        static let contentBlocksSpacing: CGFloat = 30
        enum RouteView {
            static let horisontalSpacing: CGFloat = 20
        }
    }
}

extension PlacesInfoViewController: WeatherCollectionDelegate {
    func getNumberOfItemsInWeatherCollection(at collectionIndexPath: IndexPath) -> Int {
        output.getWeatherCollectionCellsCount(for: collectionIndexPath)
    }
    
    func getCellDisplayData(at collectionIndexPath: IndexPath, for indexpath: IndexPath) -> WeatherCell.DisplayData? {
        output.getWeatherCollectionCellDisplayData(collectionRow: collectionIndexPath.row, cellRow: indexpath.row)
    }
}
