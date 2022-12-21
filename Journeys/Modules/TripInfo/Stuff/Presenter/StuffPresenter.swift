//
//  StuffPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

import Foundation
import UIKit

// MARK: - StuffPresenter

final class StuffPresenter {
    // MARK: - Public Properties
    
    weak var view: StuffViewInput!
    var model: StuffModelInput!
    weak var moduleOutput: StuffModuleOutput!
    
    private var allStuff: [Stuff] = []
    private var unpackedStuff: [Stuff] = []
    private var packedStuff: [Stuff] = []
    
    private var lastChangedIndexPath: IndexPath?
    
    private let addRow: (StuffViewController, UITableView, Int)->() = { view, tableView, section in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StuffCell") as? StuffCell
        else {
            assertionFailure("Error while creating cell")
            return
        }
        let newIndexPath = IndexPath(row: tableView.numberOfRows(inSection: section) - 1, section: section)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath as IndexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func saveCellData(cell: StuffCell) {
        let data = cell.giveData()
        if data.name.isEmpty {
            view.showAlert(title: "Введите данные", message: "Введите название вещи")
            return
        }
        guard let lastChangedIndexPath = lastChangedIndexPath else { return }
        cell.finishEditMode()
        if lastChangedIndexPath.section == 0 {
            unpackedStuff[lastChangedIndexPath.row] = Stuff(id: "",
                                                            emoji: data.emoji ?? "",
                                                            name: data.name,
                                                            isPacked: data.isPacked)
        } else if lastChangedIndexPath.section == 1 {
            packedStuff[lastChangedIndexPath.row] = Stuff(id: "",
                                                          emoji: data.emoji ?? "",
                                                          name: data.name,
                                                          isPacked: data.isPacked)
            self.lastChangedIndexPath = nil
        }
    }
}

extension StuffPresenter: StuffModelOutput {
    func stuffWasObtainedData(data: [Stuff]) {
        allStuff = data
        
        for stuff in allStuff {
            if stuff.isPacked {
                packedStuff.append(stuff)
            } else {
                unpackedStuff.append(stuff)
            }
        }
        
        view.reloadData()
    }
}

extension StuffPresenter: StuffModuleInput {
}

extension StuffPresenter: StuffViewOutput {
    func getSectionHeaderText(_ section: Int) -> String {
        if section == 0 {
            return  L10n.unpacked
        } else if section == 1 {
            return  L10n.packed
        }
        return ""
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        if section == 0 {
            return unpackedStuff.count + 1
        } else if section == 1 {
            return packedStuff.count + 1
        }
        return 0
    }

    func viewDidLoad() {
        model.obtainStuffData()
    }

    func getStuffCellDisplayData(for indexpath: IndexPath) -> StuffCell.DisplayData? {
        if indexpath.section == 0 {
            if !unpackedStuff.indices.contains(indexpath.row) {
                return nil
            }
            let stuff = unpackedStuff[indexpath.row]
            guard let name = stuff.name,
                  let emoji = stuff.emoji else {
                return StuffCell.DisplayData(data: StuffCell.StuffData(emoji: "",
                                             name: "",
                                             isPacked: stuff.isPacked),
                                             changeMode: .on)
            }
            return StuffCell.DisplayData(data: StuffCell.StuffData(emoji: emoji,
                                         name: name,
                                         isPacked: stuff.isPacked),
                                         changeMode: .off)
        } else if indexpath.section == 1 {
            if !packedStuff.indices.contains(indexpath.row) {
                return nil
            }
            let stuff = packedStuff[indexpath.row]
            guard let name = stuff.name,
                  let emoji = stuff.emoji else {
                return StuffCell.DisplayData(data: StuffCell.StuffData(emoji: "",
                                             name: "",
                                             isPacked: stuff.isPacked),
                                             changeMode: .on)
            }
            return StuffCell.DisplayData(data: StuffCell.StuffData(emoji: emoji,
                                         name: name,
                                         isPacked: stuff.isPacked),
                                         changeMode: .off)
        }
        return nil
    }

    func didSelectRow(at indexPath: IndexPath,
                      rowsInSection: Int) -> ((StuffViewController, UITableView, Int)->())? {
        if indexPath.row == rowsInSection - 1 {
            if indexPath.section == 0 {
                unpackedStuff.append(Stuff(isPacked: false))
            } else if indexPath.section == 1 {
                packedStuff.append(Stuff(isPacked: true))
            }
            lastChangedIndexPath = indexPath
            return addRow
        }
        return nil
    }

    // MARK: Cells actions
    func handeleCellDelete(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard unpackedStuff.indices.contains(indexPath.row) else { return }
            unpackedStuff.remove(at: indexPath.row)
        } else if indexPath.section == 1 {
            guard packedStuff.indices.contains(indexPath.row) else { return }
            packedStuff.remove(at: indexPath.row)
        }
    }

    func handeleCellEdit(at indexPath: IndexPath, tableView: UITableView?) {
        view.reloadData()
        guard let cell = tableView?.cellForRow(at: indexPath) as? StuffCell else { return }
        lastChangedIndexPath = indexPath
        cell.startEditMode()
    }

    func didTapCellPackButton(at indexpath: IndexPath?, tableView: UITableView) {
        guard let indexpath = indexpath else {
            return
        }
        if indexpath.section == 0 {
            unpackedStuff[indexpath.row].isPacked.toggle()
            packedStuff.append(unpackedStuff[indexpath.row])
            unpackedStuff.remove(at: indexpath.row)
            tableView.moveRow(at: indexpath, to: IndexPath(row: packedStuff.count - 1, section: 1))
        } else if indexpath.section == 1 {
            packedStuff[indexpath.row].isPacked.toggle()
            unpackedStuff.append(packedStuff[indexpath.row])
            packedStuff.remove(at: indexpath.row)
            tableView.moveRow(at: indexpath, to: IndexPath(row: unpackedStuff.count - 1, section: 0))
        }
    }
    
    func emojiTextFieldDidChange(_ text: String, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard unpackedStuff.indices.contains(indexPath.row) else { return }
            unpackedStuff[indexPath.row].emoji = text
        } else if indexPath.section == 1 {
            guard packedStuff.indices.contains(indexPath.row) else { return }
            packedStuff[indexPath.row].emoji = text
        }
    }
    
    func nameTextFieldDidChange(_ text: String, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard unpackedStuff.indices.contains(indexPath.row) else { return }
            unpackedStuff[indexPath.row].name = text
        } else if indexPath.section == 1 {
            guard packedStuff.indices.contains(indexPath.row) else { return }
            packedStuff[indexPath.row].name = text
        }
    }
    
    func didTapScreen(tableView: UITableView) {
        guard let lastChangedIndexPath = lastChangedIndexPath else { return }
        guard let cell = tableView.cellForRow(at: lastChangedIndexPath) as? StuffCell else { return }
        saveCellData(cell: cell)
    }
    
    func didTapExitButton() {
        moduleOutput.stuffModuleWantsToClose()
    }
}
