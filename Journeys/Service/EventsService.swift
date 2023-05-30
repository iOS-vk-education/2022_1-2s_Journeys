//
//  EventsService.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 08.04.2023.
//

import Foundation
import FirebaseFirestore


protocol EventsServiceDescription {
    func loadPlacemarks(completion: @escaping (Result<[Address], Error>) -> Void)
    func storeAddingImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func storeAddingData(event: Event, coordinatesId: String, completion: @escaping (Result<Event, Error>) -> Void)
    func create(coordinates: Address, completion: @escaping (Result<Address, Error>) -> Void)
    func obtainEventData(eventId: String, completion: @escaping (Result<Event, Error>) -> Void)
    func obtainEventImage(for imageURLString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func loadEvents(completion: @escaping (Result<[Event], Error>) -> Void)
    func deleteEventData(eventId: String, completion: @escaping (Error?) -> Void)
    func deleteAddressData(eventId: String, completion: @escaping (Error?) -> Void)
    func setLike(eventId: String, event: Event, completion: @escaping (Error?) -> Void)
    func removeLike(eventId: String, completion: @escaping (Error?) -> Void)
    func checkLike(completion: @escaping (Result<[Event], Error>) -> Void)
    func loadLikedEvents(identifiers: [String], events: [Event], completion: @escaping (Result<[Event], Error>) -> Void)
    func deleteFavoritesData(eventId: String, completion: @escaping (Error?) -> Void)
    func storeEditingData(event: Event, completion: @escaping (Result<Event, Error>) -> Void)
    
}

enum EventsServiceError: Error {
    case noDocuments
}

final class EventsService: EventsServiceDescription {
    static let shared = EventsService()
    private let db = Firestore.firestore()
    let FBManager = FirebaseManager.shared
    
    private init() {
    }
    
    func storeAddingImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let ref = FBManager.storage.reference(withPath: "events/\(UUID().uuidString)")
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
                    completion(.failure(EventsServiceError.noDocuments))
                    return
                }
                completion(.success(url.absoluteString))
            }
        }
    }
    func storeAddingData(event: Event, coordinatesId: String, completion: @escaping (Result<Event, Error>) -> Void) {
        var ref: DocumentReference?
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        var eventWithUserID = event
        eventWithUserID.userID = userID
        ref = FBManager.firestore.collection("events").document(coordinatesId)
        ref?.setData(eventWithUserID.toDictionary(userID: userID)) { error in
            if let error = error {
                completion(.failure(error))
            } else if let eventService = Event(dictionary: event.toDictionary(userID: userID), userID: userID) {
                completion(.success(eventService))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func storeEditingData(event: Event, completion: @escaping (Result<Event, Error>) -> Void) {
        var ref: DocumentReference?
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        var eventWithUserID = event
        eventWithUserID.userID = userID
        ref = FBManager.firestore.collection("events").document(event.userID)
        ref?.setData(eventWithUserID.toDictionary(userID: userID)) { error in
            if let error = error {
                completion(.failure(error))
            } else if let eventService = Event(dictionary: event.toDictionary(userID: userID), userID: userID) {
                completion(.success(eventService))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    
    func loadPlacemarks(completion: @escaping (Result<[Address], Error>) -> Void) {
        db.collection("address").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(EventsServiceError.noDocuments))
                return
            }
            let events = documents.compactMap { Address(withDictionary: $0.data(), id: $0.documentID) }
            completion(.success(events))
        }
    }
    
    func loadEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        db.collection("events").whereField("userID", isEqualTo: userID).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(EventsServiceError.noDocuments))
                return
            }
            let events = documents.compactMap { Event(dictionary: $0.data(), userID: $0.documentID) }
            completion(.success(events))
        }
    }

    func create(coordinates: Address, completion: @escaping (Result<Address, Error>) -> Void) {
        var ref: DocumentReference?
        ref = db.collection("address").addDocument(data: coordinates.dict()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let id = ref?.documentID, let address = Address(withDictionary: coordinates.dict(), id: id) {
                completion(.success(address))
            } else {
                completion(.failure(EventsServiceError.noDocuments))
            }
        }
        
    }
    
    func obtainEventData(eventId: String, completion: @escaping (Result<Event, Error>) -> Void) {
        db.collection("events").document(eventId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                assertionFailure("Error while obtaining data")
                return
            }
            guard let data = document?.data() else {
                assertionFailure("No data found")
                return
            }
            guard let event = Event(dictionary: data, userID: "") else {
                completion(.failure(FBError.noData))
                return
            }
            
            completion(.success(event))
        }
    }
    
    func obtainEventImage(for imageURLString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
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
    
    func deleteEventData(eventId: String, completion: @escaping (Error?) -> Void) {
        FBManager.firestore.collection("events").document(eventId).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteAddressData(eventId: String, completion: @escaping (Error?) -> Void) {
        FBManager.firestore.collection("address").document(eventId).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteFavoritesData(eventId: String, completion: @escaping (Error?) -> Void) {
        var ref: DocumentReference?
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        db.collection("user_liked").document(userID).collection("likes").document(eventId).delete() { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func setLike(eventId: String, event: Event, completion: @escaping (Error?) -> Void) {
        var ref: DocumentReference?
        
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        ref = db.collection("user_liked").document(userID).collection("likes").document(eventId)
        ref?.setData(event.toDictionary(userID: eventId)) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func removeLike(eventId: String, completion: @escaping (Error?) -> Void) {
        var ref: DocumentReference?
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        FBManager.firestore.collection("user_liked").document(userID).collection("likes").document(eventId).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func checkLike(completion: @escaping (Result<[Event], Error>) -> Void) {
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        db.collection("user_liked").document(userID).collection("likes").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(EventsServiceError.noDocuments))
                return
            }
            let events = documents.compactMap { Event(dictionary: $0.data(), userID: $0.documentID) }
            completion(.success(events))
        }
    }
    
    func loadLikedEvents(identifiers: [String], events: [Event], completion: @escaping (Result<[Event], Error>) -> Void) {
        guard let userID = FBManager.auth.currentUser?.uid else {
            return
        }
        var likedEvents = events
        for id in identifiers {
            db.collection("events").document(id).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    assertionFailure("Error while obtaining data")
                    return
                }
                guard let data = document?.data() else {
                    assertionFailure("No data found")
                    return
                }
                guard let event = Event(dictionary: data, userID: id) else {
                    completion(.failure(FBError.noData))
                    return
                }
                likedEvents.append(event)
                completion(.success(likedEvents))
            }
        }
    }
}
