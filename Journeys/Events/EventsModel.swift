//
//  EventsModel.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 08.04.2023.
//

import Foundation
import UIKit

final class EventsModel {
    private let service: EventsServiceDescription = EventsService.shared
    weak var output: EventsModelOutput?
}

extension EventsModel: EventsModelInput {
    func loadPlacemarks(completion: @escaping (Result<[Address], Error>) -> Void) {
        service.loadPlacemarks { result in
            completion(result)
        }
    }
}
