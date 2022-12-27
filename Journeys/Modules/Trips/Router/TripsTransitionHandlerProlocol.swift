//
//  TripsTransitionHandlerProlocol.swift
//  Journeys
//
//  Created by Сергей Адольевич on 27.12.2022.
//

import Foundation
import UIKit

protocol TripsTransitionHandlerProtocol: AnyObject {
    func embedPlaceholder(_ viewController: UIViewController)
    func hidePlaceholder()
}
