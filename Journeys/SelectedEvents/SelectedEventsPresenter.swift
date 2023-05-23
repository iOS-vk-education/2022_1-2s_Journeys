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
    
    private let model: SelectedEventsModelInput
    init(view: SelectedEventsViewInput, model: SelectedEventsModelInput) {
        self.view = view
        self.model = model
    }

}

private extension SelectedEventsPresenter {
}

extension SelectedEventsPresenter: SelectedEventsViewOutput {
    func didTapCloseButton() {
        moduleOutput?.closeSelectedEvents()
    }
}

extension SelectedEventsPresenter: SelectedEventsModelOutput {
}
