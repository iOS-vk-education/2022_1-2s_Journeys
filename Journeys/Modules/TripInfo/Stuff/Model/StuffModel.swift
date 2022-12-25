//
//  StuffModel.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

// MARK: - StuffModel

final class StuffModel {
    weak var output: StuffModelOutput!
    private let firebaseService: FirebaseServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol) {
        self.firebaseService = firebaseService
    }
}

extension StuffModel: StuffModelInput {
    func deleteStuff(baggage: Baggage, stuffId: String) {
        guard let index = baggage.stuffIDs.firstIndex(of: stuffId) else {
            output.didRecieveError(.deleteDataError)
            return
        }
        var newBagagge: Baggage = baggage
        newBagagge.stuffIDs.remove(at: index)
        firebaseService.storeBaggageData(baggage: newBagagge) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output.didRecieveError(.obtainDataError)
            case .success(let savedBaggage):
                self.stuffIdWasDeletedFromBaggage(stuffId: stuffId, baggageId: savedBaggage.id)
            }
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
    
    func obtainBaggageData(baggageId: String) {
        firebaseService.obtainBaggageData(baggageId: baggageId) { [weak self]  result in
               guard let self else { return }
               switch result {
               case .failure:
                   self.output.didRecieveError(.obtainDataError)
               case .success(let baggage):
                   self.output.didRecieveBaggageData(data: baggage)
               }
        }
    }
    
    func obtainStuffData(baggageId: String) {
        firebaseService.obtainBaggage(baggageId: baggageId) { [weak self]  result in
            guard let self else { return }
            switch result {
            case .failure:
                self.output.didRecieveError(.obtainDataError)
            case .success(let stuff):
                self.output.didRecieveStuffData(data: stuff)
            }
        }
//        output.stuffWasObtainedData(data: [Stuff(id: "1", emoji: "🩳", name: "Шорты", isPacked: true),
//                                           Stuff(id: "2", emoji: "🪥", name: "Зубная щетка", isPacked: true),
//                                           Stuff(id: "3", emoji: "🪢", name: "Веревка", isPacked: false),
//                                           Stuff(id: "4", emoji: "👕", name: "Футболка", isPacked: true),
//                                           Stuff(id: "5", emoji: "🧼", name: "Мыло", isPacked: false),
//                                           Stuff(id: "6", emoji: "🩲", name: "Нижнее белье", isPacked: true),
//                                           Stuff(id: "7", emoji: "👗", name: "Платье", isPacked: false),
//                                           Stuff(id: "8", emoji: "👠", name: "Обувь", isPacked: false)]
//                                    )
    }
}
