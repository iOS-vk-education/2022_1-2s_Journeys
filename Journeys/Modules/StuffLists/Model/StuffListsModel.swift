//
//  StuffListsModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import Foundation

// MARK: - StuffListsModel

final class StuffListsModel {
    weak var output: StuffListsModelOutput?
    private let firebaseService: FirebaseServiceProtocol
    
    private let dataLoadQueue = DispatchQueue.global()
    private let dataLoadDispatchGroup = DispatchGroup()
    private var didReceiveErrorWhileObtainingData: Bool = false
    
    private let dataSaveQueue = DispatchQueue(label: "ru.Journeys.StuffListsModel.dataSaveQueue")
    
    private let dataDeleteQueue = DispatchQueue.global()
    private let dataDeleteDispatchGroup = DispatchGroup()
    private var didReceiveErrorWhileDeletingData: Bool = false
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
}

extension StuffListsModel: StuffListsModelInput {
    func obtainStuffLists() {
        firebaseService.obtainStuffLists { [weak self] result in
            switch result {
            case .failure(let error):
                self?.output?.didReceiveError(error)
            case .success(let stuffLists):
                self?.output?.didReceiveStuffLists(stuffLists)
            }
        }
    }
    
    func addStuffListToBaggage(baggage: Baggage,
                               stuffList: StuffList,
                               completion: @escaping (Baggage) -> Void) {
        var newBaggage = baggage
        guard let stuffListId = stuffList.id else { return }
        newBaggage.addedStuffListsIDs.append(stuffListId)
        
        let baggageStuffIDsSet = Set(baggage.stuffIDs)
        let stuffListStuffIDsSet = Set(stuffList.stuffIDs)
        let substractedStuffIDs = Array(stuffListStuffIDsSet.subtracting(baggageStuffIDsSet))
        
        if substractedStuffIDs.count == 0 {
            output?.nothingToAdd()
        }
        
        newBaggage.stuffIDs.append(contentsOf: substractedStuffIDs)
//        dataLoadQueue.async { [weak self] in
            self.obtainStuffListStuff(with: substractedStuffIDs) { [weak self] stuffListStuff in
                self?.saveBaggage(newBaggage) { [weak self] savedBagagge in
                    stuffListStuff.forEach { curStuffListStuff in
                        self?.saveStuff(curStuffListStuff, baggageId: savedBagagge.id) { _ in
                            completion(savedBagagge)
                        }
                    }
                }
//            }
        }
    }
    
    private func saveBaggage(_ baggage: Baggage, completion: @escaping (Baggage) -> Void) {
//        dataSaveQueue.async { [weak self] in
            self.firebaseService.storeBaggageData(baggage: baggage) { [weak self] result in
                guard let self else { return }
                switch result {
                case .failure:
                    self.output?.didReceiveError(Errors.saveDataError)
                case .success(let savedBaggage):
                    completion(savedBaggage)
                }
//            }
        }
    }
    
    private func obtainStuffListStuff(with ids: [String], completion: @escaping ([Stuff]) -> Void) {
        didReceiveErrorWhileObtainingData = false
        var stuff: [Stuff] = []
        for id in ids {
            dataLoadDispatchGroup.enter()
            dataLoadQueue.async(group: dataLoadDispatchGroup) { [weak self] in
                self?.firebaseService.obtainCertainUserStuff(stuffId: id) { [weak self] result in
                    switch result {
                    case .failure:
                        self?.didReceiveErrorWhileObtainingData = true
                    case .success(let certainStuff):
                        stuff.append(certainStuff)
                    }
                    self?.dataLoadDispatchGroup.leave()
                }
            }
        }
        
        dataLoadDispatchGroup.notify(queue: dataLoadQueue) { [weak self] in
            if self?.didReceiveErrorWhileObtainingData == true {
                self?.output?.didReceiveError(Errors.obtainDataError)
            }
            completion(stuff)
        }
    }
    
    private func obtainBaggageStuff(baggage: Baggage, completion: @escaping ([Stuff]) -> Void) {
//        dataLoadQueue.async { [weak self] in
            self.firebaseService.obtainBaggage(baggageId: baggage.id) { [weak self]  result in
                guard let self else { return }
                switch result {
                case .failure:
                    self.output?.didReceiveError(Errors.obtainDataError)
                case .success(let stuff):
                    completion(stuff)
                }
            }
//        }
    }
    
    private func saveStuff(_ stuff: Stuff, baggageId: String, completion: @escaping (Stuff) -> Void) {
//        dataSaveQueue.async { [weak self] in
            self.firebaseService.storeStuffData(baggageId: baggageId, stuff: stuff) {[weak self] result in
                guard let self else { return }
                switch result {
                case .failure:
                    self.output?.didReceiveError(Errors.saveDataError)
                case .success(let savedStuff):
                    completion(savedStuff)
                }
            }
//        }
    }
    
    func deleteStuffListFromBaggage(baggage: Baggage,
                                    stuffList: StuffList,
                                    completion: @escaping (Baggage) -> Void) {
        obtainBaggageStuff(baggage: baggage) { [weak self] baggageStuff in
            let baggageStuffIDsSet = Set(baggage.stuffIDs)
            let stuffListStuffIDsSet = Set(stuffList.stuffIDs)
            let sharedStuff = Array(baggageStuffIDsSet.intersection(stuffListStuffIDsSet))
            
            self?.obtainStuffListStuff(with: sharedStuff) { [weak self] stuffListStuff in
                let equalStuffIds: [String] = stuffListStuff.compactMap {
                    if let index = baggageStuff.firstIndex(of: $0) {
                        return baggageStuff[index].id
                    }
                    return nil
                }
                self?.deleteStuffFromBaggage(stuffIds: equalStuffIds,
                                             baggageId: baggage.id) { [weak self] deletedStuffIds in
                    var newBaggage = baggage
                    deletedStuffIds.forEach { stuffId in
                        if let index = newBaggage.stuffIDs.firstIndex(of: stuffId) {
                            newBaggage.stuffIDs.remove(at: index)
                        }
                    }
                    if let stuffListId = stuffList.id,
                       let index = newBaggage.addedStuffListsIDs.firstIndex(of: stuffListId) {
                        newBaggage.addedStuffListsIDs.remove(at: index)
                        self?.saveBaggage(newBaggage) { baggage in
                            completion(baggage)
                        }
                    }
                }
            }
        }
    }
    
    private func deleteStuffFromBaggage(stuffIds: [String],
                                        baggageId: String,
                                        completion: @escaping ([String]) -> Void) {
        didReceiveErrorWhileObtainingData = false
        var deletedStuffIds: [String] = []
        for stuffId in stuffIds {
            dataDeleteDispatchGroup.enter()
            dataDeleteQueue.async(group: dataDeleteDispatchGroup) { [weak self] in
                self?.firebaseService.deleteStuffData(stuffId, baggageId: baggageId) { [weak self] error in
                    if let error {
                        self?.didReceiveErrorWhileDeletingData = true
                    } else {
                        deletedStuffIds.append(stuffId)
                    }
                    self?.dataDeleteDispatchGroup.leave()
                }
            }
        }
        
        dataDeleteDispatchGroup.notify(queue: dataDeleteQueue) { [weak self] in
            if self?.didReceiveErrorWhileDeletingData == true {
                self?.output?.didReceiveError(Errors.obtainDataError)
            }
            completion(deletedStuffIds)
        }
    }
}
