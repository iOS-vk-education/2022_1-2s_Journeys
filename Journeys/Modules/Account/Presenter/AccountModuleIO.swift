//
//  AccountModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/03/2023.
//

// MARK: - Account ModuleInput

protocol AccountModuleInput: AnyObject {
}

// MARK: - Account ModuleOutput

protocol AccountModuleOutput: AnyObject {
    func accountModuleWantsToOpenAccountInfoModule()
    func accountModuleWantsToOpenStuffListsModule()
    func accountModuleWantsToOpenSettingsModule()
}
