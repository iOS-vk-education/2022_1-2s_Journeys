//
//  AddingModel.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 09.04.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

// MARK: - RouteModel

final class AddingModel {
    weak var output: AddingModelOutput?
    private let service: EventsServiceDescription = EventsService.shared

}

extension AddingModel: AddingModelInput {

    func storeAddingData(event: Event, eventImage: UIImage, coordinatesId: String) {
        service.storeAddingImage(image: eventImage) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output?.didRecieveError(error: Errors.saveDataError)
            case .success(let url):
                strongSelf.didStoreImageData(url: url, event: event)
            }
        }
    }

    func didStoreImageData(url: String, event: Event) {
        let newEvent = Event(id: event.id,
                             adress: event.adress,
                             startDate: event.startDate,
                             finishDate: event.finishDate,
                             type: event.type,
                             name: event.name,
                             link: event.link,
                             floor: event.floor,
                             room: event.room,
                             photoURL: url,
                             description: event.description)
        service.storeAddingData(event: newEvent) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output?.didRecieveError(error: Errors.saveDataError)
            case .success(let event):
                strongSelf.output?.didSaveAddingData(event: event)
            }
        }
    }
    
    func createStory(coordinates: GeoPoint, completion: @escaping (Result<Adress, Error>) -> Void) {
        service.create(coordinates: CreateAdressData(coordinates: coordinates)) { result in
            switch result {
            case .success(let story):
                completion(.success(story))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
