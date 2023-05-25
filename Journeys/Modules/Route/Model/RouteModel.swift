//
//  RouteModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation
import UIKit

// MARK: - RouteModel

final class RouteModel {
    weak var output: RouteModelOutput!
    private let FBService: FirebaseServiceProtocol
    private var helper: StoreNewTrip?
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
}

extension RouteModel: RouteModelInput {
    
    func storeRouteData(route: Route, tripImage: UIImage, tripId: String) {
        FBService.storeTripImage(image: tripImage) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output.didRecieveError(error: .saveDataError)
            case .success(let url):
                strongSelf.didStoreImageData(url: url, route: route)
            }
        }
    }
    
    func didStoreImageData(url: String, route: Route) {
        let newRoute = Route(id: route.id,
                             imageURLString: url,
                             departureLocation: route.departureLocation,
                             places: route.places)
        FBService.storeRouteData(route: newRoute) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output.didRecieveError(error: .saveDataError)
            case .success(let route):
                strongSelf.output.didSaveRouteData(route: route)
            }
        }
    }
    
    func storeNewTrip(route: Route, tripImage: UIImage) {
        helper = StoreNewTrip(route: route,
                              tripImage: tripImage,
                              firebaseService: FBService,
                              output: self)
        helper?.start()
    }
}

extension RouteModel: StoreNewTripOutput {
    func saveFinished(trip: Trip, route: Route) {
        output.didSaveData(trip: trip, route: route)
    }
    
    func saveError() {
        output.didRecieveError(error: .saveDataError)
    }
}

