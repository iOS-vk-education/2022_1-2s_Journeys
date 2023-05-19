//
//  EventsService.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 08.04.2023.
//

import Foundation
import FirebaseFirestore


protocol EventsServiceDescription {
    func loadPlacemarks(completion: @escaping (Result<[Adress], Error>) -> Void)
    func storeAddingImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func storeAddingData(event: Event, coordinatesId: String, completion: @escaping (Result<Event, Error>) -> Void)
    func create(coordinates: Adress, completion: @escaping (Result<Adress, Error>) -> Void)

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
        ref = FBManager.firestore.collection("events").document()
        ref!.setData(event.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let id = ref?.documentID, let route = Event(dictionary: event.toDictionary(), id: coordinatesId) {
                completion(.success(route))
            } else {
                completion(.failure(FBError.noData))
            }
        }
    }
    func loadPlacemarks(completion: @escaping (Result<[Adress], Error>) -> Void) {
        db.collection("address").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(EventsServiceError.noDocuments))
                return
            }
            let events = documents.compactMap { Adress(dict: $0.data(), id: $0.documentID) }
            completion(.success(events))
        }
    }
    
    func create(coordinates: Adress, completion: @escaping (Result<Adress, Error>) -> Void) {
        var ref: DocumentReference?
        ref = db.collection("address").addDocument(data: coordinates.dict()) { error in
            if let error = error {
                completion(.failure(error))
            } else if let id = ref?.documentID, let adress = Adress(dict: coordinates.dict(), id: id) {
                completion(.success(adress))
                print(adress)
            } else {
                completion(.failure(EventsServiceError.noDocuments))
            }
        }
        
    }

}
