//
//  StuffTableViewController.swift
//  Journeys
//
//  Created by Сергей Адольевич on 08.05.2023.
//

import Foundation
import UIKit

protocol StuffTableViewControllerOutput: AnyObject {
    func handeleCellEdit(at indexPath: IndexPath, tableView: UITableView?)
    func handeleCellDelete(at indexPath: IndexPath)
    
    func numberOfSection() -> Int?
    func numberOfRows(in section: Int) -> Int?
    func sectionHeaderText(_ section: Int) -> String
    func stuffCellDisplayData(for indexPath: IndexPath) -> StuffCell.DisplayData?
    func didSelectRow(at indexPath: IndexPath,
                      rowsInSection: Int, completion: () -> Void)
    
    func editingCellIndexPath() -> IndexPath?
    func keyBoardToShowType() -> StuffCell.KeyboardType
}

final class StuffTableViewController: UITableViewController {
    var output: StuffTableViewControllerOutput?
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    private func configureView() {
        tableView.register(StuffCell.self, forCellReuseIdentifier: "StuffCell")
        tableView.register(AddStuffCell.self, forCellReuseIdentifier: "AddStuffCell")
        tableView.register(StuffTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "StuffTableViewHeader")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 60, right: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            guard let cellIndexPath = output?.editingCellIndexPath() else { return }
            guard let cellFrame = tableView.cellForRow(at: cellIndexPath)?.frame else { return }
            
            var keyboardHeight: CGFloat = keyboardSize.height
            // система неверно распознает размеры emoji клавиатуры, поэтому накостылила
            if output?.keyBoardToShowType() == .emoji {
                keyboardHeight = 800
            }
            
            var aRect: CGRect = tableView.bounds
            aRect.size.height -= keyboardHeight
            var keyboardMinY: CGFloat = tableView.bounds.maxY - keyboardHeight

            if !aRect.contains(CGPoint(x: cellFrame.origin.x, y: cellFrame.maxY)) {
                tableView.setContentOffset(CGPoint(x:0, y: cellFrame.maxY - keyboardHeight), animated: true)
            }
            aRect = tableView.bounds
            aRect.size.height -= keyboardHeight
            
            keyboardMinY = tableView.bounds.maxY - keyboardHeight
            if !aRect.contains(CGPoint(x: cellFrame.origin.x, y: cellFrame.maxY)) {
                tableView.contentInset = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: 60 + (cellFrame.maxY + 10 - keyboardMinY),
                                                      right: 0)
            }
        }
    }
    @objc
    private func keyboardWillHide(_ notification:Notification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension StuffTableViewController {
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            return nil
        }
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: L10n.delete) { [weak self] (action, indexPath) in
            self?.output?.handeleCellDelete(at: indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        let editAction = UITableViewRowAction(style: .normal,
                                              title: L10n.edit) { [weak self] (action, indexPath) in
            guard let strongSelf = self else { return }
            self?.output?.handeleCellEdit(at: indexPath, tableView: self?.tableView)
        }
        editAction.backgroundColor = .systemMint
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        output?.didSelectRow(at: indexPath,
                             rowsInSection: tableView.numberOfRows(inSection: indexPath.section)) {
            [weak self] in
            guard let self else { return }
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "StuffCell") as? StuffCell
            else {
                assertionFailure("Error accured while creating cell")
                return
            }
            let newIndexPath = IndexPath(row: tableView.numberOfRows(inSection: indexPath.section) - 1, section: indexPath.section)
            tableView.beginUpdates()
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}


extension StuffTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        output?.numberOfSection() ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.numberOfRows(in: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StuffTableViewHeader")
        let header = headerFooter as? StuffTableViewHeader
        header?.configure(title: output?.sectionHeaderText(section) ?? "")
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddStuffCell", for: indexPath) as? AddStuffCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(backgroundColor: tableView.backgroundColor)
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StuffCell", for: indexPath) as? StuffCell else {
                return UITableViewCell()
            }
            guard let data = output?.stuffCellDisplayData(for: indexPath)
            else {
                return UITableViewCell()
            }
            cell.configure(data: data, indexPath: indexPath, delegate: output as? StuffCellDelegate)
            cell.selectionStyle = .none
            return cell
        }
    }
}

