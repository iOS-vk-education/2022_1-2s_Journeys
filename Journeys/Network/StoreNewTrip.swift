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
    private var trip: Trip?
    private let tripImage: UIImage
    private let output: StoreNewTripOutput
    
    private var stuffIds: [String]?
    private var stuff: [Stuff]?
    
    private let dataLoadQueue = DispatchQueue.global()
    private let dataLoadDispatchGroup = DispatchGroup()
    
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
        firebaseService.storeImage(image: tripImage, imageType: .trip) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let url):
                self.didSaveImage(url: url)
            }
        }
    }
    
    private func didSaveImage(url: String) {
        storeRoute(imageURL: url)
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
    
    private func didSaveRouteData() {
        obtainAlwaysAddingStuffLists()
    }
    
    private func obtainAlwaysAddingStuffLists() {
        firebaseService.obtainStuffLists(type: .alwaysAdding) { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let stuffLists):
                self.obtainStuffListsStuff(stuffLists)
            }
        }
    }
    
    private func obtainStuffListsStuff(_ stuffLists: [StuffList]) {
        var allStuff: [Stuff] = []
        let stuffQueue = DispatchQueue.global()
        let stuffDispatchGroup = DispatchGroup()
        if stuffLists.isEmpty {
            didReceiveStuffLists(stuffLists, stuff: allStuff)
        }
        for stuffList in stuffLists {
            stuffDispatchGroup.enter()
            stuffQueue.async(group: stuffDispatchGroup) { [weak self] in
                self?.obtainStuffListStuff(with: stuffList.stuffIDs) { stuff in
                    allStuff.append(contentsOf: stuff)
                    stuffDispatchGroup.leave()
                }
            }
        }
        stuffDispatchGroup.notify(queue: stuffQueue) { [weak self] in
            self?.didReceiveStuffLists(stuffLists, stuff: allStuff)
        }
    }
    
    private func obtainStuffListStuff(with ids: [String], completion: @escaping ([Stuff]) -> Void) {
        var stuff: [Stuff] = []
        if ids.isEmpty {
            completion(stuff)
        }
        for id in ids {
            dataLoadDispatchGroup.enter()
            dataLoadQueue.async(group: dataLoadDispatchGroup) { [weak self] in
                self?.firebaseService.obtainCertainUserStuff(stuffId: id) { [weak self] result in
                    switch result {
                    case .failure:
                        break
                    case .success(let certainStuff):
                        stuff.append(certainStuff)
                    }
                    self?.dataLoadDispatchGroup.leave()
                }
            }
        }
        
        dataLoadDispatchGroup.notify(queue: dataLoadQueue) {
            completion(stuff)
        }
    }
    
    private func didReceiveStuffLists(_ stuffLists: [StuffList], stuff: [Stuff]) {
        let stuffIDs = stuff.compactMap { $0.id }
        let stuffListsIDs = stuffLists.compactMap { $0.id }
        var baggage = Baggage(id: nil, stuffIDs: stuffIDs, addedStuffListsIDs: stuffListsIDs)
        storeBaggage(baggage: baggage, stuff: stuff)
    }
    
    private func storeBaggage(baggage: Baggage, stuff: [Stuff]) {
        firebaseService.storeBaggageData(baggage: baggage) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let baggage):
                self.didSaveBaggageData(baggage: baggage, stuff: stuff)
            }
        }
    }
    
    private func didSaveBaggageData(baggage: Baggage, stuff: [Stuff]) {
        guard let routeId = route.id else {
            didRecieveError()
            return
        }
        let trip = Trip(id: nil, routeId: routeId, baggageId: baggage.id, dateChanged: Date())
        storeTrip(trip: trip)
        storeStuff(baggageId: baggage.id, stuff: stuff)
    }
    
    private func storeStuff(baggageId: String, stuff: [Stuff]) {
        let storeStuffQueue = DispatchQueue.global()
        let storeStuffDispatchGroup = DispatchGroup()
        if stuff.isEmpty {
            saveSuccesful()
        }
        for curStuff in stuff {
            storeStuffDispatchGroup.enter()
            storeStuffQueue.async(group: storeStuffDispatchGroup) { [weak self] in
                self?.firebaseService.storeStuffData(baggageId: baggageId,
                                                     stuff: curStuff) { [weak self] result in
                    switch result {
                    case .failure:
                        self?.didRecieveError()
                    case .success:
                        break
                    }
                    storeStuffDispatchGroup.leave()
                }
            }
        }
        
        storeStuffDispatchGroup.notify(queue: storeStuffQueue) { [weak self] in
            self?.saveSuccesful()
        }
    }
    
    private func storeTrip(trip: Trip) {
        firebaseService.storeTripData(trip: trip) { result in
            switch result {
            case .failure:
                self.didRecieveError()
            case .success(let trip):
                self.trip = trip
            }
        }
    }
    
    private func didRecieveError() {
        output.saveError()
    }
    
    private func saveSuccesful() {
        DispatchQueue.main.async { [weak self] in
            guard let self, let trip = self.trip else {
                return
            }
            self.output.saveFinished(trip: trip, route: self.route)
        }
    }
}

protocol StoreNewTripOutput: AnyObject {
    func saveFinished(trip: Trip, route: Route)
    func saveError()
}
