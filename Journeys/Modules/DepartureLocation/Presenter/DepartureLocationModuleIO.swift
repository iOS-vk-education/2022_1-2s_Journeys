//
//  DepartureLocationModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 22/11/2022.
//

// MARK: - DepartureLocation ModuleInput

protocol DepartureLocationModuleInput: AnyObject {
}

// MARK: - DepartureLocation ModuleOutput

protocol DepartureLocationModuleOutput: AnyObject {
    func departureLocationModuleWantsToClose()
}
