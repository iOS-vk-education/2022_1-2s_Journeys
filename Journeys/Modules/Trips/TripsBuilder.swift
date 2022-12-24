//
//  TripsBuilder.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsModuleBuilder

extension DateFormatter {

    static var dayAndWeekDay: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "E dd"
        return dateFormatter
    }

    static var fullDateWithDash: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

//    static var timeFromString: DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = .short
//        return dateFormatter
//    }
}

final class TripsModuleBuilder {
    func build(firebaseService: FirebaseServiceProtocol,
               output: TripsModuleOutput,
               tripsViewControllerType: TripsViewController.ScreenType = TripsViewController.ScreenType.usual) -> UIViewController {
        //                firebaseService.storeTripData(trip: Trip(id: nil, imageURLString: nil, routeId: "ptlOYsXo6TFTuvemhSpH", stuffIds: ["1", "2"], dateChanged: Date())) { result in
        //                    switch result {
        //                    case .failure(let error):
        //                        assertionFailure("\(error)")
        //                    case .success(let trip):
        //                       print("\(trip)")
        //                    }
        //                }
        //
        //        let trip = Trip(id: nil, imageURLString: nil, routeId: "ptlOYsXo6TFTuvemhSpH", baggageId: "1", dateChanged: Date())
        //        print(trip.toDictionary())
        //        let places = [Place(location: Location(country: "Russia", city: "Kursk"), arrive: Date(), depart: Date().addingTimeInterval(100000)),
        //                      Place(location: Location(country: "Russia", city: "Anapa"), arrive: Date().addingTimeInterval(100000), depart: Date().addingTimeInterval(200000))]
        //        let route = Route(id: nil,
        //                          departureLocation: Location(country: "Russia", city: "Moscow"),
        //                          places: places)
        //        print(route.toDictionary())
        //        firebaseService.storeRouteData(route: Route(id: nil,
        //                                                    departureLocation: Location(country: "Russia", city: "Moscow"),
        //                                                    places: places)) { result in
        //            switch result {
        //            case .failure(let error):
        //                assertionFailure("\(error)")
        //            case .success(let trip):
        //                assertionFailure("It worked")
        //            }
        //
        //        }
        //
        
        //        firebaseService.storeStuffData(stuff: Stuff(id: nil, emoji: "a", name: "sssss", isPacked: true)) {result in
        //            switch result {
        //            case .failure(let error):
        //                assertionFailure("\(error)")
        //            case .success(let trip):
        //                assertionFailure("It worked")
        //            }
        //        }
        
        //        firebaseService.obtainBaseStuff {result in
        //            switch result {
        //            case .failure(let error):
        //                assertionFailure("\(error)")
        //            case .success(let data):
        //                assertionFailure("\(data)")
        //            }
        //        }
        //        
        //        return UIViewController()
        
        
        
        let router = TripsRouter()
        let interactor = TripsInteractor(firebaseService: firebaseService)
        let presenter = TripsPresenter(interactor: interactor,
                                       router: router,
                                       tripsViewControllerType: tripsViewControllerType)
        
        presenter.moduleOutput = output
        interactor.output = presenter
        
        let viewController = TripsViewController()
        viewController.output = presenter
        presenter.view = viewController
        
        return viewController
    }
}
