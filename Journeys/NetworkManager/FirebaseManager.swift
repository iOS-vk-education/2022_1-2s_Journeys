//
//  FirebaseManager.swift
//  Journeys
//
//  Created by Сергей Адольевич on 29.11.2022.
//

import Foundation
import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

final class FirebaseManager {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
    }
}

enum Tables: String {
    case trips
    case routes
    case locations
}

extension FirebaseManager {
    
    // MARK: Store data

    func storeTripData(trip: Trip) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return
        }
        FirebaseManager.shared.firestore.collection("trips")
            .document(userId).collection("users_trips").document().setData(trip.toDictionary()) { error in
                guard let error = error else {
                    return
                }
                assertionFailure("Error while saving data: \(error)")
            }
    }
    
    func storeRouteData(route: Route) {

        FirebaseManager.shared.firestore.collection("routes")
            .document().setData(route.toDictionary()) { error in
                guard let error = error else {
                    return
                }
                assertionFailure("Error while saving data: \(error)")
            }
    }
    
    func storePlaceData(place: Place) {
        FirebaseManager.shared.firestore.collection("places")
            .document().setData(place.toDictionary()) { error in
                guard let error = error else {
                    return
                }
                assertionFailure("Error while saving data: \(error)")
            }
    }
    
    func storeTripImage(tripId: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = FirebaseManager.shared.storage.reference(withPath: tripId)
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
        //add link into trip
    }
    
    
    // MARK: Obtarin data

    func obtainTrip(with identifier: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return
        }
        FirebaseManager.shared.firestore.collection("trips")
            .document(userId).collection("users_trips").document(identifier).getDocument() { (document, error) in
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
    
    func obtainRoute(with identifier: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
        FirebaseManager.shared.firestore.collection("routes")
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
    
    func obtainLocation(with identifier: String,  completion: @escaping (Result<[String : Any], Error>) -> Void) {
        FirebaseManager.shared.firestore.collection("locations")
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
    
    func obtainTrips(completion: @escaping (Result<QuerySnapshot, Error>) -> Void) {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {
            assertionFailure("Login first")
            return
        }
        FirebaseManager.shared.firestore.collection("trips")
            .document(userId).collection("users_trips").getDocuments() { (snapshot, error) in
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let snapshot = snapshot else {
                    assertionFailure("No data found")
                    return
                }
                completion(.success(snapshot))
            }
        }
    

    func obtainTripImage(trip: Trip, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let ref = Storage.storage().reference(forURL: trip.imageURLString)
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
    
//    func getTripRoute(with identifier: String, completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
//        let database = configureDB()
//        database.collection("Route").document(identifier).getDocument(completion: { (document, error) in
//            guard error == nil else {
//                completion(.failure(error!))
//                assertionFailure("Error while obtaining Trips data from server")
//                return
//            }
//            completion(.success(document?.data()))
//        })
//    }
    
//    func getTripPlaces(with identifier: String, completion: @escaping (Result<[Trip], Error>) -> Void) {
//        let database = configureDB()
//        database.collection("Route").document(identifier).getDocument(completion: { (document, error) in
//            guard error == nil else {
//                completion(.failure(error!))
//                assertionFailure("Error while obtaining Trips data from server")
//                return
//            }
//            if let data = document?.data() {
//                let route = Route(dictionary: data)
//            }
//        })
//    }
    
//    func obtainTrips(completion: @escaping (Result<QuerySnapshot?, Error>) -> Void) {
//        let ref = FirebaseManager.database.collection("Trip")
//        ref.getDocuments() { (snapshot, error) in
//            guard error == nil else {
//                completion(.failure(error!))
//                return
//            }
////            if let snapshot = snapshot {
//                completion(.success(snapshot))
////                var trips: [Trip] = []
////                for document in snapshot.documents {
////                    if let data = document.data() {
////                        let trip = Trip(dictionary: data)
////                        trips.append(trip)
////                    }
////                }
////            }
//        }
//    }
    
    func obtainData(with identifier: String, table: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
        FirebaseManager.shared.firestore.collection(table)
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

private extension FirebaseManager {
    enum Constants {
        static let tripsImagesFolderName: String = "trips_images"
    }
}
