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
}

enum EventsServiceError: Error {
    case noDocuments
}

final class EventsService: EventsServiceDescription {
    static let shared = EventsService()
    private let db = Firestore.firestore()
    private init() {
    }
    func loadPlacemarks(completion: @escaping (Result<[Adress], Error>) -> Void) {
        db.collection("Address").getDocuments { querySnapshot, error in
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
}
