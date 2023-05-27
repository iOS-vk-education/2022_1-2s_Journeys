//
//  EventsViewIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 09.04.2023.
//

import Foundation

// MARK: - Events ViewInput
protocol EventsViewInput: AnyObject {
    func reload(points: [Address])
    func show(error: Error)
}

// MARK: - Events ViewOutput
protocol EventsViewOutput: AnyObject {
    func didTapAddingButton()
    func didLoadView()
    func didTapOnPlacemark(id: String)
    func displayMap() -> (Double?, Double?, Float?)
    func didTapScreen()
}