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

    weak var view: TripsViewInput?
    weak var moduleOutput: TripsModuleOutput!

    // MARK: - Private Properties

    private let interactor: TripsInteractorInput
    private let router: TripsRouterInput
    
    private var dataIsLoaded: Bool = false
    private var tripsData: [TripWithRouteAndImage] = []
    
    private var cellToDeleteIndexPath: IndexPath?
    
    private var tripsType: TripsType
    
    private let dataLoadQueue = DispatchQueue.global()
    private let dataLoadDispatchGroup = DispatchGroup()

    //MARK: Lifecycle

    init(interactor: TripsInteractorInput,
         router: TripsRouterInput,
         tripsType: TripsType) {
        self.interactor = interactor
        self.router = router
        self.tripsType = tripsType
    }
    
    private func loadTripsData() {
        dataIsLoaded = false
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
}



extension TripsPresenter: TripsModuleInput {
}

extension TripsPresenter: TripsViewOutput {
    func viewWillAppear() {
        loadTripsData()
    }
    
    func refreshView() {
        hidePlaceholder()
        view?.reloadData()
        loadTripsData()
    }
    
    func placeholderDisplayData() -> PlaceHolderViewController.DisplayData {
        PlaceholderDisplayDataFactory().displayData()
    }
    
    func getTripsType() -> TripsType {
        tripsType
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
        if dataIsLoaded {
            if tripsData.count == 0 {
                embedRPlaceholder()
            }
            return tripsData.count
        }
        return 2
    }
    
    func getCellType() -> TripsCellType {
        if dataIsLoaded {
            return .usual
        }
        return .skeleton
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard dataIsLoaded else {
            return
        }
        switch indexPath.section {
        case 0:
            moduleOutput.tripsCollectionWantsToOpenNewRouteModule()
        default:
            guard tripsData.indices.contains(indexPath.row) else {
                view?.showAlert(title: "Ошибка",
                               message: "Возникла ошибка при открытии данных маршрута",
                               actionTitle: "Ок")
                return
            }
            moduleOutput.tripCollectionWantsToOpenTripInfoModule(trip: Trip(tripWithOtherData: tripsData[indexPath.row]),
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
            view?.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при попытке отредактировать данные маршрута",
                           actionTitle: "Ок")
            return
        }
        moduleOutput.tripsCollectionWantsToOpenExistingRoute(with: tripsData[indexPath.item])
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        guard tripsData.indices.contains(indexPath.row) else {
            view?.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных маршрута",
                           actionTitle: "Ок")
            return
        }
        view?.showChoiceAlert(title: "Удалить маршрут", message: "Вы уверены, что хотите удалиь маршрут?", agreeActionTitle: "Да", disagreeActionTitle: "Нет", cellIndexPath: indexPath)
    }
    
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath) {
        guard tripsData.indices.contains(cellIndexPath.row) else {
            view?.showAlert(title: "Ошибка",
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
        guard !data.isEmpty else {
            view?.reloadData()
            hideLoadingView()
            view?.endRefresh()
            dataIsLoaded = true
            embedRPlaceholder()
            return
        }
        
        for trip in data {
            dataLoadDispatchGroup.enter()
            dataLoadQueue.async(group: dataLoadDispatchGroup) { [weak self] in
                guard let self else { return }
                self.interactor.obtainRouteDataFromSever(with: trip.routeId) { result in
                    switch result {
                    case .failure:
                        self.didRecieveError(error: .obtainDataError)
                        self.dataLoadDispatchGroup.leave()
                    case .success(let route):
                        trips.append(TripWithRouteAndImage(trip: trip,
                                                           route: route))
                        self.dataLoadDispatchGroup.leave()
                    }
                }
            }
        }
        dataLoadDispatchGroup.notify(queue: dataLoadQueue) { [weak self] in
            self?.dataIsLoaded = true
            self?.didFinishObtainingTextData(trips: trips)
        }
    }
    
    func didFinishObtainingTextData(trips: [TripWithRouteAndImage]) {
        tripsData = trips
        tripsData.sort(by: {$0.dateChanged.timeIntervalSinceNow > $1.dateChanged.timeIntervalSinceNow})
        view?.reloadData()
        
        view?.endRefresh()
        hideLoadingView()
        for index in tripsData.indices {
            loadImage(for: tripsData[index].route) { [weak self] image in
                guard let self else { return }
                guard self.tripsData.count > index else { return }
                self.tripsData[index].image = image
                self.view?.setupCellImage(at: IndexPath(row: index, section: 1), image: image)
            }
        }
    }
    
    func loadImage(for route: Route, completion: @escaping (UIImage) -> Void) {
        guard let imageURL = route.imageURLString else { return }
        guard !imageURL.isEmpty else { return }
        interactor.obtainTripImageFromServer(withURL: imageURL) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.didRecieveError(error: .obtainDataError)
            case .success(let image):
                completion(image)
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
        switch error {
        case .obtainDataError:
            dataIsLoaded = true
            hideLoadingView()
            view?.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при получении данных",
                           actionTitle: "Ок")
            view?.endRefresh()
        case .saveDataError:
            view?.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при сохранении данных. Проверьте корректность данных и поробуйте снова",
                           actionTitle: "Ок")
        case .deleteDataError:
            cellToDeleteIndexPath = nil
            view?.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных",
                           actionTitle: "Ок")
        default:
            break
        }
    }
}
