//
//  StuffViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//
import Foundation
import UIKit
import SnapKit

// MARK: - StuffViewController

final class StuffViewController: UIViewController {

    var output: StuffViewOutput!
    private lazy var tableView: UITableView = {
        UITableView(frame: CGRect.zero, style: .grouped)
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(asset: Asset.Colors.Text.mainTextColor)

        let exitButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapExitButton))

        navigationItem.leftBarButtonItem = exitButtonItem
        title = "Список вещей"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StuffCell.self, forCellReuseIdentifier: "StuffCell")

        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(38)
            make.trailing.equalToSuperview().inset(38)
        }
    }
    
    @objc
    private func didTapExitButton() {
        
    }
}

extension StuffViewController: UITableViewDelegate {
    
}

extension StuffViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        <#code#>
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StuffCell", for: indexPath) as? StuffCell else {
            return UITableViewCell()
        }
        cell.configure(data: StuffCell.DisplayData(emoji: "h", name: "lalala", isPacked: false))
        return cell
    }
    
}

extension StuffViewController: StuffViewInput {
}
