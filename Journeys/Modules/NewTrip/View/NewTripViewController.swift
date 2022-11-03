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
        enum TableView {
            enum Separator {
                static let topBottomIndent: CGFloat = 0
                static let leftRightIndent: CGFloat = 16
            }
        }
    }
    
    private let tableView: UITableView = UITableView()
    
    var output: NewTripViewOutput!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.title
        
        setupTable()
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewTripCityCell.self, forCellReuseIdentifier: NewTripCityCell.reuseId)
        tableView.separatorInset = UIEdgeInsets(
            top: Constants.TableView.Separator.topBottomIndent,
            left: Constants.TableView.Separator.leftRightIndent,
            bottom: Constants.TableView.Separator.topBottomIndent,
            right: Constants.TableView.Separator.leftRightIndent
        )
    }
}

// MARK: - NewTripViewInput

extension NewTripViewController: NewTripViewInput {
}

// MARK: - UITableViewDataSource

extension NewTripViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTripCityCell.reuseId) as? NewTripCityCell
        else {
            return UITableViewCell()
        }
        cell.configure(displayData: NewTripCityCell.DisplayData(pictureSystemName: "magnifyingglass", title: "Город маршрута", isTextActive: false))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewTripViewController: UITableViewDelegate {
    
}
