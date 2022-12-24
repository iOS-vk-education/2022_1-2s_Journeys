//
//  StoreNewTrip.swift
//  Journeys
//
//  Created by Сергей Адольевич on 23.12.2022.
//

import Foundation
import UIKit

final class StoreNewTrip {
    private let firebaseService: FirebaseServiceProtocol
    private var route: Route
    private let tripImage: UIImage
    private let output: StoreNewTripOutput
    
//    private var routeId: String?
    private var stuffIds: [String]?
    private var stuff: [Stuff]?
    
    private var count: Int?
    
    internal init(route: Route,
                  tripImage: UIImage,
                  firebaseService: FirebaseServiceProtocol,
                  output: StoreNewTripOutput) {
        self.route = route
        self.tripImage = tripImage
        self.firebaseService = firebaseService
        self.output = output
    }
    
    func start() {
        storeImage()
    }
    
    private func storeImage() {
        firebaseService.storeTripImage(image: tripImage) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let url):
                self.didSaveImage(url: url)
            }
        }
    }
    
    private func storeRoute(imageURL: String) {
        route = Route(id: route.id,
                      imageURLString: imageURL,
                      departureLocation: route.departureLocation,
                      places: route.places)
        firebaseService.storeRouteData(route: route) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let route):
                self.route = route
                self.didSaveRouteData()
            }
        }
    }
    
    private func obtainBaseStuff() {
        firebaseService.obtainBaseStuff { result in
            switch result {
            case .failure:
                assertionFailure()
                self.didRecieveError()
            case .success(let baseStuff):
                print(baseStuff)
                self.didRecieveBaseStuffData(baseStuff)
            }
            
        }
    }
    
    private func storeBaggage(baggage: Baggage) {
        firebaseService.storeBaggageData(baggage: baggage) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let baggage):
                self.didSaveBaggageData(baggage: baggage)
            }
        }
    }
    
    private func storeStuff(baggageId: String, stuff: Stuff) {
        firebaseService.storeStuffData(baggageId: baggageId, stuff: stuff) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let baggage):
                self.count? -= 1
                if self.count == 0 {
                    self.saveSuccesful()
                }
            }
        }
    }
    
    private func storeTrip(trip: Trip) {
        firebaseService.storeTripData(trip: trip) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let trip):
                self.didSaveTripData()
            }
        }
    }
    
    private func didSaveImage(url: String) {
        storeRoute(imageURL: url)
    }
    
    private func didSaveRouteData() {
        obtainBaseStuff()
    }
    
    private func didRecieveBaseStuffData(_ baseStuff: [BaseStuff]) {
        self.stuff = baseStuff.compactMap { Stuff(baseStuff: $0) }
        var stuffIDs: [String] = []
        guard let stuff = stuff else {
            didRecieveError()
            return
        }
        for curStuff in stuff {
            if let id = curStuff.id {
                stuffIDs.append(id)
            }
        }
        var baggage = Baggage(id: nil, stuffIDs: stuffIDs)
        storeBaggage(baggage: baggage)
    }
    
    private func didSaveBaggageData(baggage: Baggage) {
        guard let routeId = route.id,
              let stuff = stuff else {
            didRecieveError()
            return
        }
        let trip = Trip(id: nil, routeId: routeId, baggageId: baggage.id, dateChanged: Date())
        storeTrip(trip: trip)

        self.count = stuff.count
        for surStuff in stuff {
            storeStuff(baggageId: baggage.id, stuff: surStuff)
        }
    }
    
    private func didSaveTripData() {
    }
    
    private func didRecieveError() {
        output.saveError()
    }
    
    private func saveSuccesful() {
        output.saveFinished()
    }
}

protocol StoreNewTripOutput: AnyObject {
    func saveFinished()
    func saveError()
}
