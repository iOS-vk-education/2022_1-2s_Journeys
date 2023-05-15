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
    func saveData(post: Event, coordinates: GeoPoint, eventImage: UIImage) {
        model.storeAddingData(event: post, eventImage: eventImage ?? UIImage(asset: Asset.Assets.tripsPlaceholder)!, coordinatesId: "jdjd")
        
        model.createStory(coordinates: coordinates) { [weak self] result in
            switch result {
            case .success(let coord):
                self?.storyViewObjects.append(.init(coordinates: (coordinates)))
            case .failure(let error):
                self?.view?.showAlert1(title: L10n.error, message: "Ошибка при заполнении данных. Выйдите и попробуйте еще раз")
            }
        }
    }
    func openEventsVC() {
        moduleOutput?.wantsToOpenEventsVC()
    }
    func backToSuggestionVC() {
        moduleOutput?.backToSuggestionVC()
    }
}

extension AddingPresenter: AddingModelOutput {
    func didSaveAddingData(event: Event) {
    }
    
    func didStoreImageData(url: String, event: Event) {
    }
    
    func didSaveData(address: Adress, event: Event) {
    }
    
    func didRecieveError(error: Errors) {
    }
    
}
