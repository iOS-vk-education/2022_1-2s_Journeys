//
//  TripsPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit

// MARK: - TripsPresenter

final class TripsPresenter {
    // MARK: - Public Properties

    weak var view: TripsViewInput!
    weak var moduleOutput: TripsModuleOutput!

    // MARK: - Private Properties

    private let interactor: TripsInteractorInput
    private let router: TripsRouterInput
    
    private var tripsData: [TripWithRouteAndImage] = []
    
    private var cellToDeleteIndexPath: IndexPath?
    
    private var tripsViewControllerType: TripsViewController.ScreenType

    //MARK: Lifecycle

    init(interactor: TripsInteractorInput,
         router: TripsRouterInput,
         tripsViewControllerType: TripsViewController.ScreenType) {
        self.interactor = interactor
        self.router = router
        self.tripsViewControllerType = tripsViewControllerType
    }
    
    private func loadTripsData() {
        switch tripsViewControllerType {
        case .usual:
            interactor.obtainTripsDataFromSever()
        case .saved :
            interactor.obtainSavedTripsDataFromServer()
        }
    }
    
    private func tripDisplayData(trip: TripWithRouteAndImage) -> TripCell.DisplayData? {
        let arrow = "→"
        
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
    
    private func sortTrips() {
        tripsData.sort(by: {$0.dateChanged.timeIntervalSinceNow > $1.dateChanged.timeIntervalSinceNow})
    }
}



extension TripsPresenter: TripsModuleInput {
}

extension TripsPresenter: TripsViewOutput {
    func viewDidAppear() {
        loadTripsData()
    }
    
    func getScreenType() -> TripsViewController.ScreenType {
        tripsViewControllerType
    }
    
    func getCellData(for row: Int) -> TripCell.DisplayData? {
        print(row)
        print(tripsData.count)
        guard tripsData.indices.contains(row) else { return nil }
        let trip = tripsData[row]
        return tripDisplayData(trip: trip)
    }
    
    func getSectionsCount() -> Int {
        2
    }
    
    func getCellsCount(for section: Int) -> Int {
        if section == 0 {
            switch tripsViewControllerType {
            case .usual:
                return 1
            case .saved:
                return 0
            }
        }
        return tripsData.count
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            moduleOutput.tripsCollectionWantsToOpenNewRouteModule()
        default:
            guard tripsData.indices.contains(indexPath.row) else {
                view.showAlert(title: "Ошибка",
                               message: "Возникла ошибка при открытии данных маршрута",
                               actionTitle: "Ок")
                return
            }
            moduleOutput.tripsCollectionWantsToOpenExistingRoute(with: Trip(tripWithOtherData: tripsData[indexPath.item]))
        }
    }
    
    func didTapCellBookmarkButton(at indexPath: IndexPath) {
        guard tripsData.indices.contains(indexPath.row) else { return }
        tripsData[indexPath.row].isInfavourites.toggle()
        interactor.storeTripData(trip: Trip(tripWithOtherData: tripsData[indexPath.row]))
    }
    
    func didTapEditButton(at indexPath: IndexPath) {
        guard tripsData.indices.contains(indexPath.row) else {
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при попытке отредактировать данные маршрута",
                           actionTitle: "Ок")
            return
        }
        moduleOutput.tripsCollectionWantsToOpenExistingRoute(with: Trip(tripWithOtherData: tripsData[indexPath.item]))
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        guard tripsData.indices.contains(indexPath.row) else {
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных маршрута",
                           actionTitle: "Ок")
            return
        }
        view.showChoiceAlert(title: "Удалить маршрут", message: "Вы уверены, что хотите удалиь маршрут?", agreeActionTitle: "Да", disagreeActionTitle: "Нет", cellIndexPath: indexPath)
    }
    
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath) {
        guard tripsData.indices.contains(cellIndexPath.row) else {
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных маршрута",
                           actionTitle: "Ок")
            return
        }
        cellToDeleteIndexPath = cellIndexPath
        interactor.deleteTrip(Trip(tripWithOtherData: tripsData[cellIndexPath.row]))
    }
    
    func didTapBackBarButton() {
        moduleOutput.savedTripsModuleWantsToClose()
    }
    
    func didTapSavedBarButton() {
        moduleOutput.usualTripsModuleWantsToOpenSavedTrips()
    }
}

extension TripsPresenter: TripsInteractorOutput {
    func didFetchTripsData(data: [Trip]) {
        var trips: [TripWithRouteAndImage] = []
        var count = data.count
        for trip in data {
            interactor.obtainRouteDataFromSever(with: trip.routeId) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .failure(let error):
                    count -= 1
                    strongSelf.didRecieveError(error: .obtainDataError)
                case .success(let route):
                    count -= 1
                    strongSelf.didFetchRouteData(route: route) { image in
                        trips.append(TripWithRouteAndImage(trip: trip,
                                                           image: image,
                                                           route: route))
                        if count == 0 {
                            strongSelf.didFinishObtainingData(trips: trips)
                        }
                    }
                }
            }
        }
    }
    
    func didFetchRouteData(route: Route, completion: @escaping (UIImage) -> Void) {
        guard let imageURL = route.imageURLString else { return }
        guard !imageURL.isEmpty else { return }
        interactor.obtainTripImageFromServer(withURL: imageURL) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.didRecieveError(error: .obtainDataError)
            case .success(let image):
                completion(image)
            }
        }
        
    }
    
    func didFinishObtainingData(trips: [TripWithRouteAndImage]) {
        self.tripsData = trips
        self.sortTrips()
        self.view.reloadData()
        self.view.endRefresh()
    }
    
    func didDeleteTrip() {
        if let cellToDeleteIndexPath = cellToDeleteIndexPath {
            if tripsData.indices.contains(cellToDeleteIndexPath.row) {
                view.deleteItem(at: cellToDeleteIndexPath)
                tripsData.remove(at: cellToDeleteIndexPath.row)
            }
        }
        cellToDeleteIndexPath = nil
    }
    
    func didRecieveError(error: Errors) {
        switch error {
        case .obtainDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при получении данных",
                           actionTitle: "Ок")
        case .saveDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при сохранении данных. Проверьте корректность данных и поробуйте снова",
                           actionTitle: "Ок")
        case .deleteDataError:
            cellToDeleteIndexPath = nil
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных",
                           actionTitle: "Ок")
        }
    }
}
