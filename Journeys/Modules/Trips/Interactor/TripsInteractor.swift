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
    let FBService: FirebaseServiceProtocol
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.FBService = firebaseService
    }
}

extension TripsInteractor: TripsInteractorInput {
    func obtainTripsDataFromSever() {
        FBService.obtainTrips { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output?.didRecieveError(error: .obtainDataError)
            case .success(let trips):
                strongSelf.output?.didFetchTripsData(data: trips)
            }
        }
    }
    
    func obtainSavedTripsDataFromServer() {
        FBService.obtainSavedTrips { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output?.didRecieveError(error: .obtainDataError)
            case .success(let trips):
                strongSelf.output?.didFetchTripsData(data: trips)
            }
        }
    }
    
    func obtainRouteDataFromSever(with identifier: String,
                                  completion: @escaping (Result <Route, Error>)-> Void){
        FBService.obtainRoute(with: identifier) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let route):
                completion(.success(route))
            }
        }
    }

    func obtainTripImageFromServer(for imageURLString: String,
                                   completion: @escaping (Result <UIImage, Error>)-> Void)  {
        FBService.obtainTripImage(for: imageURLString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let route):
                completion(.success(route))
            }
        }
    }
    
    func storeTripData(trip: Trip) {
        FBService.storeTripData(trip: trip) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output?.didRecieveError(error: .saveDataError)
            case .success(let trips):
                break
            }
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        FBService.deleteTripData(trip) { [weak self] error in
            if error != nil {
                self?.output?.didRecieveError(error: .deleteDataError)
            } else {
                self?.output?.didDeleteTrip()
            }
        }
    }
}
