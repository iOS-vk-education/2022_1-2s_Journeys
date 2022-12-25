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
        layout.sectionInset = UIEdgeInsets(top: 18, left: 0, bottom: 35, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        return collectionView
   }()

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

        mainCollectionView.register(ShortRouteCell.self,
                                    forCellWithReuseIdentifier: "ShortRouteCell")
        mainCollectionView.register(WeatherCollection.self,
                                    forCellWithReuseIdentifier: "WeatherCollection")
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
    }
}

extension PlacesInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: mainCollectionView.frame.width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("taptap")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: mainCollectionView.frame.width, height: 85)
        case 1:
            return CGSize(width: mainCollectionView.frame.width, height: 85)
        default:
            return CGSize(width: 0, height: 0)
        }
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
        output.getMainCollectionCellsCount(for: section)
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
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.mainCollectionView.reloadData()
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
        output.getWeatherCollectionCellsCount(for: collectionIndexPath.row)
    }
    
    func getCellDisplayData(at collectionIndexPath: IndexPath, for indexpath: IndexPath) -> WeatherCell.DisplayData? {
        output.getWeatherCollectionCellDisplayData(collectionRow: collectionIndexPath.row, cellRow: indexpath.row)
    }
}
