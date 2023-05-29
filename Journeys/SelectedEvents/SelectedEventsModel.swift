//
//  SelectedEventsModel.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation
import UIKit

final class SelectedEventsModel {
    private let service: EventsServiceDescription = EventsService.shared
    weak var output: SelectedEventsModelOutput?
}

extension SelectedEventsModel: SelectedEventsModelInput {
    func setLike(eventId: String) {
        service.setLike(eventId: eventId)  { [weak self]  error in
            guard let self else { return }
            if error != nil {
                self.output?.didRecieveError(error: .deleteDataError)
            }
        }
    }
    
    func deleteLike(eventId: String) {
        service.removeLike(eventId: eventId)  { [weak self]  error in
            guard let self else { return }
            if error != nil {
                self.output?.didRecieveError(error: .deleteDataError)
            } else {
                self.output?.didRemoveLike()
            }
        }
    }
    
    func loadLikedEvents(identifiers: [String], events: [Event], completion: @escaping (Result<[Event], Error>) -> Void) {
        service.loadLikedEvents(identifiers: identifiers, events: events) { result in
            completion(result)
        }
    }
    
    func checkLike(completion: @escaping (Result<[FavoritesEvent], Error>) -> Void) {
        service.checkLike { result in
            completion(result)
        }
    }

    func loadEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        service.loadEvents { result in
            completion(result)
        }
    }

    func loadImage(photoURL: String) {
        service.obtainEventImage(for: photoURL) { [weak self]  result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output?.didRecieveError(error: .obtainDataError)
            case .success(let image):
                self.output?.didReciveImage(image: image)
            }
        }
    }

    func deleteEvent(eventId: String) {
        service.deleteEventData(eventId: eventId) { [weak self]  error in
            guard let self else { return }
            if error != nil {
                self.output?.didRecieveError(error: .deleteDataError)
            } else {
                self.output?.didDeleteEvent()
            }
        }
        service.deleteAddressData(eventId: eventId) { [weak self]  error in
            guard let self else { return }
            if error != nil {
                self.output?.didRecieveError(error: .deleteDataError)
            }
        }
    }
}
