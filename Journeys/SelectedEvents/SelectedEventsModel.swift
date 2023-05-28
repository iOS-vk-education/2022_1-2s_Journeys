//
//  SelectedEventsModel.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation
import UIKit

final class SelectedEventsModel {
    private let service: EventsServiceDescription = EventsService.shared
    weak var output: SelectedEventsModelOutput?
}

extension SelectedEventsModel: SelectedEventsModelInput {
    func loadEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        service.loadEvents { result in
            completion(result)
        }
    }
    
    func loadImage(photoURL: String) {
        service.obtainEventImage(for: photoURL) { [weak self]  result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output?.didRecieveError(error: .obtainDataError)
            case .success(let image):
                self.output?.didReciveImage(image: image)
            }
        }
    }
    
}
