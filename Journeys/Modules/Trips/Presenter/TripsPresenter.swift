//
//  TripsPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit
import FirebaseAuth

// MARK: - TripsPresenter

final class TripsPresenter {
    // MARK: - Public Properties
    
    weak var view: TripsViewInput?
    weak var moduleOutput: TripsModuleOutput?

    // MARK: - Private Properties
    
    private let interactor: TripsInteractorInput
    private let router: TripsRouterInput
    
    private var dataIsLoaded: Bool = false
    private var tripsData: [TripWithRouteAndImage] = []
    
    private var cellToDeleteIndexPath: IndexPath?
    
    private(set) var tripsType: TripsType
    
    private var authFlag: Bool?
    
    //MARK: Lifecycle
    
    init(interactor: TripsInteractorInput,
         router: TripsRouterInput,
         tripsType: TripsType,
         tripsData: [TripWithRouteAndImage]? = nil) {
        self.interactor = interactor
        self.router = router
        self.tripsType = tripsType
        if let tripsData {
            self.tripsData = tripsData
        }
    }
    
    private func loadTripsData() {
        hidePlaceholder()
        dataIsLoaded = false
        tripsData = []
        interactor.obtainTripsDataFromSever(type: tripsType)
    }
    
    private func tripDisplayData(trip: TripWithRouteAndImage) -> TripCell.DisplayData? {
        let arrow = " → "
        
        var datesString: String?
        if let startDate = trip.route.places.first?.arrive,
           let endDate = trip.route.places.last?.depart {
            datesString = DateFormatter.dayAndMonth.string(from: startDate) + "-"
            + DateFormatter.dayAndMonth.string(from: endDate)
        }
        
        var routeString: String = ""
        routeString += trip.route.departureLocation.city
        for place in trip.route.places {
            routeString += arrow + place.location.city
        }
        
        let tripDisplayData = TripCell.DisplayData(picture: trip.image,
                                                   dates: datesString,
                                                   route: routeString,
                                                   isInFavourites: trip.isInfavourites)
        
        return tripDisplayData
    }
    
    private func showLoadingView() {
        view?.showLoadingView()
    }
    
    private func hideLoadingView() {
        view?.hideLoadingView()
    }
    
    private func embedRPlaceholder() {
        router.embedPlaceholder()
    }
    
    private func hidePlaceholder() {
        router.hidePlaceholder()
    }
    
    private func reloadView() {
        view?.reloadData()
        hideLoadingView()
        view?.endRefresh()
    }
    
    private func changeAuthFlag(to flag: Bool) {
        if authFlag == false, flag == true {
            refreshView()
        }
        authFlag = flag
    }
    
    private func authListener() {
        Auth.auth().addIDTokenDidChangeListener { [weak self] (auth, user) in
            guard let self else { return }
            if user == nil {
                self.changeAuthFlag(to: false)
            } else {
                self.changeAuthFlag(to: true)
            }
        }
    }
}



extension TripsPresenter: TripsModuleInput {
}

extension TripsPresenter: TripsViewOutput {
    func viewWillAppear() {
        authListener()
        dataIsLoaded = false
        switch tripsType {
        case .all: loadTripsData()
        case .saved:
            if tripsData.contains(where: { $0.image == nil }) {
                loadImagesForTrips()
            }
        }
    }
    
    func refreshView() {
        hidePlaceholder()
        view?.reloadData()
        loadTripsData()
    }
    
    func placeholderDisplayData() -> PlaceholderViewController.DisplayData {
        PlaceholderDisplayDataFactory().displayData()
    }
    
    func getCellData(for row: Int) -> TripCell.DisplayData? {
        guard tripsData.count > row else { return nil }
        let trip = tripsData[row]
        return tripDisplayData(trip: trip)
    }
    
    func getSectionsCount() -> Int {
        2
    }
    
    func getCellsCount(for section: Int) -> Int {
        if section == 0 {
            switch tripsType {
            case .all:
                return 1
            case .saved:
                return 0
            }
        }
        if dataIsLoaded || tripsType == .saved {
            if tripsData.count == 0 {
                embedRPlaceholder()
            }
            return tripsData.count
        }
        return 2
    }
    
    func getCellType() -> TripsCellType {
        if tripsType == .saved { return .usual }
        if dataIsLoaded { return .usual }
        return .skeleton
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard dataIsLoaded else {
            return
        }
        switch indexPath.section {
        case 0:
            moduleOutput?.tripsCollectionWantsToOpenNewRouteModule()
        default:
            guard tripsData.indices.contains(indexPath.row) else {
                didRecieveError(error: .obtainDataError)
                return
            }
            moduleOutput?.tripCollectionWantsToOpenTripInfoModule(trip: Trip(tripWithOtherData: tripsData[indexPath.row]),
                                                                 route: tripsData[indexPath.row].route)
        }
    }
    
    func didTapCellBookmarkButton(at indexPath: IndexPath) {
        guard tripsData.indices.contains(indexPath.row) else { return }
        tripsData[indexPath.row].isInfavourites.toggle()
        interactor.storeTripData(trip: Trip(tripWithOtherData: tripsData[indexPath.row])) { [weak self] in
            guard let self else { return }
            self.view?.changeIsSavedCellStatus(at: indexPath, status: self.tripsData[indexPath.row].isInfavourites)
            if self.tripsType == .saved {
                self.tripsData.remove(at: indexPath.row)
                self.view?.deleteItem(at: indexPath)
            }
        }
    }
    
    func didTapEditButton(at indexPath: IndexPath) {
        guard tripsData.indices.contains(indexPath.row) else {
            didRecieveError(error: .obtainDataError)
            return
        }
        moduleOutput?.tripsCollectionWantsToOpenExistingRoute(with: tripsData[indexPath.item])
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        guard tripsData.indices.contains(indexPath.row) else {
            didRecieveError(error: .deleteDataError)
            return
        }
        view?.showChoiceAlert(title: "Удалить маршрут",
                              message: "Вы уверены, что хотите удалиь маршрут?",
                              agreeActionTitle: "Да",
                              disagreeActionTitle: "Нет",
                              cellIndexPath: indexPath)
    }
    
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath) {
        guard tripsData.indices.contains(cellIndexPath.row) else {
            didRecieveError(error: .deleteDataError)
            return
        }
        cellToDeleteIndexPath = cellIndexPath
        interactor.deleteTrip(tripsData[cellIndexPath.row])
    }
    
    func didTapBackBarButton() {
        moduleOutput?.savedTripsModuleWantsToClose()
    }
    
    func didTapSavedBarButton() {
        let savedTrips = tripsData.filter { $0.isInfavourites }
        moduleOutput?.usualTripsModuleWantsToOpenSavedTrips(savedTrips: savedTrips)
    }
}

extension TripsPresenter: TripsInteractorOutput {
    func noTripsFetched() {
        dataIsLoaded = true
        tripsData = []
        reloadView()
        embedRPlaceholder()
    }
    
    func didFetchTripsData(trips: [TripWithRouteAndImage]) {
        dataIsLoaded = true
        tripsData = trips
        tripsData.sort(by: {$0.dateChanged.timeIntervalSinceNow > $1.dateChanged.timeIntervalSinceNow})
        
        reloadView()
        loadImagesForTrips()
    }
    
    func loadImagesForTrips() {
        for index in 0..<tripsData.count {
            interactor.loadImage(for: tripsData[index].route) { [weak self] image in
                guard let self else { return }
                guard self.tripsData.count > index else { return }
                self.tripsData[index].image = image
                self.view?.setupCellImage(at: IndexPath(row: index, section: 1), image: image)
            }
        }
    }
    
    func didDeleteTrip() {
        if let cellToDeleteIndexPath = cellToDeleteIndexPath {
            if tripsData.indices.contains(cellToDeleteIndexPath.row) {
                view?.deleteItem(at: cellToDeleteIndexPath)
                tripsData.remove(at: cellToDeleteIndexPath.row)
            }
        }
        cellToDeleteIndexPath = nil
    }
    
    func didRecieveError(error: Errors) {
        guard let alertShowingVC = view as? AlertShowingViewController else { return }
        
        switch error {
        case .obtainDataError:
            dataIsLoaded = true
            hideLoadingView()
            alertShowingVC.showDisappearingAlert(title: L10n.error, message: L10n.Alerts.Messages.errorWhileObtainingData)
            view?.endRefresh()
        case .saveDataError:
            alertShowingVC.showDisappearingAlert(title: L10n.error,
                                                 message: L10n.Alerts.Messages.errorWhileSavingData)
        case .deleteDataError:
            cellToDeleteIndexPath = nil
            alertShowingVC.showDisappearingAlert(title: L10n.error,
                                                 message: L10n.Alerts.Messages.errorWhileDeletingData)
        default:
            break
        }
    }
}
