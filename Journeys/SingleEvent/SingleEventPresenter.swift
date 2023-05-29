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
    var likesViewObjects = [FavoritesEvent]()
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
    
    func userTapLink() {
        guard let link = data?.link else { return }
        guard let url = URL(string: link) else { return }
        moduleOutput?.wantsToOpenLink(link: url)
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

    func removeLike() {
        if let id = id {
            model.removeLike(eventId: id)
        }
    }
    
    func newLike() {
        if let id = id {
            model.setLike(eventId: id)
        }
    }
    
    func displayingData() -> (Event?, Bool?) {
        checkLike()
        return (data, isLikedImage)
    }
    
    func displayImage() -> UIImage? {
        return image
    }
    
    func checkLike() {
        let likes = likesViewObjects.compactMap { $0.id }
        if let id = id {
            if likes.contains(id) {
                isLikedImage = true
            }
        }
    }
}

extension SingleEventPresenter: SingleEventModelOutput {
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

    func didReciveImage(image: UIImage) {
        self.image = image
        view?.reloadImage()
    }
}

