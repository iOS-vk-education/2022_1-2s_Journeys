//
//  EventsPresentor.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 08.04.2023.
//

import Foundation
import FirebaseFirestore

final class EventsPresenter {
    
    weak var  view: EventsViewInput?
    weak var moduleOutput: EventsModuleOutput?
    var lalitude: Double?
    var longitude: Double?
    var zoom: Float?
    
    private let model: EventsModelInput
    var addressViewObjects = [Address]()
    init(latitude: Double, longitude: Double, zoom: Float, view: EventsViewInput, model: EventsModelInput) {
        self.lalitude = latitude
        self.longitude = longitude
        self.zoom = zoom
        self.view = view
        self.model = model
    }
    
    private func loadData() {
        loadPlacemarks()
    }
    
    func displayMap() -> (Double?, Double?, Float?) {
        (lalitude, longitude, zoom)
    }
    
    func didLoadView() {
        loadData()
    }

}

private extension EventsPresenter {
    func loadPlacemarks() {
        model.loadPlacemarks { [weak self] result in
            switch result {
            case .success(let addressNetworkObjects):
                var addressViewObjects = [Address]()
                
                addressViewObjects = addressNetworkObjects.map { networkObject in
                    Address(
                        id: networkObject.id, coordinates: networkObject.coordinates
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
    func didTapScreen() {
        moduleOutput?.closeOpenSingleEventVCIfExists()
    }
    
    func didTapAddingButton() {
        moduleOutput?.wantsToOpenAddEventVC()
    }
    
    func didTapOnPlacemark(id: String) {
        moduleOutput?.wantsToOpenSingleEventVC(id: id)
    }

    func didTapFavouritesButton() {
        moduleOutput?.wantsToOpenSelectedEvents()
    }
}

extension EventsPresenter: EventsModelOutput {
    
}
