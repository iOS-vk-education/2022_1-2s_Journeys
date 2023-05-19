//
//  FirebaseService.swift
//  Journeys
//
//  Created by Сергей Адольевич on 10.12.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol FirebaseServiceStoreProtocol {
    
    func storeTripData(trip: Trip, completion: @escaping (Result<Trip, Error>) -> Void)
    func storeRouteData(route: Route, completion: @escaping (Result<Route, Error>) -> Void)
    func storeTripImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func storeStuffData(baggageId: String, stuff: Stuff, completion: @escaping (Result<Stuff, Error>) -> Void)
    func storeBaggageData(baggage: Baggage, completion: @escaping (Result<Baggage, Error>) -> Void)
    func storeUserData(_ user: User, completion: @escaping (Result<User, Error>) -> Void)
}

extension FirebaseService: FirebaseServiceStoreProtocol {
    
    func storeTripData(trip: Trip, completion: @escaping (Result<Trip, Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        var ref: DocumentReference?
        if let id = trip.id {
            ref = firebaseManager.firestore.collection("trips").document(userId).collection("user_trips").document(id)
        } else {
            ref = firebaseManager.firestore.collection("trips").document(userId).collection("user_trips").document()
        }
        ref!.setData(trip.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let id = ref?.documentID, let trip = Trip(from: trip.toDictionary(), id: id) {
                completion(.success(trip))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeRouteData(route: Route, completion: @escaping (Result<Route, Error>) -> Void) {
        var ref: DocumentReference?
        if let id = route.id {
            ref = firebaseManager.firestore.collection("routes").document(id)
        } else {
            ref = firebaseManager.firestore.collection("routes").document()
        }
        ref!.setData(route.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let id = ref?.documentID, let route = Route(from: route.toDictionary(), id: id) {
                completion(.success(route))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeTripImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let ref = firebaseManager.storage.reference(withPath: "trips_images/\(UUID().uuidString)")
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
                    completion(.failure(FBError.noData))
                    return
                }
                completion(.success(url.absoluteString))
            }
        }
        // TODO: add link into trip
    }
    
    func storeBaggageData(baggage: Baggage, completion: @escaping (Result<Baggage, Error>) -> Void) {
        var ref: DocumentReference = firebaseManager.firestore.collection("baggage").document(baggage.id)
        ref.setData(baggage.toDictionary()) { error in
            let id = ref.documentID
            if let error = error {
                completion(.failure(error))
            } else if let baggage = Baggage(from: baggage.toDictionary(), id: id) {
                completion(.success(baggage))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeStuffData(baggageId: String, stuff: Stuff, completion: @escaping (Result<Stuff, Error>) -> Void) {
        var ref: DocumentReference?
        if let id = stuff.id {
            ref = firebaseManager.firestore.collection("baggage").document(baggageId)
                .collection("baggage_stuff").document(id)
        } else {
            ref = firebaseManager.firestore.collection("baggage").document(baggageId)
                .collection("baggage_stuff").document()
        }
        ref!.setData(stuff.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let id = ref?.documentID, let stuff = Stuff(from: stuff.toDictionary(), id: id) {
                completion(.success(stuff))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeUserData(_ user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            completion(.failure(Errors.saveDataError))
            return
        }
        var ref: DocumentReference = firebaseManager.firestore.collection("users").document(userId)
        ref.setData(user.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let user = User(from: user.toDictionary(), id: ref.documentID) {
                completion(.success(user))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
}
    
