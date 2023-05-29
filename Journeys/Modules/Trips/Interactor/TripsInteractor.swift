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
    
    private let dataLoadQueue = DispatchQueue.global()
    private let dataLoadDispatchGroup = DispatchGroup()
    
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
    private func obtainRouteDataFromSever(with identifier: String,
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
}


extension TripsInteractor: TripsInteractorInput {
    func addSnapshotListener(type: TripsType, moduleInput: TripsModuleInput) {
        FBService.tripsListener(type: type, tripsModule: moduleInput)
    }
    
    func obtainTripsDataFromSever(type: TripsType) {
        FBService.obtainTrips(type: type) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output?.didRecieveError(error: .obtainDataError)
            case .success(let trips):
                strongSelf.obtainRoutesDataFromServer(for: trips)
            }
        }
    }
    
    func obtainRouteDataFromServer(for trip: Trip, completion: @escaping (TripWithRouteAndImage) -> Void) {
        self.obtainRouteDataFromSever(with: trip.routeId) { result in
            switch result {
            case .failure:
                self.output?.didRecieveError(error: .obtainDataError)
            case .success(let route):
                completion(TripWithRouteAndImage(trip: trip,
                                                 route: route))
            }
        }
    }
    
    func obtainRoutesDataFromServer(for trips: [Trip]) {
        var tripsWithRoute: [TripWithRouteAndImage] = []
        guard !trips.isEmpty else {
            output?.noTripsFetched()
            return
        }
        
        for trip in trips {
            dataLoadDispatchGroup.enter()
            dataLoadQueue.async(group: dataLoadDispatchGroup) { [weak self] in
                guard let self else { return }
                self.obtainRouteDataFromSever(with: trip.routeId) { result in
                    switch result {
                    case .failure:
                        self.output?.didRecieveError(error: .obtainDataError)
                    case .success(let route):
                        tripsWithRoute.append(TripWithRouteAndImage(trip: trip,
                                                                    route: route))
                    }
                    self.dataLoadDispatchGroup.leave()
                }
            }
        }
        dataLoadDispatchGroup.notify(queue: dataLoadQueue) { [weak self] in
            self?.output?.didFetchTripsData(trips: tripsWithRoute)
        }
    }
    
    func loadImage(for route: Route, completion: @escaping (UIImage) -> Void) {
        guard let imageURL = route.imageURLString else { return }
        guard !imageURL.isEmpty else { return }
        obtainTripImageFromServer(withURL: imageURL) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output?.didRecieveError(error: .obtainDataError)
            case .success(let image):
                completion(image)
            }
        }
    }

    func obtainTripImageFromServer(withURL imageURLString: String,
                                   completion: @escaping (Result <UIImage, Error>)-> Void)  {
        FBService.obtainImage(for: imageURLString, imageType: .trip) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let image):
                completion(.success(image))
            }
        }
    }
    
    func storeTripData(trip: Trip, completion: @escaping () -> Void) {
        FBService.storeTripDataWithoutChangingDate(trip: trip) { [weak self] result in
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
