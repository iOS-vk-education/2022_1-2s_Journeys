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

    var output: PlacesInfoViewOutput?
    
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
        output?.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(mainCollectionView)
        placeholderView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
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
        mainCollectionView.register(PlacesInfoPlaceholderCell.self,
                                    forCellWithReuseIdentifier: "PlacesInfoPlaceholderCell")
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PlacesInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 25)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellType = output?.mainCollectionCellType(for: indexPath)
        else { return CGSize(width: 0.0, height: 0.0) }
        let width = collectionView.bounds.width - 40
        switch cellType {
        case .route, .weather:
            return CGSize(width: collectionViewLayout.collectionViewContentSize.width,
                          height: collectionViewLayout.collectionViewContentSize.height)
        case .currency:
            return CGSize(width: width,
                          height: 70)
        case .events:
            return CGSize(width: width,
                          height: width * 2/3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.didSelectItem(at: indexPath)
    }
}

extension PlacesInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        output?.sectionsCount() ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = mainCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainCollectionHeader", for: indexPath) as? MainCollectionHeader {
            
            sectionHeader.configure(title: output?.headerText(for: indexPath) ?? "")
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        output?.mainCollectionCellsCount(for: section) ?? 0
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
            guard let data = output?.routeCellDisplayData()
            else { return placeHolderCell(for: indexPath, cellType: .route) }
            
            routeCell.configure(data: data)
            cell = routeCell
        case .weather:
            guard let weatherCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollection",
                                                                           for: indexPath) as? WeatherCollection else {
                return cell
            }
            guard let data = output?.weatherCollectionDisplayData(indexPath.row)
            else { return placeHolderCell(for: indexPath, cellType: .weather) }
            
            weatherCell.configure(data: data, delegate: self, indexPath: indexPath)
            cell = weatherCell
        case .currency:
            guard let currencyCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "CurrencyCell",
                                                                            for: indexPath) as? CurrencyCell else {
                return cell
            }
            
            guard let displatData = output?.currencyCellDisplayData(for: indexPath)
            else { return placeHolderCell(for: indexPath, cellType: .currency) }
            
            let cellDelegate = output as? CurrencyCellDelegate
            currencyCell.configure(displayData: displatData,
                                   delegate: cellDelegate,
                                   indexPath: indexPath)
            cell = currencyCell
        case .events:
            guard let mapCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "EventMapCell",
                                                                       for: indexPath) as? EventMapCell else {
                return cell
            }
            guard let displayData = output?.eventCellDisplayData(for: indexPath)
            else { return placeHolderCell(for: indexPath, cellType: .events) }
            
            mapCell.configure(data: displayData)
            cell = mapCell
        default:
            return cell
        }
        return cell
    }
    
    func placeHolderCell(for indexPath: IndexPath,
                         cellType: PlacesInfoPresenter.CellType) -> UICollectionViewCell {
        guard let placeholderCell =
                mainCollectionView.dequeueReusableCell(withReuseIdentifier: "PlacesInfoPlaceholderCell",
                                                       for: indexPath) as? PlacesInfoPlaceholderCell
        else { return UICollectionViewCell() }
        
        var cellText: String = ""
        switch cellType {
        case .route: cellText = "Не получилось построить маршрут :("
        case .weather: cellText = "Нет информации по погоде :("
        case .currency: cellText = "Нет информации по валютам :("
        case .events: cellText = "Нет информации по мероприятиям :("
        }
        placeholderCell.configure(text: cellText)
        return placeholderCell
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
    
    func changeCurrencyTextField(at indexPath: IndexPath, viewType: CurrencyView.ViewType, to text: String) {
        guard let cell = mainCollectionView.cellForItem(at: indexPath) as? CurrencyCell else { return }
        cell.setTextFieldText(to: text, viewType: viewType)
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
        output?.weatherCollectionCellsCount(for: collectionIndexPath) ?? 0
    }
    
    func getCellDisplayData(at collectionIndexPath: IndexPath, for indexpath: IndexPath) -> WeatherCell.DisplayData? {
        output?.weatherCollectionCellDisplayData(collectionRow: collectionIndexPath.row,
                                                cellRow: indexpath.row)
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
