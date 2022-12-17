//
//  FirebaseService.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol FirebaseServiceProtocol {
    func storeTripData(trip: Trip)
    func storeRouteData(route: Route)
//    func storePlaceData(place: Place)
    func storeTripImage(tripId: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void)

    func obtainTrip(with identifier: String) -> Trip?
    func obtainRoute(with identifier: String) -> Route?
//    func obtainLocation(with identifier: String,  completion: @escaping (Result<Location, Error>) -> Void)
    func obtainTrips() -> [Trip]?
    func obtainTripImage(for imageURLtring: String) -> UIImage?
    
}

class FirebaseService: FirebaseServiceProtocol {
    
    
    private let FBManager = FirebaseManager.shared
    
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

    func obtainTrip(with identifier: String) -> Trip? {
        guard let userId = FBManager.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return nil
        }
        var trip: Trip?
        let group = DispatchGroup()
        group.enter()
        FBManager.firestore.collection("trips").document(userId).collection("users_trips").document(identifier)
            .getDocument() { (document, error) in
                guard error == nil else {
                    assertionFailure("Error while obtaining trip data")
                    group.leave()
                    return
                }
                guard let data = document?.data() else {
                    assertionFailure("No data found")
                    group.leave()
                    return
                }
                trip = Trip(from: data)
                group.leave()
            }
        group.wait()
        return trip
    }
    
    func obtainRoute(with identifier: String) -> Route? {
        var route: Route?
        let group = DispatchGroup()
        group.enter()
        Firestore.firestore().collection("routes").document(identifier).getDocument { (document, error) in
            guard error == nil else {
                assertionFailure("Error while obtaining route data")
                group.leave()
                return
            }
            guard let data = document?.data() else {
                assertionFailure("No data found")
                group.leave()
                return
            }
            route = Route(from: data)
            group.leave()
        }
        group.wait()
        return route
    }
    
    func obtainTrips() -> [Trip]? {
        guard let userId = FBManager.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return nil
        }
        var trips: [Trip]?
        let group = DispatchGroup()
        group.enter()
        FBManager.firestore.collection("trips")
            .document(userId).collection("users_trips").getDocuments { (snapshot, error) in
                guard error == nil else {
                    assertionFailure("Error while obtaining trips data")
                    group.leave()
                    return
                }
                guard let snapshot = snapshot else {
                    assertionFailure("No data found")
                    group.leave()
                    return
                }
                
                trips = []
                for document in snapshot.documents {
                    let trip = Trip(from: document.data())
                    trips?.append(trip)
                }
                group.leave()
            }
        group.wait()
        return trips
    }
    

    func obtainTripImage(for imageURLString: String) -> UIImage? {
        let ref = FBManager.storage.reference(forURL: imageURLString)
        let maxSize = Int64(10 * 1024 * 1024)
        var image: UIImage?
        let group = DispatchGroup()
        group.enter()
        ref.getData(maxSize: maxSize) { (data, error) in
            guard error == nil else {
                assertionFailure("Error while obtaining image")
                group.leave()
                return
            }
            if let imageData = data {
                image = UIImage(data: imageData)
                group.leave()
            }
        }
        group.wait()
        return image
    }
    
//    func obtainData(with identifier: String,
//                    table: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
//        FBManager.firestore.collection(table)
//            .document(identifier).getDocument() { (document, error) in
//                guard error == nil else {
//                    completion(.failure(error!))
//                    return
//                }
//                guard let data = document?.data() else {
//                    assertionFailure("No data found")
//                    return
//                }
//                completion(.success(data))
//            }
//    }
}

//enum Tables: String {
//    case trips
//    case routes
//    case locations
//}
