//
//  SelectedEventsViewIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation

// MARK: - Events ViewInput
protocol SelectedEventsViewInput: AnyObject {
}

// MARK: - Events ViewOutput
protocol SelectedEventsViewOutput: AnyObject {
    func didTapCloseButton()
}
