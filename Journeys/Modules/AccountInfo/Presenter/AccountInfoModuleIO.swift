//
//  AccountInfoModuleIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/12/2022.
//

// MARK: - AccountInfo ModuleInput

protocol AccountInfoModuleInput: AnyObject {
}

// MARK: - Account ModuleOutput

protocol AccountInfoModuleOutput: AnyObject {
    func accountInfoModuleWantToBeClosed()
}
