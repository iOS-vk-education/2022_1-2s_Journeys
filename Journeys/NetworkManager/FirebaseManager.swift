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
    
    static let shared = FirebaseManager()
    static let database = Firestore.firestore()
    
    private func configureDB() -> Firestore {
        Firestore.firestore().settings = FirestoreSettings()
        return Firestore.firestore()
    }
    
    func obtainTrip(with identifier: String, completion: @escaping (Result<[Trip], Error>) -> Void) {
        let database = configureDB()
        database.collection("Trip").document(identifier).getDocument(completion: { (document, error) in
            guard error == nil else {
                completion(.failure(error!))
                assertionFailure("Error while obtaining Trips data from server")
                return
            }
            if let data = document?.data() {
                let trip = Trip(dictionary: data)
            }
        })
    }
    
    func getTripRoute(with identifier: String, completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
        let database = configureDB()
        database.collection("Route").document(identifier).getDocument(completion: { (document, error) in
            guard error == nil else {
                completion(.failure(error!))
                assertionFailure("Error while obtaining Trips data from server")
                return
            }
            completion(.success(document?.data()))
        })
    }
    
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
    
    func obtainTrips(completion: @escaping (Result<QuerySnapshot?, Error>) -> Void) {
        let ref = FirebaseManager.database.collection("Trip")
        ref.getDocuments() { (snapshot, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
//            if let snapshot = snapshot {
                completion(.success(snapshot))
//                var trips: [Trip] = []
//                for document in snapshot.documents {
//                    if let data = document.data() {
//                        let trip = Trip(dictionary: data)
//                        trips.append(trip)
//                    }
//                }
//            }
        }
    }
    
    func saveTripImage(tripId: String, image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child(Constants.tripsImagesFolderName).child(tripId)
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
        ref.putData(imageData) { (metadata, error) in
            guard error == nil else {
                completion(.failure(error!))
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
}

private extension FirebaseManager {
    enum Constants {
        static let tripsImagesFolderName: String = "trips_images"
    }
}
