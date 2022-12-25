//
//  RoutePresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit

// MARK: - RoutePresenter

final class RoutePresenter {

    // MARK: - Public Properties

    weak var view: RouteViewInput!
    var model: RouteModelInput!
    weak var moduleOutput: RouteModuleOutput!

    let deportCellsCount: Int = 1
    let addNewCityCellsCount: Int = 1
    var arrivalCellsCount: Int = 0
    
    var route: Route?
    var trip: Trip?
    var tripImage: UIImage?

    internal init(trip: Trip?) {
        self.trip = trip
    }
    
    private let addNewCellClosure: (RouteViewController, UITableView)->() = { view, tableView in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell") as? RouteCell
        else {
            assertionFailure("Error while creating cell")
            return
        }
        let indexPath = NSIndexPath(row: tableView.numberOfRows(inSection: 1), section: 2)
        guard let displayData = view.output.getDisplayData(for: indexPath as IndexPath) else { return }
        cell.configure(displayData: displayData)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    private let deleteRow: (UITableView, IndexPath) -> [UITableViewRowAction]? = { tableView, indexPath in
        let deleteAction = UITableViewRowAction(style: .destructive, title: L10n.delete) { (action, indexPath) in
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        return[deleteAction]
    }
}

extension RoutePresenter: RouteViewOutput {
    
    func viewDidLoad() {
        guard let trip = trip else { return }
        getRoute(routeId: trip.routeId)
    }
    
    
    func numberOfSectins() -> Int {
        4
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return deportCellsCount
        case 2:
            return arrivalCellsCount
        case 3:
            return addNewCityCellsCount
        default:
            return 0
        }
    }
    
    func getImageCellDisplayData() -> UIImage {
        if let tripImage = tripImage {
            return tripImage
        }
        let numberOfImages = 5
        let random = Int.random(in: 1...numberOfImages)
        let image = UIImage(named: "TripCellImage\(random)")
        tripImage = image
        return image ?? UIImage()
    }
    
    func getDisplayData(for indexpath: IndexPath) -> RouteCell.DisplayData? {
        let displayData = RouteCellDisplayDataFactory()
        switch indexpath.section {
        case 1:
            return displayData.displayData(cellType: .departureTown(location: route?.departureLocation))
        case 2:
            guard let route = route else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            guard route.places.indices.contains(indexpath.row) else {
                return displayData.displayData(cellType: .arrivalTown(location: nil))
            }
            return displayData.displayData(cellType: .arrivalTown(location: route.places[indexpath.row].location))
        case 3:
            return displayData.displayData(cellType: .newLocation)
        default:
            return nil
        }
    }

    func didTapExitButton() {
        moduleOutput.routeModuleWantsToClose()
    }
    
    func didTapFloatingSaveButton() {
        guard let route = route else {
            view.showAlert(title: "Ошибка", message: "Введите данные")
            return
        }
        guard let tripImage = tripImage else {
            view.showAlert(title: "Ошибка", message: "Выберите титульное фото для поездки")
            return
        }
        guard let trip = trip,
              let tripId = trip.id else {
            model.storeNewTrip(route: route, tripImage: tripImage)
            return
        }
        model.storeRouteData(route: route, tripImage: tripImage, tripId: tripId)
    }
    
    func didSelectRow(at indexpath: IndexPath) -> ((RouteViewController, UITableView)->())? {
        switch indexpath.section {
        case 0:
            view.showImagePicker()
            return nil
        case 1:
            routeModuleWantsToOpenDepartureLocationModule()
            return nil
        case 2:
            routeModuleWantsToOpenPlacenModule(indexPath: indexpath)
            return nil
        case 3:
            guard route != nil else {
                view.showAlert(title: "Введите город отправления", message: "Сначала введите город отправления")
                return nil
            }
            arrivalCellsCount += 1
            return addNewCellClosure
        default:
            assertionFailure("Cell selection error: too much sections")
            return nil
        }
    }

    func userWantsToDeleteCell(indexPath: IndexPath) -> ((UITableView, IndexPath) -> [UITableViewRowAction]?)? {
        if indexPath.row == 0 {
            return nil
        }
        guard var route = route else {
            return nil
        }
        if route.places.indices.contains(indexPath.row) {
            route.places.remove(at: indexPath.row)
            arrivalCellsCount -= 1
        }
        self.route = route
        return deleteRow
    }
    
    func setTripImage(_ image: UIImage) {
        self.tripImage = image
    }
}

extension RoutePresenter: RouteModelOutput {

    func didFetchRouteData(data: Route) {
        self.route = data
        arrivalCellsCount = (data.places.count > 1 ? data.places.count : 1)
        guard let imageURL = data.imageURLString else {
            view.showAlert(title: "Ошибка", message: "Ошибка при загрузке титульной картинки поездки")
            return
        }
        model.obtainTripImageFromServer(withURL: imageURL)
    }
    
    func didFetchTripImage(image: UIImage) {
        self.tripImage = image
        view.reloadData()
    }
    func didRecieveError(error: Errors) {
        switch error {
        case .obtainDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при получении данных")
        case .saveDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при сохранении данных")
        case .deleteDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных")
        default:
            break
        }
    }
    
    func didSaveRouteData(route: Route) {
        guard let trip else {
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при открытии данных поездки")
            return
        }
        moduleOutput.routeModuleWantsToOpenTripInfoModule(trip: trip,
                                                          route: route)
    }
    
    func didSaveData(trip: Trip, route: Route) {
        moduleOutput.routeModuleWantsToOpenTripInfoModule(trip: trip,
                                                          route: route)
    }
}

extension RoutePresenter: RouteModuleInput {
    func updateRouteDepartureLocation(location: Location) {
        if self.route != nil {
            self.route!.departureLocation = location
        } else {
            self.route = Route(id: nil, imageURLString: nil, departureLocation: location, places: [])
            self.arrivalCellsCount += 1
        }
        view.reloadData()
    }
    func updateRoutePlaces(place: Place, placeIndex: Int) {
        if route?.places.indices.contains(placeIndex) == true {
            self.route?.places[placeIndex] = place
        } else {
            self.route?.places.append(place)
        }
        view.reloadData()
    }
}


private extension RoutePresenter {
    func getRoute(routeId: String) {
        model.obtainRouteDataFromSever(with: routeId)
    }
    
    func routeModuleWantsToOpenPlacenModule(indexPath: IndexPath) {
        guard let route = route else {
            moduleOutput.routeModuleWantsToOpenPlaceModule(place: nil,
                                                           placeIndex: indexPath.row,
                                                           routeModuleInput: self)
            return
        }
        if route.places.indices.contains(indexPath.row) {
            moduleOutput.routeModuleWantsToOpenPlaceModule(place: route.places[indexPath.row],
                                                           placeIndex: indexPath.row,
                                                           routeModuleInput: self)
        } else {
            moduleOutput.routeModuleWantsToOpenPlaceModule(place: nil,
                                                           placeIndex: indexPath.row,
                                                           routeModuleInput: self)
        }
    }
    
    func sortRoutePlaces() {
        route?.places.sort(by: {$0.depart.timeIntervalSinceNow > $1.depart.timeIntervalSinceNow})
    }
    
    func routeModuleWantsToOpenDepartureLocationModule() {
        moduleOutput.routeModuleWantsToOpenDepartureLocationModule(departureLocation: route?.departureLocation,
                                                                   routeModuleInput: self)
    }
}
