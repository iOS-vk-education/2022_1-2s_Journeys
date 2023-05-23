//
//  SelectedEventsModuleIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 22.05.2023.
//

import Foundation

// MARK: - Events ViewInput
protocol SelectedEventsModuleInput: AnyObject {
}

// MARK: - Events ViewOutput
protocol SelectedEventsModuleOutput: AnyObject {
    func closeSelectedEvents()
}
