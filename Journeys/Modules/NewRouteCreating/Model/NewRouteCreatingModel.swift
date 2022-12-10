//
//  NewRouteCreatingModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation

// MARK: - NewRouteCreatingModel

struct RouteWithLocation {
    let id: String
    var departureTownLocation: Location
    var places: [PlaceWithLocation]
}

struct PlaceWithLocation {
    var location: Location
    var arrive: Date
    var depart: Date
}

final class NewRouteCreatingModel {
    private let FBService = FirebaseService()
}

extension NewRouteCreatingModel: NewRouteCreatingModelInput {
    func loadRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void) {
        FBService.obtainRoute(with: identifier, completion: completion)
    }
    
    func loadLocation(with identifier: String, completion: @escaping (Result<Location, Error>) -> Void) {
        FBService.obtainLocation(with: identifier, completion: completion)
    }
}


