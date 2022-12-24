//
//  RouteModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation

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
    
    func storeRouteData(route: Route) {
        FBService.storeRouteData(route: route) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output.didRecieveError(error: .saveDataError)
            case .success(let route):
                strongSelf.output.didSaveRouteData()
            }
        }
    }
    
    func storeNewTrip(route: Route) {
        let helper = StoreNewTrip(route: route,
                                  firebaseService: FBService,
                                  output: output)
        helper.start()
    }
}



