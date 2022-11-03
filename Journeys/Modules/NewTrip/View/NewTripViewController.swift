//
//  NewTripViewController.swift
//  Journeys
//
//  Created by Pritex007 on 03/11/2022.
//

import UIKit
import SnapKit

// MARK: - NewTripViewController

final class NewTripViewController: UIViewController {
    
    // MARK: Private constants
    
    private enum Constants {
        static let title: String = "Новый маршрут"
    }
    
    private let tableView: UITableView = UITableView()

    var output: NewTripViewOutput!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
    }
    
    private func setupConstraints() {
        tableView.snp
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - NewTripViewInput

extension NewTripViewController: NewTripViewInput {
}

// MARK: - UITableViewDataSource

extension NewTripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

// MARK: - UITableViewDataSource

extension NewTripViewController: UITableViewDataSource {
    
}
