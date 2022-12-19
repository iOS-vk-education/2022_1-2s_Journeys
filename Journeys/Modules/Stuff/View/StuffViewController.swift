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
        output.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupNavBar()
        setupTableView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(30)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func didTapExitButton() {

    }
    
}

extension StuffViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: L10n.delete) { [weak self] (action, indexPath) in
            self?.output.handeleCellDelete(at: indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }

        let editAction = UITableViewRowAction(style: .normal,
                                              title: L10n.change) { [weak self] (action, indexPath) in
            guard let strongSelf = self else { return }
            self?.output.handeleCellEdit(at: indexPath, tableView: self?.tableView)
        }
        editAction.backgroundColor = .systemMint

        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let closure = output.didSelectRow(at: indexPath,
                                                rowsInSection: tableView.numberOfRows(inSection: indexPath.section))
        else {
            return
        }
        closure(self, tableView, indexPath.section)
    }
}

extension StuffViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StuffTableViewHeader")
        let header = headerFooter as? StuffTableViewHeader
        if section == 0 {
            header?.configure(title: L10n.unpacked)
        } else if section == 1 {
            header?.configure(title: L10n.packed)
        }
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.getNumberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddStuffCell", for: indexPath) as? AddStuffCell else {
                return UITableViewCell()
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StuffCell", for: indexPath) as? StuffCell else {
                return UITableViewCell()
            }
            guard let data = output.getStuffCellDisplayData(for: indexPath) else {
                return UITableViewCell()
            }
            cell.configure(data: data, delegate: self)
            return cell
        }
    }
    
}

extension StuffViewController: StuffViewInput {
    func reloadData() {
        tableView.reloadData()
    }
}

extension StuffViewController: StuffCellDelegate {
    func cellPackButtonWasTapped(_ cell: StuffCell) {
        output.didTapCellPackButton(at: tableView.indexPath(for: cell), tableView: tableView)
    }
    func emojiTextFieldDidChange(_ text: String, in cell: StuffCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        output.emojiTextFieldDidChange(text, at: indexPath)
    }
    func nameTextFieldDidChange(_ text: String, in cell: StuffCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        output.nameTextFieldDidChange(text, at: indexPath)
    }
}
