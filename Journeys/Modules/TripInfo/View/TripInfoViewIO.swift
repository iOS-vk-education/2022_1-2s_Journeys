//
//  TripInfoViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

import UIKit

// MARK: - TripInfo ViewInput

protocol TripInfoViewInput: AnyObject {
}

// MARK: - TripInfo ViewOutput

protocol TripInfoViewOutput: AnyObject {
    func getViewControllers() -> [UIViewController]
    func getCurrentPageIndex() -> Int
    
    func didTapEvitButton()
}
