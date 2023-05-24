//
//  TripInfoModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

// MARK: - TripInfo ModuleInput

protocol TripInfoModuleInput: AnyObject {
}

// MARK: - TripInfo ModuleOutput

protocol TripInfoModuleOutput: AnyObject {
    func tripInfoModuleWantsToClose()
    func openEventsModule(with coordinates: Coordinates)
    func openAddStuffListModule(baggage: Baggage, stuffModuleInput: StuffModuleInput)
}
