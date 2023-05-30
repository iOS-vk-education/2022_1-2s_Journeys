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
    var likesDataObjects = [Event]()
    var createdData = [FavoriteEventCell.DisplayData]()
    var favoritesData = [FavoriteEventCell.DisplayData]()
    
    private let model: SelectedEventsModelInput
    init(view: SelectedEventsViewInput, model: SelectedEventsModelInput) {
        self.view = view
        self.model = model
    }
    
    private func loadData() {
        loadLikedEvents()
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
                          floor: networkObject.floor,
                          room: networkObject.room,
                          description: networkObject.description,
                          isLiked: networkObject.isLiked,
                          userID: networkObject.userID
                    )
                }
                self?.eventViewObjects = eventViewObjects
                if let eventObjects = self?.eventViewObjects {
                    var objects = [FavoriteEventCell.DisplayData]()
                    for item in eventObjects {
                        objects.append(FavoriteEventCell.DisplayData(picture: nil,
                                                                     startDate: item.startDate,
                                                                     endDate: item.finishDate,
                                                                     name: item.name,
                                                                     address: item.address,
                                                                     isInFavourites: true,
                                                                     cellType: .created))
                    }
                    self?.createdData = objects
                }
                self?.loadImagesCreated()
                self?.view?.reloadCreated()
            case .failure(let error): break
                self?.view?.show(error: error)
                
            }
        }
    }
    
    func loadLikedEvents() {
        model.checkLike { [weak self] result in
            switch result {
            case .success(let eventNetworkObjects):
                var likesDataObjects = [Event]()
                
                likesDataObjects = eventNetworkObjects.map { networkObject in
                    return Event(address: networkObject.address,
                          startDate: networkObject.startDate,
                          finishDate: networkObject.finishDate,
                          type: networkObject.type,
                          name: networkObject.name,
                          link: networkObject.link,
                          photoURL: networkObject.photoURL,
                          floor: networkObject.floor,
                          room: networkObject.room,
                          description: networkObject.description,
                          isLiked: networkObject.isLiked,
                          userID: networkObject.userID
                    )
                }
                self?.likesDataObjects = likesDataObjects
                if let likeObjects = self?.likesDataObjects {
                    var objects = [FavoriteEventCell.DisplayData]()
                    for item in likeObjects {
                        objects.append(FavoriteEventCell.DisplayData(picture: nil,
                                                                     startDate: item.startDate,
                                                                     endDate: item.finishDate,
                                                                     name: item.name,
                                                                     address: item.address,
                                                                     isInFavourites: true,
                                                                     cellType: .favoretes))
                    }
                    self?.favoritesData = objects
                }
                self?.loadImagesFavorites()
                self?.view?.reloadFavorites()
            case .failure(let error): break
                self?.view?.show(error: error)
                
            }
        }
    }
}

extension SelectedEventsPresenter: SelectedEventsViewOutput {
    
    func didswitshOnFavoretes() {
        loadLikedEvents()
    }
    
    func didSwitshOnCreated() {
        loadCreatedEvents()
    }
    
    func loadImagesCreated() {
        for index in 0..<createdData.count {
            model.loadImage(for: eventViewObjects[index]) { [weak self] image in
                guard let self else { return }
                self.createdData[index].picture = image
                guard self.eventViewObjects.count > index else { return }
                self.view?.reloadCreated()
            }
        }
    }
    
    func loadImagesFavorites() {
        for index in 0..<favoritesData.count {
            model.loadImage(for: likesDataObjects[index]) { [weak self] image in
                guard let self else { return }
                self.favoritesData[index].picture = image
                guard self.likesDataObjects.count > index else { return }
                self.view?.reloadFavorites()
            }
        }
    }

    func didTapScreen() {
        moduleOutput?.closeOpenSingleEventVCIfExists()
    }
    
    func didTapFavoriteCell(at: IndexPath) {
        let eventId = likesDataObjects[at.section].userID
        moduleOutput?.wantsToOpenSingleEventVC(id: eventId)
    }
    
    func didTapCreatedCell(at: IndexPath) {
        let eventId = eventViewObjects[at.section].userID
        moduleOutput?.wantsToOpenSingleEventVC(id: eventId)
    }
    
    func didTapLikeButton(at: IndexPath) {
        let eventId = likesDataObjects[at.section].userID
        switch favoritesData[at.section].isInFavourites {
        case true:
            model.deleteLike(eventId: eventId)
            loadLikedEvents()
        case false:
            model.setLike(eventId: eventId, event: likesDataObjects[at.section])
        }
        favoritesData[at.section].isInFavourites = !favoritesData[at.section].isInFavourites
        model.deleteLike(eventId: eventId)
    }
    
    func didTapEditingButton(at: IndexPath) {
        moduleOutput?.wantsToOpenEditingVC(event: eventViewObjects[at.section], image: createdData[at.section].picture)
    }
    
    func countOfFavorites() -> Int {
        favoritesData.count
    }
    
    func countOfCreated() -> Int {
        createdData.count
    }
    
    func didSelectAgreeAlertAction(cellIndexPath: IndexPath) {
        let eventId = eventViewObjects[cellIndexPath.section].userID
        model.deleteEvent(eventId: eventId)
    }
    
    func didTapDeleteButton(at: IndexPath) {
        view?.showChoiceAlert(title: L10n.deleteAnEvent, message: L10n.deleteAgree, agreeActionTitle: "Да", disagreeActionTitle: "Нет", cellIndexPath: at)
    }
    
    func didTapCloseButton() {
        moduleOutput?.closeSelectedEvents()
    }
    
    func displayingCreatedEvent(for row: Int, cellType: FavoriteEventCell.CellType) -> FavoriteEventCell.DisplayData? {
        var event: FavoriteEventCell.DisplayData
        if cellType == .created {
            event = createdData[row]
        } else {
            event = favoritesData[row]
        }
            return event
    }
}

extension SelectedEventsPresenter: SelectedEventsModelOutput {
    func didRemoveLike() {
    }
    
    func didRecieveError(error: Errors) {
    }

    func didReciveImage(image: UIImage) {
        
    }

    func didDeleteEvent() {
        loadCreatedEvents()
    }
}
