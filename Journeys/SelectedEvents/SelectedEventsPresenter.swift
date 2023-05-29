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
    var likesViewObjects = [FavoritesEvent]()
    var likesDataObjects = [Event]()
    
    var image: UIImage?
    var imagesUrl: [String]?
    
    private let model: SelectedEventsModelInput
    init(view: SelectedEventsViewInput, model: SelectedEventsModelInput) {
        self.view = view
        self.model = model
    }
    
    private func loadData() {
        likesDataObjects = []
        loadCreatedEvents()
        loadDataLikedEvents()
        
    }
    
    func didLoadView() {
        loadData()
    }

}

private extension SelectedEventsPresenter {
    func loadCreatedEvents() {
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
                self?.loadDataLikedEvents()
                self?.eventViewObjects = eventViewObjects
            case .failure(let error): break
                self?.view?.show(error: error)
                
            }
        }
    }
    
    func loadLikedEvents() {
        model.checkLike { [weak self] result in
            switch result {
            case .success(let addressNetworkObjects):
                var likesViewObjects = [FavoritesEvent]()
                
                likesViewObjects = addressNetworkObjects.map { networkObject in
                    FavoritesEvent(
                        id: networkObject.id
                    )
                }
                
                self?.likesViewObjects = likesViewObjects
            case .failure(let error):
                self?.view?.show(error: error)
                
            }
        }

    }
    
    func loadDataLikedEvents() {
        self.loadLikedEvents()
        let likes = likesViewObjects.compactMap { $0.id }
        likesDataObjects = []
        model.loadLikedEvents(identifiers: likes, events: likesDataObjects) { [weak self] result in
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
                                 isLiked: true,
                                 userID: networkObject.userID
                    )
                }
                
                self?.likesDataObjects = eventViewObjects
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
    func refreshView() {
        didLoadView()
    }
    
    func didTapLikeButton(at: IndexPath) {
        let eventId = likesDataObjects[at.section].userID
        switch likesDataObjects[at.section].isLiked {
        case true:
            model.deleteLike(eventId: eventId)
        case false:
            model.setLike(eventId: eventId)
        }
        likesDataObjects[at.section].isLiked = !likesDataObjects[at.section].isLiked
        model.deleteLike(eventId: eventId)
    }
    
    func countOfFavorites() -> Int {
        likesDataObjects.count
    }
    
    func countOfCreated() -> Int {
        eventViewObjects.count
    }
    
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath) {
        let eventId = eventViewObjects[cellIndexPath.section].userID
        model.deleteEvent(eventId: eventId)
    }
    
    func didTapDeleteButton(at: IndexPath) {
        view?.showChoiceAlert(title: "Удалить маршрут", message: "Вы уверены, что хотите удалиь маршрут?", agreeActionTitle: "Да", disagreeActionTitle: "Нет", cellIndexPath: at)
    }
    
    func didTapCloseButton() {
        moduleOutput?.closeSelectedEvents()
    }
    func displayingData() -> [Event]? {
        return eventViewObjects
    }
    
    func displayingCreatedEvent(for row: Int, cellType: FavoriteEventCell.CellType) -> FavoriteEventCell.DisplayData? {
        var event: Event
        if cellType == .created {
            event = eventViewObjects[row]
        } else {
            event = likesDataObjects[row]
        }
        loadImage(photoUrl: event.photoURL)
        let eventDisplayData = FavoriteEventCell.DisplayData(
            picture: UIImage(asset: Asset.Assets.noPhotoPlaceholder)!,
            startDate: event.startDate,
            endDate: event.finishDate,
            name: event.name,
            address: event.address,
            isInFavourites: true,
            cellType: cellType)
        return eventDisplayData
    }
}

extension SelectedEventsPresenter: SelectedEventsModelOutput {
    func didRemoveLike() {
    }
    
    func didRecieveError(error: Errors) {
    }

    func didReciveImage(image: UIImage) {
        self.image = image
    }

    func didDeleteEvent() {
        didLoadView()
    }
}
