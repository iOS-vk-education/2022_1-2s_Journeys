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
        service.storeAddingImage(image: eventImage) { result in
            switch result {
            case .failure:
                self.output?.didRecieveError(error: Errors.saveDataError)
            case .success(let url):
                self.didStoreImageData(url: url, event: event, coordinatesId: coordinatesId)
            }
        }
    }

    func didStoreImageData(url: String, event: Event, coordinatesId: String) {
        let newEvent = Event(address: event.address,
                             startDate: event.startDate,
                             finishDate: event.finishDate,
                             type: event.type,
                             name: event.name,
                             link: event.link,
                             photoURL: url,
                             floor: event.floor,
                             room: event.room,
                             description: event.description,
                            isLiked: false,
                            userID: "")
        service.storeAddingData(event: newEvent, coordinatesId: coordinatesId) { result in
            switch result {
            case .failure:
                self.output?.didRecieveError(error: Errors.saveDataError)
            case .success(let eventModel):
                self.output?.didSaveAddingData(event: eventModel)
            }
        }
    }
    
    
func createStory(coordinates: Address, event: Event, eventImage: UIImage) {
        service.create(coordinates: coordinates) { result in
            switch result {
            case .success(let story):
                self.storeAddingData(event: event, eventImage: eventImage, coordinatesId: story.id)
            case .failure(let error): break
            }
        }
    }
}
