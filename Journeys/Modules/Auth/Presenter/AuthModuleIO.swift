//
//  AuthModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 25/12/2022.
//

// MARK: - Auth ModuleInput

protocol AuthModuleInput: AnyObject {
}

// MARK: - Auth ModuleOutput

protocol AuthModuleOutput: AnyObject {
    func authModuleWantsToOpenTripsModule()
    func authModuleWantsToChangeModulenType(currentType: AuthPresenter.ModuleType)
}
