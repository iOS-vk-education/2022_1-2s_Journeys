//
//  CertainStuffModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 15.05.2023.
//

import Foundation

// MARK: - CertainStuffList ModelInput

protocol CertainStuffListModelInput: AnyObject {
    func obtainStuff(with ids: [String])
    func saveStuffList(_ stuffList: StuffList, stuff: [Stuff])
    func deleteStuffList(_ stuffList: StuffList, stuff: [Stuff])
}

// MARK: - CertainStuffList ModelOutput

protocol CertainStuffListModelOutput: AnyObject {
    func didReceiveStuff(_ stuff: [Stuff])
    func didReceiveError(_ error: Error)
    func didSaveStuffList(stuffList: StuffList, stuff: [Stuff])
    func didDeleteStuffList()
}
