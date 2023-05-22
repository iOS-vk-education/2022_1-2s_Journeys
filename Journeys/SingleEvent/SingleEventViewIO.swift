//
//  SingleEventViewIO.swift
//  Journeys
//
//  Created by Ангелина Решетникова on 16.05.2023.
//

import Foundation
import UIKit

// MARK: - Events ViewInput
protocol SingleEventViewInput: AnyObject {
    func reload()
    func show(error: Error)
    func reloadImage()
    
}

// MARK: - Events ViewOutput
protocol SingleEventViewOutput: AnyObject {
    func didLoadView()
    func displayingData() -> Event?
    func displayImage() -> UIImage?
    func userTapLink()
}
