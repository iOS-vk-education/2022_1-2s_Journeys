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
    
    weak var  view: AddingViewInput?
    weak var moduleOutput: AddingModuleOutput?
    var coordinates: GeoPoint?
    var address: String?
    var eventImage: UIImage?
    private let model: AddingModelInput
    init(view: AddingViewInput, model: AddingModelInput, coordinates: GeoPoint?, address: String?) {
        self.view = view
        self.model = model
        self.address = address
        self.coordinates = coordinates
    }
    
    func displayAddress() -> String? {
        return address
    }
    
}

private extension AddingPresenter {
    
}

extension AddingPresenter: AddingViewOutput {
    func imageFromView(image: UIImage?) {
        self.eventImage = image
    }
    func saveData(post: Event) {
        guard let coordinates = coordinates else { return }
        let eventCoordinates = Address.init(id: "", coordinates: coordinates)
        guard let placeholderImage =  UIImage(asset: Asset.Assets.noPhotoPlaceholder) else { return }
        model.createStory(coordinates: eventCoordinates, event: post, eventImage: eventImage ?? placeholderImage)
    }
    func openEventsVC() {
        moduleOutput?.wantsToOpenEventsVC()
    }
    func backToSuggestionVC() {
        moduleOutput?.backToSuggestionVC()
    }
}

extension AddingPresenter: AddingModelOutput {
    func didStoreImageData(url: String, event: Event, coordinatesId: String) {
    }
    
    func didSaveAddingData(event: Event) {
    }
    
    func didSaveData(address: Address, event: Event) {
    }
    
    func didRecieveError(error: Errors) {
    }
    
}
