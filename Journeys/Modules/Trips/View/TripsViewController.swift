//
//  TripsViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 03/11/2022.
//

import UIKit

// MARK: - TripsViewController

final class TripsViewController: UIViewController {

    var output: TripsViewOutput!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TripsViewController: TripsViewInput {
}