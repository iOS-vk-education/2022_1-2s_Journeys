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
    private let model: SingleEventModelInput
    var addressViewObjects = [Event]()
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
    func displayingData() -> Event? {
        return data
    }
    
    func displayImage() -> UIImage? {
        return image
    }
}

extension SingleEventPresenter: SingleEventModelOutput {
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

