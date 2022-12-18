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
        tableView.register(AddStuffCell.self, forCellReuseIdentifier: "AddStuffCell")
        tableView.register(StuffTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "StuffTableViewHeader")
        
        tableView.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(38)
            make.trailing.equalToSuperview().inset(38)
        }
    }
    
    private func handleChange() {
        
    }
    
    private func handleMoveToTrash() {
        
    }
    
    @objc
    private func didTapExitButton() {
        
    }
}

extension StuffViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != tableView.numberOfRows(inSection: indexPath.section) - 1 {
            let change = UIContextualAction(style: .normal,
                                            title: "Изменить") { [weak self] (action, view, completionHandler) in
                self?.handleChange()
                completionHandler(true)
            }
            change.backgroundColor = .systemGreen
            
            // Trash action
            let trash = UIContextualAction(style: .destructive,
                                           title: "Удалить") { [weak self] (action, view, completionHandler) in
                self?.handleMoveToTrash()
                completionHandler(true)
            }
            trash.backgroundColor = .systemRed
            
            let configuration = UISwipeActionsConfiguration(actions: [change, trash])
            
            return configuration
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let closure = output.didSelectRow(at: indexPath) else {
            return
        }
        closure(self, tableView)
    }
}

extension StuffViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StuffTableViewHeader")
        let header = headerFooter as? StuffTableViewHeader
        header?.configure(title: "lol")
        return header
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
        if indexPath.row == 9 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddStuffCell", for: indexPath) as? AddStuffCell else {
                return UITableViewCell()
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StuffCell", for: indexPath) as? StuffCell else {
                return UITableViewCell()
            }
            cell.configure(data: StuffCell.DisplayData(emoji: "🧼", name: "lalala", isPacked: false))
            return cell
        }
    }
    
}

extension StuffViewController: StuffViewInput {
}
