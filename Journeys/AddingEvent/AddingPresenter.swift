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
    private let model: AddingModelInput
    var storyViewObjects = [AddressViewObjects]()
    init(view: AddingViewInput, model: AddingModelInput) {
        self.view = view
        self.model = model
    }
    
}

private extension AddingPresenter {
    
}

extension AddingPresenter: AddingViewOutput {
    func saveData(post: Event, coordinates: Adress, eventImage: UIImage) {
        model.createStory(coordinates: coordinates, event: post, eventImage: eventImage ?? UIImage(asset: Asset.Assets.tripsPlaceholder)!)
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
    
    func didSaveData(address: Adress, event: Event) {
    }
    
    func didRecieveError(error: Errors) {
    }
    
}
