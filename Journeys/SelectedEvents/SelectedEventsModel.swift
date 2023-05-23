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
}
