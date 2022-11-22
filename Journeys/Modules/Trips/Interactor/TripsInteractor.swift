//
//  TripsInteractor.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import Foundation
import UIKit

// MARK: - TripsInteractor

let plases1 = [Place(location: Location(country: "Russia", city: "Perm"),
                    arrive: Date(),
                    depart: Date(timeInterval: 100000, since: Date())),
              Place(location: Location(country: "Russia", city: "Spb"),
                    arrive: Date(timeInterval: 100000, since: Date()),
                    depart: Date(timeInterval: 1000000, since: Date()))]
let plases2 = [Place(location: Location(country: "USA", city: "New York"),
                    arrive: Date(),
                    depart: Date(timeInterval: 100000, since: Date())),
              Place(location: Location(country: "USA", city: "Dallas"),
                    arrive: Date(timeInterval: 100000, since: Date()),
                    depart: Date(timeInterval: 1000000, since: Date()))]
let route1 = Route(departureTown: Location(country: "Russia", city: "Moscow"),
                    places: plases1,
                    start: Date(),
                    finish: Date(timeInterval: 10000000, since: Date()))
let route2 = Route(departureTown: Location(country: "USA", city: "San-Francisco"),
                    places: plases2,
                    start: Date(timeInterval: 10000000, since: Date()),
                    finish: Date(timeInterval: 10000000, since: Date()))

let trips = [Trip(icon: UIImage(asset: Asset.Assets.TripCell.tripCellImage), route: route1, isInfavourites: true), Trip(icon: UIImage(asset: Asset.Assets.TripCell.tripCellImage2), route: route2)]

final class TripsInteractor {

    weak var output: TripsInteractorOutput?
}

extension TripsInteractor: TripsInteractorInput {
    
    func obtainDataFromSever() -> [Trip]? {
        return trips
    }
}
