//
//  StuffModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

import Foundation

// MARK: - StuffModel

final class StuffModel {
    weak var output: StuffModelOutput!
    private let firebaseService: FirebaseServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
    
    private func saveBaggage(_ baggage: Baggage, completion: @escaping (Baggage) -> Void) {
        firebaseService.storeBaggageData(baggage: baggage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output.didRecieveError(.saveDataError)
            case .success(let savedBaggage):
                completion(savedBaggage)
            }
        }
    }
    
    private func saveStuff(_ stuff: Stuff, baggageId: String, completion: @escaping (Stuff) -> Void) {
        firebaseService.storeStuffData(baggageId: baggageId, stuff: stuff) {[weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output.didRecieveError(.saveDataError)
            case .success(let savedStuff):
                completion(savedStuff)
            }
            
        }
    }
}

extension StuffModel: StuffModelInput {
    func changeStuffIsPackedFlag(stuff: Stuff, baggage: Baggage, indexPath: IndexPath) {
        guard let stuffId = stuff.id else { return }
        guard let index = baggage.stuffIDs.firstIndex(of: stuffId) else {
            output.didRecieveError(.deleteDataError)
            return
        }
        var newBagagge: Baggage = baggage
        newBagagge.stuffIDs.remove(at: index)
        newBagagge.stuffIDs.append(stuffId)
        
        saveBaggage(newBagagge) { [weak self] savedBaggage in
            guard let self else { return }
            self.continueChangingStuffStatus(stuff: stuff, baggage: savedBaggage, indexPath: indexPath)
        }
    }
    
    func saveChangedStuff(stuff: Stuff, baggage: Baggage, indexPath: IndexPath) {
        saveStuff(stuff, baggageId: baggage.id) {  [weak self] savedStuff in
            guard let self else { return }
            if stuff.id == nil,
               let savedStuffId = savedStuff.id {
                var newBagagge = baggage
                newBagagge.stuffIDs.append(savedStuffId)
                print(savedStuffId)
                self.saveBaggage(newBagagge) { savedBagagge in
                    self.output.didSaveStuff(stuff: savedStuff, baggage: savedBagagge, indexPath: indexPath)
                }
            }
        }
    }
    
    func continueChangingStuffStatus(stuff: Stuff, baggage: Baggage, indexPath: IndexPath) {
        saveStuff(stuff, baggageId: baggage.id) { [weak self] savedStuff in
            guard let self else { return }
            self.output.didChangeStuffStatus(stuff: savedStuff, indexPath: indexPath)
        }
    }
    
    func deleteStuff(baggage: Baggage, stuffId: String) {
        guard let index = baggage.stuffIDs.firstIndex(of: stuffId) else {
            output.didRecieveError(.deleteDataError)
            return
        }
        var newBagagge: Baggage = baggage
        newBagagge.stuffIDs.remove(at: index)
        saveBaggage(newBagagge) {[weak self] savedBaggage in
            guard let self else { return }
            self.stuffIdWasDeletedFromBaggage(stuffId: stuffId, baggageId: savedBaggage.id)
        }
    }
    
    func stuffIdWasDeletedFromBaggage(stuffId: String, baggageId: String) {
        firebaseService.deleteStuffData(stuffId, baggageId: baggageId) { [weak self] error in
            guard let self else { return }
            if error != nil {
                self.output.didRecieveError(.deleteDataError)
            } else {
                self.output.didDeleteStuff()
            }
        }
    }
    
    func obtainData(baggageId: String) {
        firebaseService.obtainBaggageData(baggageId: baggageId) { [weak self]  result in
               guard let self else { return }
               switch result {
               case .failure:
                   self.output.didRecieveError(.obtainDataError)
               case .success(let baggage):
                   self.obtainStuffData(baggage: baggage)
               }
        }
    }
    
    func obtainStuffData(baggage: Baggage) {
        firebaseService.obtainBaggage(baggageId: baggage.id) { [weak self]  result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output.didRecieveError(.obtainDataError)
            case .success(let stuff):
                self.output.didRecieveData(stuff: stuff, baggage: baggage)
            }
        }
    }
}
