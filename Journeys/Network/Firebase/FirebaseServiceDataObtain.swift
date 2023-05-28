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
import FirebaseStorage

protocol FirebaseServiceObtainProtocol {
    func obtainTrip(with identifier: String, completion: @escaping (Result<Trip, Error>) -> Void)
    func obtainRoute(with identifier: String, completion: @escaping (Result<Route, Error>) -> Void)
    func obtainTrips(type: TripsType, completion: @escaping (Result<[Trip], Error>) -> Void)
    
    func obtainBaseStuff(completion: @escaping (Result<[BaseStuff], Error>) -> Void)
    func obtainBaggage(baggageId: String, completion: @escaping (Result<[Stuff], Error>) -> Void)
    func obtainBaggageData(baggageId: String, completion: @escaping (Result<Baggage, Error>) -> Void)
    
    func obtainStuffLists(type: StuffListType, completion: @escaping (Result<[StuffList], Error>) -> Void)
    func obtainCertainUserStuff(stuffId: String, completion: @escaping (Result<Stuff, Error>) -> Void)
    
    func obtainCurrentUserData(completion: @escaping (Result<User, Error>) -> Void)
    func currentUserEmail() -> String?
    
    func obtainImage(for url: String?,
                     imageType: FirebaseStoreageImageType,
                     completion: @escaping (Result<UIImage, Error>) -> Void)
}


extension FirebaseService: FirebaseServiceObtainProtocol {
    // MARK: Obtarin data
    
    func obtainTrips(type: TripsType, completion: @escaping (Result<[Trip], Error>) -> Void){
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        
        var query: Query = firebaseManager.firestore.collection("trips")
            .document(userId).collection("user_trips")
        if type == .saved {
            query = query.whereField("is_saved", isEqualTo: true)
        }
        
        query.getDocuments { (snapshot, error) in
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
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        firebaseManager.firestore.collection("trips").document(userId).collection("user_trips").document(identifier)
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
    
    func obtainBaseStuff(completion: @escaping (Result<[BaseStuff], Error>) -> Void) {
        firebaseManager.firestore.collection("base_stuff").getDocuments { (snapshot, error) in
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
        firebaseManager.firestore.collection("baggage").document(baggageId).collection("baggage_stuff")
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
        firebaseManager.firestore.collection("baggage").document(baggageId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                assertionFailure("Error while obtaining trips data")
                return
            }
            guard let data = document?.data() else {
                completion(.failure(Errors.obtainDataError))
                return
            }
            guard let baggage = Baggage(from: data, id: document!.documentID) else {
                completion(.failure(FBError.noData))
                return
            }
            completion(.success(baggage))
        }
    }
    
    func obtainStuffLists(type: StuffListType, completion: @escaping (Result<[StuffList], Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        var query: Query = firebaseManager.firestore.collection("stuff_lists")
            .document(userId).collection("user_stuff_lists")
        if type == .alwaysAdding {
            query = query.whereField("auto_add", isEqualTo: true)
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                completion(.failure(Errors.obtainDataError))
                return
            }
            
            var stuffLists: [StuffList] = []
            for document in snapshot.documents {
                if let stuffList = StuffList(from: document.data(), id: document.documentID) {
                    stuffLists.append(stuffList)
                }
            }
            stuffLists.sort(by: {$0.dateCreated.timeIntervalSinceNow < $1.dateCreated.timeIntervalSinceNow})
            completion(.success(stuffLists))
        }
    }
    
    func obtainCertainUserStuff(stuffId: String, completion: @escaping (Result<Stuff, Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        firebaseManager.firestore.collection("stuff")
            .document(userId).collection("user_stuff")
            .document(stuffId).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = document?.data() else {
                    completion(.failure(Errors.obtainDataError))
                    return
                }
                guard let stuff = Stuff(from: data, id: document!.documentID) else {
                    completion(.failure(FBError.noData))
                    return
                }
                completion(.success(stuff))
            }
    }
    
    func obtainCurrentUserData(completion: @escaping (Result<User, Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            completion(.failure(Errors.obtainDataError))
            return
        }
        
        firebaseManager.firestore.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = document?.data() else {
                completion(.failure(FBError.noData))
                return
            }
            guard var user = User(from: data, id: document!.documentID) else {
                completion(.failure(FBError.noData))
                return
            }
            if let email = self?.currentUserEmail() {
                user.email = email
            }
            completion(.success(user))
        }
    }
    
    func currentUserEmail() -> String? {
        firebaseManager.auth.currentUser?.email
    }
    
    func obtainImage(for url: String?,
                     imageType: FirebaseStoreageImageType,
                     completion: @escaping (Result<UIImage, Error>) -> Void) {
        var reference: StorageReference?
        if imageType == .avatar {
            guard let userId = firebaseManager.auth.currentUser?.uid else {
                completion(.failure(Errors.obtainDataError))
                return
            }
            reference = firebaseManager.storage.reference(withPath: "avatars/\(userId)")
        }
        if let url {
            reference = firebaseManager.storage.reference(forURL: url)
        }
        let maxSize = Int64(10 * 1024 * 1024)
        
        guard let reference else {
            completion(.failure(Errors.obtainDataError))
            return
        }
        reference.getData(maxSize: maxSize) { (data, error) in
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
}
