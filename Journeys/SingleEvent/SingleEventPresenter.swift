//
//  SingleEventPresenter.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//
import Foundation
import UIKit
import FirebaseFirestore

final class SingleEventPresenter {
    
    weak var  view: SingleEventViewInput?
    weak var moduleOutput: SingleEventModuleOutput?
    var id: String?
    var data: Event?
    var image: UIImage?
    var url: URL?
    var isLikedImage: Bool? = false
    var likesViewObjects = [Event]()
    private let model: SingleEventModelInput
    init(view: SingleEventViewInput, model: SingleEventModelInput, id: String) {
        self.view = view
        self.model = model
        self.id = id
    }
    private func loadData(id: String) {
        loadEvent(id: id)
    }
    
    func didLoadView() {
        guard let id = self.id else { return }
        loadData(id: id)
        isLiked()
    }

}

private extension SingleEventPresenter {
    func loadEvent(id: String) {
        model.loadEvent(eventId: id)
    }
}

extension SingleEventPresenter: SingleEventViewOutput {
    func isLiked() {
        model.checkLike { [weak self] result in
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
                self?.likesViewObjects = eventViewObjects
            case .failure(let error): break
                self?.view?.show(error: error)
                
            }
        }
    }

    func removeLike() {
        if let id = id {
            model.removeLike(eventId: id)
        }
    }
    
    func newLike() {
        if let id = id, let event = data {
            model.setLike(eventId: id, event: event)
        }
    }
    
    func displayingData() -> (Event?, Bool?) {
        checkLike()
        return (data, isLikedImage)
    }
    
    func displayImage() -> UIImage? {
        image
    }
    
    func checkLike() {
        let likes = likesViewObjects.compactMap { $0.userID }
        if let id = id {
            if likes.contains(id) {
                isLikedImage = true
            }
        }
    }
}

extension SingleEventPresenter: SingleEventModelOutput {
    func didReciveImage(image: UIImage) {
        self.image = image
        view?.reloadImage()
    }
    
    func didResiveLikeTrue() {
        self.isLikedImage = true
        view?.reload()
    }
    
    func didRecieveError(error: Errors) {
    }

    func didRecieveData(event: Event) {
        self.data = event
        view?.reload()
    }
}

