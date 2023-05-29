//
//  SingleEventModel.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//


import Foundation
import UIKit

final class SingleEventModel {
    private let service: EventsServiceDescription = EventsService.shared
    weak var output: SingleEventModelOutput?
}

extension SingleEventModel: SingleEventModelInput {
    func checkLike(completion: @escaping (Result<[FavoritesEvent], Error>) -> Void) {
        service.checkLike { result in
            completion(result)
        }
    }
    
    func setLike(eventId: String) {
        service.setLike(eventId: eventId)  { [weak self]  error in
            guard let self else { return }
            if error != nil {
                self.output?.didRecieveError(error: .deleteDataError)
            }
        }
    }
    
    func removeLike(eventId: String) {
        service.removeLike(eventId: eventId)  { [weak self]  error in
            guard let self else { return }
            if error != nil {
                self.output?.didRecieveError(error: .deleteDataError)
            }
        }
    }
    
    func loadEvent(eventId: String) {
        service.obtainEventData(eventId: eventId) { [weak self]  result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output?.didRecieveError(error: .obtainDataError)
            case .success(let event):
                self.output?.didRecieveData(event: event)
                self.loadImage(photoURL: event.photoURL)
            }
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
}
