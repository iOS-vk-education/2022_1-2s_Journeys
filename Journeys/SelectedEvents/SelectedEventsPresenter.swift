//
//  SelectedEventsPresenter.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation
import FirebaseFirestore

final class SelectedEventsPresenter {
    
    weak var  view: SelectedEventsViewInput?
    weak var moduleOutput: SelectedEventsModuleOutput?
    var eventViewObjects = [Event]()
    var image: UIImage?
    var imagesUrl: [String]?
    
    private let model: SelectedEventsModelInput
    init(view: SelectedEventsViewInput, model: SelectedEventsModelInput) {
        self.view = view
        self.model = model
    }
    
    private func loadData() {
        loadEvents()
    }
    
    func didLoadView() {
        loadData()
    }

}

private extension SelectedEventsPresenter {
    func loadEvents() {
        model.loadEvents { [weak self] result in
            switch result {
            case .success(let eventNetworkObjects):
                var eventViewObjects = [Event]()
                
                eventViewObjects = eventNetworkObjects.map { networkObject in
                    return Event(address: networkObject.address,
                          startDate: networkObject.startDate,
                          finishDate: networkObject.finishDate,
                          type: networkObject.type,
                          name: networkObject.name,
                          link: networkObject.link,
                          photoURL: networkObject.photoURL,
                          floor: networkObject.finishDate,
                          room: networkObject.room,
                          description: networkObject.description,
                          isLiked: networkObject.isLiked,
                          userID: networkObject.userID
                    )
                }
                
                self?.eventViewObjects = eventViewObjects
                self?.view?.reload()
            case .failure(let error): break
                self?.view?.show(error: error)
                
            }
        }
    }
    
    func loadImage(photoUrl: String) {
        model.loadImage(photoURL: photoUrl)
    }
}

extension SelectedEventsPresenter: SelectedEventsViewOutput {
    func didTapCloseButton() {
        moduleOutput?.closeSelectedEvents()
    }
    func displayingData() -> [Event]? {
        return eventViewObjects
    }
    
    func displayingCreatedEvent(for row: Int) -> FavoriteEventCell.DisplayData? {
        let event = eventViewObjects[row]
        loadImage(photoUrl: event.photoURL)
        let eventDisplayData = FavoriteEventCell.DisplayData(
            picture: UIImage(asset: Asset.Assets.noPhotoPlaceholder)!,
            startDate: event.startDate,
            endDate: event.finishDate,
            name: event.name,
            address: event.address,
            isInFavourites: event.isLiked,
            cellType: .created)
        return eventDisplayData
    }
}

extension SelectedEventsPresenter: SelectedEventsModelOutput {
    func didRecieveError(error: Errors) {
    }
    func didReciveImage(image: UIImage) {
        self.image = image
    }
}
