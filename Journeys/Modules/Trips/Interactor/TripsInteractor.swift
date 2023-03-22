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
    
    private func deleteImage(for imageURLString: String?) {
        guard let imageURLString else {
            output?.didRecieveError(error: .deleteDataError)
            return
        }
        FBService.deleteTripImage(for: imageURLString) { [weak self] error in
            guard let error else {
                self?.output?.didDeleteTrip()
                return
            }
            self?.output?.didRecieveError(error: .deleteDataError)
        }
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

    func obtainTripImageFromServer(withURL imageURLString: String,
                                   completion: @escaping (Result <UIImage, Error>)-> Void)  {
        FBService.obtainTripImage(for: imageURLString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let image):
                completion(.success(image))
            }
        }
    }
    
    func storeTripData(trip: Trip, completion: @escaping () -> Void) {
        FBService.storeTripData(trip: trip) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let error):
                strongSelf.output?.didRecieveError(error: .saveDataError)
            case .success(let trip):
                completion()
            }
        }
    }
    
    func deleteTrip(_ trip: TripWithRouteAndImage) {
        FBService.deleteTripData(Trip(tripWithOtherData: trip)) { [weak self] error in
            guard let error else {
                self?.deleteImage(for: trip.imageURLString)
                return
            }
            self?.output?.didRecieveError(error: .deleteDataError)
        }
    }
}
