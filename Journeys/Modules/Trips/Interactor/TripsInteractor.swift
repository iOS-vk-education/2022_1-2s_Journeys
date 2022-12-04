//
//  TripsInteractor.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit
import FirebaseFirestore

// MARK: - TripsInteractor

final class TripsInteractor {

    weak var output: TripsInteractorOutput?
}

extension TripsInteractor: TripsInteractorInput {
    
    func obtainDataFromSever() -> [Trip] {
        var trips: [Trip] = []
        let FBManager = FirebaseManager()
        FBManager.obtainTrips() { result in
            switch result {
            case .success(let snapshot):
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        var trip = Trip(dictionary: document.data())
                        FBManager.obtainTripImage(trip: trip) { imageResult in
                            switch imageResult {
                            case .success(let image):
                                trip.image = image
                            case .failure(let error):
                                assertionFailure("Error while obtaining trips image from server: " + error.localizedDescription)
                            }
                        }
                        trips.append(trip)
                    }
                }
            case .failure(let error):
                assertionFailure("Error while obtaining trips data from server: " + error.localizedDescription)
            }
        }
        return trips
    }
}
