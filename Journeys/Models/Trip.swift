//
//  Trip.swift
//  Journeys
//
//  Created by Сергей Адольевич on 21.11.2022.
//

import Foundation
import UIKit

struct Trip {
    var icon: UIImage?
    var route: Route
    var stuff: [Stuff]?
    var isInfavourites: Bool = false
}

