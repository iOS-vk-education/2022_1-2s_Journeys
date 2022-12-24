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
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
}

extension RouteModel: RouteModelInput {
    func obtainRouteDataFromSever(with identifier: String) {
        FBService.obtainRoute(with: identifier) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output.didRecieveError(error: .obtainDataError)
            case .success(let route):
                strongSelf.output.didFetchRouteData(data: route)
            }
        }
    }
    
    func obtainTripImageFromServer(withURL imageURLString: String)  {
        FBService.obtainTripImage(for: imageURLString) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output.didRecieveError(error: .obtainDataError)
            case .success(let image):
                strongSelf.output.didFetchTripImage(image: image)
            }
        }
    }
    
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
                strongSelf.output.didSaveRouteData()
            }
        }
    }
    
    func storeNewTrip(route: Route, tripImage: UIImage) {
        let helper = StoreNewTrip(route: route,
                                  tripImage: tripImage,
                                  firebaseService: FBService,
                                  output: output)
        helper.start()
    }
}



