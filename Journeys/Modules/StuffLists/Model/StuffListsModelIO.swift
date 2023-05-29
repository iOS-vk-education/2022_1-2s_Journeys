//
//  StuffListsModelIO.swift
//  Journeys
//
//  Created by Сергей Адольевич on 07.05.2023.
//

import Foundation

// MARK: - StuffLists ModelInput

protocol StuffListsModelInput: AnyObject {
    func obtainStuffLists()
    func addStuffListToBaggage(baggage: Baggage,
                               stuffList: StuffList,
                               completion: @escaping (Baggage) -> Void)
    func deleteStuffListFromBaggage(baggage: Baggage,
                                    stuffList: StuffList,
                                    completion: @escaping (Baggage) -> Void)
}

// MARK: - StuffLists ModelOutput

protocol StuffListsModelOutput: AnyObject {
    func didReceiveStuffLists(_ stuffLists: [StuffList])
    func didReceiveError(_ error: Errors)
    func nothingToAdd()
}
