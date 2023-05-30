//
//  CertainStuffListModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//
import Foundation

// MARK: - CertainStuffListModel

final class CertainStuffListModel {
    weak var output: CertainStuffListModelOutput?
    private let firebaseService: FirebaseServiceProtocol
    
    private let dataLoadQueue = DispatchQueue.global()
    private let dataLoadDispatchGroup = DispatchGroup()
    private var didReceiveErrorWhileObtainingData: Bool = false
    
    private let dataQueue = DispatchQueue.global()
    private let dataDispatchGroup = DispatchGroup()
    
    private let stuffStoreQueue = DispatchQueue.global()
    private let stuffStoreDispatchGroup = DispatchGroup()
    private var didReceiveErrorWhileSavingData: Bool = false
    
    private let dataDeleteQueue = DispatchQueue.global()
    private let dataDeleteDispatchGroup = DispatchGroup()
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
}
extension CertainStuffListModel: CertainStuffListModelInput {
    func obtainStuff(with ids: [String]) {
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
            var sortedStuff: [Stuff] = []
            for id in ids {
                if let curStuff = stuff.first(where: { $0.id == id }) {
                    sortedStuff.append(curStuff)
                }
            }
            stuff.sort(by: { $0.name ?? "" < $1.name ?? "" })
            self?.output?.didReceiveStuff(stuff)
        }
    }
    
    func saveStuffList(_ stuffList: StuffList, stuff: [Stuff]) {
        didReceiveErrorWhileSavingData = false
        dataQueue.async(flags: .barrier) { [weak self] in
            self?.storeStuff(stuff) { [weak self] savedStuff in
                var newStuffList = stuffList
                newStuffList.stuffIDs = savedStuff.compactMap( { $0.id })
                self?.storeStuffList(newStuffList) { result in
                    switch result {
                    case .failure:
                        self?.output?.didReceiveError(Errors.saveDataError)
                    case .success(let savedStuffList):
                        if self?.didReceiveErrorWhileSavingData == true {
                            self?.output?.didReceiveError(Errors.saveDataError)
                        }
                        let sortedStuff = savedStuff.sorted(by: { $0.name ?? "" < $1.name ?? "" })
                        self?.output?.didSaveStuffList(stuffList: savedStuffList, stuff: sortedStuff)
                    }
                }
            }
        }
    }
    
    private func storeStuff(_ stuff: [Stuff], completion: @escaping ([Stuff]) -> Void) {
        var savedStuff: [Stuff] = []
        
        for curStuff in stuff {
            stuffStoreDispatchGroup.enter()
            stuffStoreQueue.async(group: stuffStoreDispatchGroup, flags: .barrier) { [weak self] in
                self?.firebaseService.storeSertainStuffListStuff (stuff: curStuff) { [weak self] result in
                    switch result {
                    case .failure:
                        self?.didReceiveErrorWhileSavingData = true
                    case .success(let curStuff):
                        savedStuff.append(curStuff)
                    }
                    self?.stuffStoreDispatchGroup.leave()
                }
            }
        }
        stuffStoreDispatchGroup.notify(queue: stuffStoreQueue) {
            completion(savedStuff)
        }
    }
    
    private func storeStuffList(_ stuffList: StuffList, completion: @escaping (Result<StuffList, Error>) -> Void) {
        firebaseService.storeStuffList(stuffList: stuffList) { result in
            completion(result)
        }
    }
    
    func deleteStuffList(_ stuffList: StuffList, stuff: [Stuff]) {
        guard let stuffListId = stuffList.id else {
            deleteStuff(stuff) { [weak self] in
                self?.output?.didDeleteStuffList()
            }
            return
        }
        firebaseService.deleteStuffList(stuffListId) { [weak self] error in
            if error != nil {
                self?.output?.didReceiveError(.deleteDataError)
            } else {
                self?.deleteStuff(stuff) { [weak self] in
                    self?.output?.didDeleteStuffList()
                }
            }
        }
    }
    
    private func deleteStuff(_ stuff: [Stuff], completion: @escaping () -> Void) {
        for curStuff in stuff {
            dataDeleteDispatchGroup.enter()
            dataDeleteQueue.async(group: dataDeleteDispatchGroup, flags: .barrier) { [weak self] in
                if let stuffId = curStuff.id {
                    self?.firebaseService.deleteUserCertainStuff(stuffId) { [weak self] _ in
                        self?.dataDeleteDispatchGroup.leave()
                    }
                }
            }
        }
        dataDeleteDispatchGroup.notify(queue: dataDeleteQueue) {
            completion()
        }
    }
}
