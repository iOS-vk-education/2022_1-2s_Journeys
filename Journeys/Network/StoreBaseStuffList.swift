//
//  StoreBaseStuffList.swift
//  Journeys
//
//  Created by Сергей Адольевич on 25.05.2023.
//

import Foundation

final class StoreBaseStuffList {
    private let firebaseService: FirebaseServiceProtocol
    
    internal init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
    
    func start() {
        obtainBaseStuff()
    }
    
    private func obtainBaseStuff() {
        firebaseService.obtainBaseStuff { [weak self] result in
            switch result {
            case .failure: break
            case .success(let baseStuff):
                self?.storeBaseStuff(baseStuff)
            }
        }
    }
    
    private func storeBaseStuff(_ baseStuff: [BaseStuff]) {
        var stuffIds: [String] = []
        
        if baseStuff.isEmpty {
            createBaseStuffList(with: stuffIds)
        }
        let stuffQueue = DispatchQueue.global()
        let stuffDispatchGroup = DispatchGroup()
        
        for curBaseStuff in baseStuff {
            stuffDispatchGroup.enter()
            stuffQueue.async(group: stuffDispatchGroup) {
                self.firebaseService
                    .storeSertainStuffListStuff(stuff: Stuff(baseStuff: curBaseStuff)) { result in
                        switch result {
                        case .failure: break
                        case .success(let stuff):
                            if let stuffId = stuff.id {
                                stuffIds.append(stuffId)
                            }
                        }
                        stuffDispatchGroup.leave()
                    }
            }
        }
        
        stuffDispatchGroup.notify(queue: stuffQueue) {
            self.createBaseStuffList(with: stuffIds)
        }
    }
    
    private func createBaseStuffList(with stuffIds: [String]) {
        let stuffList = StuffList(id: nil,
                                  color: ColorForFB(color: .blue),
                                  name: L10n.baseStuffList,
                                  stuffIDs: stuffIds,
                                  autoAddToAllTrips: true,
                                  dateCreated: Date())
        firebaseService.storeStuffList(stuffList: stuffList) { _ in }
    }
}
