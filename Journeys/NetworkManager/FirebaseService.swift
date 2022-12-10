//
//  FirebaseService.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation
import UIKit

protocol FirebaseServiceProtocol {
    func storeTripData(trip: Trip)
    func storeRouteData(route: Route)
    func storePlaceData(place: Place)
    func storeTripImage(tripId: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void)

    func obtainTrip(with identifier: String, completion: @escaping (Result<Trip, Error>) -> Void)
    func obtainRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void)
    func obtainLocation(with identifier: String,  completion: @escaping (Result<Location, Error>) -> Void)
    func obtainTrips(completion: @escaping (Result<[Trip], Error>) -> Void)
    func obtainTripImage(trip: Trip, completion: @escaping (Result<UIImage?, Error>) -> Void)
    
}

class FirebaseService: FirebaseServiceProtocol {
    
    private let FBManager = FirebaseManager()
    
    // MARK: Store data

    func storeTripData(trip: Trip) {
        guard let userId = FBManager.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return
        }
        FBManager.firestore.collection("trips")
            .document(userId).collection("users_trips").document().setData(trip.toDictionary()) { error in
                guard let error = error else {
                    return
                }
                assertionFailure("Error while saving data: \(error)")
            }
    }
    
    func storeRouteData(route: Route) {

        FBManager.firestore.collection("routes")
            .document().setData(route.toDictionary()) { error in
                guard let error = error else {
                    return
                }
                assertionFailure("Error while saving data: \(error)")
            }
    }
    
//    func storePlaceData(place: Place) {
//        FBManager.firestore.collection("places")
//            .document().setData(place.toDictionary()) { error in
//                guard let error = error else {
//                    return
//                }
//                assertionFailure("Error while saving data: \(error)")
//            }
//    }
    
    func storeTripImage(tripId: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = FBManager.storage.reference(withPath: "trips_images/\(tripId)")
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
        // TODO: add link into trip
    }

    // MARK: Obtarin data

    func obtainTrip(with identifier: String, completion: @escaping (Result<Trip, Error>) -> Void) {
        guard let userId = FBManager.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return
        }
        FBManager.firestore.collection("trips")
            .document(userId).collection("users_trips").document(identifier).getDocument() { (document, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let data = document?.data() else {
                    assertionFailure("No data found")
                    return
                }
                completion(.success(Trip(from: data)))
            }
    }
    
    func obtainRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void) {
        FBManager.firestore.collection("routes")
            .document(identifier).getDocument() { (document, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let data = document?.data() else {
                    assertionFailure("No data found")
                    return
                }
                completion(.success(Route(from: data)))
            }
    }
    
    func obtainLocation(with identifier: String, completion: @escaping (Result<Location, Error>) -> Void) {
        FBManager.firestore.collection("locations")
            .document(identifier).getDocument() { (document, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let data = document?.data() else {
                    assertionFailure("No data found")
                    return
                }
                completion(.success(Location(from: data)))
            }
    }
    
    func obtainTrips(completion: @escaping (Result<[Trip], Error>) -> Void) {
        guard let userId = FBManager.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return
        }
        FBManager.firestore.collection("trips")
            .document(userId).collection("users_trips").getDocuments() { (snapshot, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let snapshot = snapshot else {
                    assertionFailure("No data found")
                    return
                }
                
                var trips: [Trip] = []
                for document in snapshot.documents {
                    let trip = Trip(from: document.data())
                    trips.append(trip)
                }
                completion(.success(trips))
            }
        }
    

    func obtainTripImage(trip: Trip, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let ref = FBManager.storage.reference(forURL: trip.imageURLString)
        let maxSize = Int64(10 * 1024 * 1024)
        ref.getData(maxSize: maxSize) { (data, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let imageData = data {
                completion(.success(UIImage(data: imageData)))
            }
        }
    }
    
    func obtainData(with identifier: String, table: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
        FBManager.firestore.collection(table)
            .document(identifier).getDocument() { (document, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let data = document?.data() else {
                    assertionFailure("No data found")
                    return
                }
                completion(.success(data))
            }
    }
}

enum Tables: String {
    case trips
    case routes
    case locations
}
