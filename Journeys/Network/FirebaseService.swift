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
    func storeTripData(trip: Trip, completion: @escaping (Result<Trip, Error>) -> Void)
    func storeRouteData(route: Route, completion: @escaping (Result<Route, Error>) -> Void)
    func storeTripImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func storeStuffData(baggageId: String, stuff: Stuff, completion: @escaping (Result<Stuff, Error>) -> Void)
    func storeBaggageData(baggage: Baggage, completion: @escaping (Result<Baggage, Error>) -> Void)

    func obtainTrip(with identifier: String, completion: @escaping (Result<Trip, Error>) -> Void)
    func obtainRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void)
    func obtainTrips(completion: @escaping (Result<[Trip], Error>) -> Void)
    func obtainSavedTrips(completion: @escaping (Result<[Trip], Error>) -> Void)
    func obtainTripImage(for imageURLString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func obtainBaseStuff(completion: @escaping (Result<[BaseStuff], Error>) -> Void)
    func obtainBaggage(baggageId: String, completion: @escaping (Result<[Stuff], Error>) -> Void)
    
    func deleteTripData(_ trip: Trip, completion: @escaping (Error?) -> Void)
}

class FirebaseService: FirebaseServiceProtocol {
    private let FBManager = FirebaseManager.shared
    
    // MARK: Store data
    
    func storeTripData(trip: Trip, completion: @escaping (Result<Trip, Error>) -> Void) {
        //        guard let userId = FBManager.auth.currentUser?.uid else {
        //            assertionFailure("Login first")
        //            return
        //        }
        let userId = "qHQmBmURT6Gns1cTve2m"
        var ref: DocumentReference?
        if let id = trip.id {
            ref = FBManager.firestore.collection("trips").document(userId).collection("user_trips").document(id)
        } else {
            ref = FBManager.firestore.collection("trips").document(userId).collection("user_trips").document()
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
            ref = FBManager.firestore.collection("routes").document(id)
        } else {
            ref = FBManager.firestore.collection("routes").document()
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
        let ref = FBManager.storage.reference(withPath: "trips_images/\(UUID().uuidString)")
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
        var ref: DocumentReference = FBManager.firestore.collection("baggage").document(baggage.id)
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
            ref = FBManager.firestore.collection("baggage").document(baggageId)
                .collection("baggage_stuff").document(id)
        } else {
            ref = FBManager.firestore.collection("baggage").document(baggageId)
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
    
    // MARK: Obtarin data
    
    func obtainTrips(completion: @escaping (Result<[Trip], Error>) -> Void){
        //        guard let userId = FBManager.auth.currentUser?.uid else {
        //            assertionFailure("Login first")
        //            return nil
        //        }
        let userId = "qHQmBmURT6Gns1cTve2m"
        FBManager.firestore.collection("trips")
            .document(userId).collection("user_trips").getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    assertionFailure("Error while obtaining trips data")
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.failure(FBError.noData))
                    return
                }
                
                let trips = documents.compactMap { Trip(from: $0.data(), id: $0.documentID) }
                completion(.success(trips))
            }
    }
    
    func obtainSavedTrips(completion: @escaping (Result<[Trip], Error>) -> Void){
        //        guard let userId = FBManager.auth.currentUser?.uid else {
        //            assertionFailure("Login first")
        //            return nil
        //        }
        let userId = "qHQmBmURT6Gns1cTve2m"
        FBManager.firestore.collection("trips")
            .document(userId).collection("user_trips").whereField("is_saved", isEqualTo: true).getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    assertionFailure("Error while obtaining trips data")
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.failure(FBError.noData))
                    return
                }
                
                let trips = documents.compactMap { Trip(from: $0.data(), id: $0.documentID) }
                completion(.success(trips))
            }
    }
    
    func obtainTrip(with identifier: String, completion: @escaping (Result<Trip, Error>) -> Void) {
        //        guard let userId = FBManager.auth.currentUser?.uid else {
        //            assertionFailure("Login first")
        //            return nil
        //        }
        let userId = "qHQmBmURT6Gns1cTve2m"
        FBManager.firestore.collection("trips").document(userId).collection("user_trips").document(identifier)
            .getDocument() { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    assertionFailure("Error while obtaining trips data")
                    return
                }
                guard let data = document?.data() else {
                    assertionFailure("No data found")
                    return
                }
                guard let trip = Trip(from: data, id: document!.documentID) else { return }
                completion(.success(trip))
            }
    }
    
    func obtainRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void) {
        Firestore.firestore().collection("routes").document(identifier).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                assertionFailure("Error while obtaining trips data")
                return
            }
            guard let data = document?.data() else {
                assertionFailure("No data found")
                return
            }
            guard let route = Route(from: data, id: document!.documentID) else {
                completion(.failure(FBError.noData))
                return
            }
            completion(.success(route))
        }
    }

    func obtainTripImage(for imageURLString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let ref = FBManager.storage.reference(forURL: imageURLString)
        let maxSize = Int64(10 * 1024 * 1024)
        ref.getData(maxSize: maxSize) { (data, error) in
            if let error = error {
                completion(.failure(error))
                assertionFailure("Error while obtaining image")
                return
            }
            if let imageData = data {
                guard let image = UIImage(data: imageData) else { return }
                completion(.success(image))
            }
        }
    }
    
    func obtainBaseStuff(completion: @escaping (Result<[BaseStuff], Error>) -> Void) {
        FBManager.firestore.collection("base_stuff").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                assertionFailure("Error while obtaining trips data")
                return
            }
            guard let snapshot = snapshot else {
                assertionFailure("No data found")
                return
            }

            var stuffList: [BaseStuff] = []
            for document in snapshot.documents {
                if let stuff = BaseStuff(from: document.data(), id: document.documentID) {
                    stuffList.append(stuff)
                }
            }
            completion(.success(stuffList))
        }
    }
    
    func obtainBaggage(baggageId: String, completion: @escaping (Result<[Stuff], Error>) -> Void) {
        FBManager.firestore.collection("baggage").document(baggageId).collection("baggage_stuff")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    assertionFailure("Error while obtaining trips data")
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.failure(FBError.noData))
                    return
                }
                
                let stuffList = documents.compactMap { Stuff(from: $0.data(), id: $0.documentID) }
                completion(.success(stuffList))
            }
    }
    
    // MARK: Delete data
    
    func deleteTripData(_ trip: Trip, completion: @escaping (Error?) -> Void) {
        //        guard let userId = FBManager.auth.currentUser?.uid else {
        //            assertionFailure("Login first")
        //            return nil
        //        }
        let userId = "qHQmBmURT6Gns1cTve2m"
        guard let id = trip.id else { return }
        FBManager.firestore.collection("trips").document(userId)
            .collection("user_trips").document(id).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
