//
//  NewRouteCreatingModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 17/11/2022.
//

import Foundation

// MARK: - NewRouteCreatingModel

final class NewRouteCreatingModel {
    weak var output: NewRouteCreatingModelOutput!
    private let FBService: FirebaseServiceProtocol
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
}

extension NewRouteCreatingModel: NewRouteCreatingModelInput {
    func obtainRouteDataFromSever(with identifier: String) {
        guard let route = FBService.obtainRoute(with: identifier) else {
            output.didRecieveError(error: .obtainDataError)
            return
        }
        output.didFetchRouteData(data: route)
    }
}


