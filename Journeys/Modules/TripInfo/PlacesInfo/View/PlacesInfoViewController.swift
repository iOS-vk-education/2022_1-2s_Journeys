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
    private var placeholderView = UIView()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(mainCollectionView)
        placeholderView.isHidden = true
        
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
        mainCollectionView.register(CurrencyCell.self,
                                    forCellWithReuseIdentifier: "CurrencyCell")
        mainCollectionView.register(EventMapCell.self,
                                    forCellWithReuseIdentifier: "EventMapCell")
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
        CGSize(width: mainCollectionView.frame.width, height: 25)
    }
}

extension PlacesInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        output?.sectionsCount() ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = mainCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainCollectionHeader", for: indexPath) as? MainCollectionHeader {
            
            sectionHeader.configure(title: output.getHeaderText(for: indexPath))
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.mainCollectionCellsCount(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        guard let cellType = output?.mainCollectionCellType(for: indexPath) else { return cell }
        switch cellType {
        case .route:
            guard let routeCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ShortRouteCell",
                                                                         for: indexPath) as? ShortRouteCell else {
                return cell
            }
            guard let data = output.routeData() else {
                return cell
            }
            routeCell.configure(data: data)
            cell = routeCell
        case .weather:
            guard let weatherCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollection",
                                                                           for: indexPath) as? WeatherCollection else {
                return cell
            }
            guard let data = output.getWeatherCollectionDisplayData(indexPath.row) else {
                guard let noWeatherCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "NoPlacesForWeatherCell",
                                                                               for: indexPath) as? NoPlacesForWeatherCell else {
                    return cell
                }
                noWeatherCell.configure(text: "Нет погоды :(")
                return noWeatherCell
            }
            weatherCell.configure(data: data, delegate: self, indexPath: indexPath)
            cell = weatherCell
        case .currency:
            guard let currencyCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "CurrencyCell",
                                                                            for: indexPath) as? CurrencyCell else {
                return cell
            }
            currencyCell.configure(displayData: CurrencyCell.DisplayData(title: "Kursk-Anapa",
                                                                         course: 10,
                                                                         currentCurrencyName: "RUB",
                                                                         localCurrencyName: "USD"))
            cell = currencyCell
        case .events:
            guard let mapCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "EventMapCell",
                                                                            for: indexPath) as? EventMapCell else {
                return cell
            }
            mapCell.configure(data: EventMapCell.DisplayData(latitude: 55.755864,
                                                             longitude: 37.617698))
            cell = mapCell
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

extension PlacesInfoViewController: TransitionHandlerProtocol {
    func embedPlaceholder(_ viewController: UIViewController) {
        guard let placeholderViewController = viewController as? NoWeatherPlaceHolderViewController else { return }

        guard placeholderView.isHidden == true else {
            return
        }
        placeholderViewController
            .configure(with: NoWeatherPlaceHolderViewController.DisplayData(title: L10n.noTrips,
                                                                            imageName: "TripsPlaceholder"))
        addChild(placeholderViewController)
        placeholderViewController.didMove(toParent: self)
        placeholderView = placeholderViewController.view
        mainCollectionView.addSubview(placeholderView)
        placeholderView.isHidden = false
        placeholderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(100)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    func hidePlaceholder() {
        placeholderView.isHidden = true
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


private extension PlacesInfoViewController {
    enum Constants {
        static let contentBlocksSpacing: CGFloat = 30
        enum RouteView {
            static let horisontalSpacing: CGFloat = 20
        }
    }
}
