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
    func storeImage(image: UIImage,
                    imageType: FirebaseStoreageImageType,
                    completion: @escaping (Result<String, Error>) -> Void)
    func storeStuffData(baggageId: String, stuff: Stuff, completion: @escaping (Result<Stuff, Error>) -> Void)
    func storeBaggageData(baggage: Baggage, completion: @escaping (Result<Baggage, Error>) -> Void)
    
    func storeStuffList(stuffList: StuffList,
                        completion: @escaping (Result<StuffList, Error>) -> Void)
    func storeSertainStuffListStuff(stuff: Stuff,
                                    completion: @escaping (Result<Stuff, Error>) -> Void)
    
    func storeUserData(_ user: User, completion: @escaping (Result<User, Error>) -> Void)
}

extension FirebaseService: FirebaseServiceStoreProtocol {
    
    func storeTripData(trip: Trip, completion: @escaping (Result<Trip, Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        var ref: DocumentReference = firebaseManager.firestore.collection("trips").document(userId)
            .collection("user_trips").document()
        if let id = trip.id {
            ref = firebaseManager.firestore.collection("trips").document(userId).collection("user_trips").document(id)
        }
        ref.setData(trip.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let trip = Trip(from: trip.toDictionary(), id: ref.documentID) {
                completion(.success(trip))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeRouteData(route: Route, completion: @escaping (Result<Route, Error>) -> Void) {
        var ref: DocumentReference = firebaseManager.firestore.collection("routes").document()
        if let id = route.id {
            ref = firebaseManager.firestore.collection("routes").document(id)
        }
        ref.setData(route.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let route = Route(from: route.toDictionary(), id: ref.documentID) {
                completion(.success(route))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeImage(image: UIImage, imageType: FirebaseStoreageImageType, completion: @escaping (Result<String, Error>) -> Void) {
        var ref = firebaseManager.storage.reference(withPath: "trips_images/\(UUID().uuidString)")
        if imageType == .avatar {
            guard let userId = firebaseManager.auth.currentUser?.uid else {
                return
            }
            ref = firebaseManager.storage.reference(withPath: "avatars/\(userId)")
        }
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
        let ref: DocumentReference = firebaseManager.firestore.collection("baggage").document(baggage.id)
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
        var ref: DocumentReference = firebaseManager.firestore.collection("baggage").document(baggageId)
            .collection("baggage_stuff").document()
        if let id = stuff.id {
            ref = firebaseManager.firestore.collection("baggage").document(baggageId)
                .collection("baggage_stuff").document(id)
        }
        ref.setData(stuff.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let stuff = Stuff(from: stuff.toDictionary(), id: ref.documentID) {
                completion(.success(stuff))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeStuffList(stuffList: StuffList,
                        completion: @escaping (Result<StuffList, Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        
        var ref: DocumentReference = firebaseManager.firestore.collection("stuff_lists").document(userId)
            .collection("user_stuff_lists").document()
        if let id = stuffList.id {
            ref = firebaseManager.firestore.collection("stuff_lists").document(userId)
                .collection("user_stuff_lists").document(id)
        }
        ref.setData(stuffList.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let stuffList = StuffList(from: stuffList.toDictionary(), id: ref.documentID) {
                completion(.success(stuffList))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeSertainStuffListStuff(stuff: Stuff,
                                    completion: @escaping (Result<Stuff, Error>) -> Void) {
        guard let userId = firebaseManager.auth.currentUser?.uid else {
            return
        }
        
        var ref: DocumentReference = firebaseManager.firestore.collection("stuff").document(userId)
            .collection("user_stuff").document()
        if let id = stuff.id {
            ref = firebaseManager.firestore.collection("stuff").document(userId)
                .collection("user_stuff").document(id)
        }
        ref.setData(stuff.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let stuff = Stuff(from: stuff.toDictionary(), id: ref.documentID) {
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

//enum FBModels {
//    case stuff
//    case stuffLists
//
//    func getCollectionsNames() -> [String] {
//        switch self {
//        case .stuff: return ["baggage", "baggage_stuff"]
//        case .stuffLists: return ["stuff_lists", "user_stuff_lists"]
//        }
//    }
//
//    func getModelType() -> FirebaseSaveable? {
//        switch self {
//        case .stuff: return Stuff() as? FirebaseSaveable
//        case .stuffLists: return StuffList() as? FirebaseSaveable
//        }
//    }
//}
//
//protocol FirebaseSaveable: Any {
//    init?(from dictionary: [String: Any], id: String)
//    func toDictionary() -> [String: Any]
//}
    
