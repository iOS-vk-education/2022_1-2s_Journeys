//
//  TransitionHandlerProtocol.swift
//  Journeys
//
//  Created by Сергей Адольевич on 27.12.2022.
//

import Foundation
import UIKit

protocol TransitionHandlerProtocol: AnyObject {
    func embedPlaceholder(_ viewController: UIViewController)
    func showPlaceholder()
    func hidePlaceholder()
}
