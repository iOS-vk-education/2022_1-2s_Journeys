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

protocol FirebaseServiceObtainProtocol {
    func obtainTrip(with identifier: String, completion: @escaping (Result<Trip, Error>) -> Void)
    func obtainRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void)
    func obtainTrips(completion: @escaping (Result<[Trip], Error>) -> Void)
    func obtainSavedTrips(completion: @escaping (Result<[Trip], Error>) -> Void)
    func obtainTripImage(for imageURLString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func obtainBaseStuff(completion: @escaping (Result<[BaseStuff], Error>) -> Void)
    func obtainBaggage(baggageId: String, completion: @escaping (Result<[Stuff], Error>) -> Void)
    func obtainBaggageData(baggageId: String, completion: @escaping (Result<Baggage, Error>) -> Void)
}

extension FirebaseService: FirebaseServiceObtainProtocol {
    // MARK: Obtarin data
    
    func obtainTrips(completion: @escaping (Result<[Trip], Error>) -> Void){
        guard let userId = FBManager.auth.currentUser?.uid else {
            return
        }
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
                
                var trips = documents.compactMap { Trip(from: $0.data(), id: $0.documentID) }
                trips.sort(by: {$0.dateChanged.timeIntervalSinceNow > $1.dateChanged.timeIntervalSinceNow})
                completion(.success(trips))
            }
    }
    
    func obtainSavedTrips(completion: @escaping (Result<[Trip], Error>) -> Void){
        guard let userId = FBManager.auth.currentUser?.uid else {
            return
        }
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
                
                var trips = documents.compactMap { Trip(from: $0.data(), id: $0.documentID) }
                trips.sort(by: {$0.dateChanged.timeIntervalSinceNow > $1.dateChanged.timeIntervalSinceNow})
                completion(.success(trips))
            }
    }
    
    func obtainTrip(with identifier: String, completion: @escaping (Result<Trip, Error>) -> Void) {
        guard let userId = FBManager.auth.currentUser?.uid else {
            return
        }
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
                return
            }
            guard let snapshot = snapshot else {
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
    
    func obtainBaggageData(baggageId: String, completion: @escaping (Result<Baggage, Error>) -> Void) {
        FBManager.firestore.collection("baggage").document(baggageId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                assertionFailure("Error while obtaining trips data")
                return
            }
            guard let data = document?.data() else {
                assertionFailure("No data found")
                return
            }
            guard let baggage = Baggage(from: data, id: document!.documentID) else {
                completion(.failure(FBError.noData))
                return
            }
            completion(.success(baggage))
        }
    }
    
}
