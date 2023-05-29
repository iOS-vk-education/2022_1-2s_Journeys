//
//  AddingPresenter.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 15.04.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

final class AddingPresenter {
    
    enum ModuleType {
        case adding
        case editing
    }
    
    weak var  view: AddingViewInput?
    weak var moduleOutput: AddingModuleOutput?
    var coordinates: GeoPoint?
    var address: String?
    var eventImage: UIImage?
    var image: UIImage?
    var event: Event?
    private var moduleType: ModuleType
    private let model: AddingModelInput
    init(view: AddingViewInput, model: AddingModelInput, coordinates: GeoPoint?, address: String?, event: Event?, moduleType: ModuleType, image: UIImage?) {
        self.view = view
        self.model = model
        self.address = address
        self.coordinates = coordinates
        self.event = event
        self.moduleType = moduleType
        self.image = image
    }
    
    func displayAddress() -> String? {
        return address
    }
    
    func displayEvent() -> Event? {
        return event
    }
    
}

private extension AddingPresenter {
    
}

extension AddingPresenter: AddingViewOutput {
    func getImage() -> UIImage? {
        return image
    }
    
    func getTitle() -> String {
        switch moduleType {
        case .adding:
            return L10n.createEvent
        case .editing:
            return "Редактирование мероприятия"
        }
    }
    
    func imageFromView(image: UIImage?) {
        self.eventImage = image
    }
    func saveData(post: Event) {
        switch moduleType {
        case .adding:
            guard let coordinates = coordinates else { return }
            let eventCoordinates = Address.init(id: "", coordinates: coordinates)
            guard let placeholderImage =  UIImage(asset: Asset.Assets.noPhotoPlaceholder) else { return }
            model.createStory(coordinates: eventCoordinates, event: post, eventImage: eventImage ?? placeholderImage)
        case .editing: return
        }
    }
    func backToSuggestionVC() {
        moduleOutput?.backToSuggestionVC()
    }
}

extension AddingPresenter: AddingModelOutput {
    func didStoreImageData(url: String, event: Event, coordinatesId: String) {
    }
    
    func didSaveAddingData(event: Event) {
        switch moduleType {
        case .adding:
            moduleOutput?.wantsToOpenEventsVC()
        case .editing:
            moduleOutput?.backToSuggestionVC()
        }
        
    }
    
    func didSaveData(address: Address, event: Event) {
    }
    
    func didRecieveError(error: Errors) {
    }
    
}
