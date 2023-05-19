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
//MARK: - private functions
//MARK: - functions
    func storeAddingData(event: Event, eventImage: UIImage, coordinatesId: String) {
        service.storeAddingImage(image: eventImage) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output?.didRecieveError(error: Errors.saveDataError)
            case .success(let url):
                strongSelf.didStoreImageData(url: url, event: event, coordinatesId: coordinatesId)
            }
        }
    }

    func didStoreImageData(url: String, event: Event, coordinatesId: String) {
        let newEvent = Event(id: coordinatesId,
                             adress: event.adress,
                             startDate: event.startDate,
                             finishDate: event.finishDate,
                             type: event.type,
                             name: event.name,
                             link: event.link,
                             floor: event.floor,
                             room: event.room,
                             photoURL: url,
                             description: event.description,
                            isLiked: false)
        service.storeAddingData(event: newEvent, coordinatesId: coordinatesId) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure:
                strongSelf.output?.didRecieveError(error: Errors.saveDataError)
            case .success(let event):
                strongSelf.output?.didSaveAddingData(event: event)
            }
        }
    }
    
    
func createStory(coordinates: Adress, event: Event, eventImage: UIImage) {
        service.create(coordinates: coordinates) { result in
            switch result {
            case .success(let story):
                self.storeAddingData(event: event, eventImage: eventImage, coordinatesId: story.id)
            case .failure(let error): break
                //completion(.failure(error))
            }
        }
    }
}