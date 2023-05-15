//
//  EventsPresentor.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 08.04.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

final class EventsPresenter {
    
    weak var  view: EventsViewInput?
    weak var moduleOutput: EventsModuleOutput?
    
    private let model: EventsModelInput
    var addressViewObjects = [AddressViewObjects]()
    private var viewObject: AddressViewObjects?
    init(view: EventsViewInput, model: EventsModelInput) {
        self.view = view
        self.model = model
    }
    
    private func loadData() {
        loadPlacemarks()
    }
    
    func didLoadView() {
        loadData()
    }
    
    
    func didTapSettingsButton() {
        print("Settings button was tapped")
    }
    
    func didTapFavouritesButton() {
        print("Favourites button was tapped")
    }

}

private extension EventsPresenter {
    func loadPlacemarks() {
        model.loadPlacemarks { [weak self] result in
            switch result {
            case .success(let addressNetworkObjects):
                var addressViewObjects = [AddressViewObjects]()
                
                addressViewObjects = addressNetworkObjects.map { networkObject in
                    AddressViewObjects(
                        coordinates: networkObject.coordinates
                    )
                }
                
                self?.addressViewObjects = addressViewObjects
                self?.view?.reload(points: addressViewObjects)
            case .failure(let error):
                self?.view?.show(error: error)
                
            }
        }
    }
}

extension EventsPresenter: EventsViewOutput {
    func viewDidLoad() {
        loadData()
    }
    
    
    func didTapAddingButton() {
        moduleOutput?.wantsToOpenAddEventVC()
    }
    
    func didTapOnPlacemark() {
        moduleOutput?.wantsToOpenSingleEventVC()
    }
}

extension EventsPresenter: EventsModelOutput {
    
}
