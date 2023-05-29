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
    
    weak var view: StuffViewInput?
    var model: StuffModelInput!
    weak var moduleOutput: StuffModuleOutput!
    
    private let baggageId: String
    private var baggage: Baggage?
    private var allStuff: [Stuff] = []
    private var unpackedStuff: [Stuff] = []
    private var packedStuff: [Stuff] = []
    
    private var lastChangedIndexPath: IndexPath?
    
    private var isDataObtained: Bool = false
    
    private var currenStuffCellKeyboardType: StuffCell.KeyboardType = .usual
    
    init(baggageId: String) {
        self.baggageId = baggageId
    }
    
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
    
    private func sortStuff() {
        guard let baggage else { return }
        for stuffId in baggage.stuffIDs {
            for stuff in allStuff {
                if stuffId == stuff.id {
                    if stuff.isPacked {
                        packedStuff.append(stuff)
                    } else {
                        unpackedStuff.append(stuff)
                    }
                }
            }
        }
    }
    
    private func saveStuff(_ stuff: Stuff, indexPath: IndexPath) {
        guard let baggage else {
            showAlert(error: .obtainDataError)
            return
        }
        model.saveChangedStuff(stuff: stuff, baggage: baggage, indexPath: indexPath)
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard unpackedStuff.indices.contains(indexPath.row) else { return }
            unpackedStuff.remove(at: indexPath.row)
        } else if indexPath.section == 1 {
            guard packedStuff.indices.contains(indexPath.row) else { return }
            packedStuff.remove(at: indexPath.row)
        }
        view?.deleteCell(at: indexPath)
    }
    
    private func showAlert(error: Errors) {
        DispatchQueue.main.async { [weak self] in
            guard let alertShowingVC = self?.view as? AlertShowingViewController else { return }
            self?.askToShowErrorAlert(error, alertShowingVC: alertShowingVC)
        }
    }
}


extension StuffPresenter: StuffViewOutput {
    func viewDidLoad() {
        model.obtainData(baggageId: baggageId)
    }
    
    func didTapAddStuffListButton() {
        guard let baggage else { return }
        moduleOutput.openAddStuffListModule(baggage: baggage, stuffModuleInput: self)
    }
    
    func didTapScreen(tableView: UITableView) {
        guard let lastChangedIndexPath = lastChangedIndexPath else { return }
        if let cell = view?.getCell(for: lastChangedIndexPath) as? StuffCell {
            let data = cell.getData()
            cell.finishEditMode()
            if data.name.count == 0 {
                deleteCell(at: lastChangedIndexPath)
            }
        }
    }
    
    func didTapExitButton() {
        moduleOutput.stuffModuleWantsToClose()
    }
}

extension StuffPresenter: StuffModelOutput {
    func didSaveStuff(stuff: Stuff, baggage: Baggage, indexPath: IndexPath) {
        if let cell = view?.getCell(for: indexPath) as? StuffCell {
            cell.finishEditMode()
        }
        if indexPath.section == 0 {
            guard unpackedStuff.indices.contains(indexPath.row) else {
                didRecieveError(.saveDataError)
                return
            }
            self.baggage = baggage
            unpackedStuff[indexPath.row] = stuff
        } else if indexPath.section == 1 {
            guard packedStuff.indices.contains(indexPath.row) else {
                didRecieveError(.saveDataError)
                return
            }
            self.baggage = baggage
            packedStuff[indexPath.row] = stuff
        }
    }
    
    func didDeleteStuff() {
        view?.reloadData()
    }
    
    func didRecieveError(_ error: Errors) {
        showAlert(error: error)
    }
    
    func didRecieveData(stuff: [Stuff], baggage: Baggage) {
        allStuff.removeAll()
        packedStuff.removeAll()
        unpackedStuff.removeAll()
        allStuff = stuff
        self.baggage = baggage
        sortStuff()
        isDataObtained = true
        view?.endRefresh()
        view?.reloadData()
    }
    
    func didChangeStuffStatus(stuff: Stuff, indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard unpackedStuff.count > indexPath.row else { return }
            packedStuff.append(stuff)
            unpackedStuff.remove(at: indexPath.row)
            view?.changeIsPickedCellFlag(at: indexPath)
            let newIndexPath: IndexPath = IndexPath(row: packedStuff.count - 1, section: 1)
            view?.moveTableViewRow(at: indexPath, to: newIndexPath)
        } else if indexPath.section == 1 {
            guard packedStuff.count > indexPath.row else { return }
            unpackedStuff.append(stuff)
            packedStuff.remove(at: indexPath.row)
            view?.changeIsPickedCellFlag(at: indexPath)
            let newIndexPath: IndexPath = IndexPath(row: unpackedStuff.count - 1, section: 0)
            view?.moveTableViewRow(at: indexPath, to: newIndexPath)
        }
        view?.refreshAllCellsIndexPaths()
    }
}

extension StuffPresenter: StuffModuleInput {
    func didChangeBaggage() {
        model.obtainData(baggageId: baggageId)
    }
}


extension StuffPresenter: StuffCellDelegate {
    func cellPackButtonWasTapped(at indexPath: IndexPath) {
        guard let baggage else {
            return
        }
        if indexPath.section == 0 {
            guard unpackedStuff.count > indexPath.row else { return }
            let newStuff = Stuff(id: unpackedStuff[indexPath.row].id,
                                 emoji: unpackedStuff[indexPath.row].emoji,
                                 name: unpackedStuff[indexPath.row].name,
                                 isPacked: !unpackedStuff[indexPath.row].isPacked)
            model.changeStuffIsPackedFlag(stuff: newStuff,
                                          baggage: baggage,
                                          indexPath: indexPath)
        } else if indexPath.section == 1 {
            guard packedStuff.count > indexPath.row else { return }
            let newStuff = Stuff(id: packedStuff[indexPath.row].id,
                                 emoji: packedStuff[indexPath.row].emoji,
                                 name: packedStuff[indexPath.row].name,
                                 isPacked: !packedStuff[indexPath.row].isPacked)
            model.changeStuffIsPackedFlag(stuff: newStuff,
                                          baggage: baggage,
                                          indexPath: indexPath)
        }
    }
    func emojiTextFieldDidChange(_ text: String, at indexPath: IndexPath) {
        guard text.count > 0 else {
            return
        }
        if indexPath.section == 0 {
            guard unpackedStuff.count > indexPath.row else { return }
            unpackedStuff[indexPath.row].emoji = text
            if unpackedStuff[indexPath.row].name != nil {
                saveStuff(unpackedStuff[indexPath.row], indexPath: indexPath)
            }
        } else if indexPath.section == 1 {
            guard packedStuff.count > indexPath.row else { return }
            packedStuff[indexPath.row].emoji = text
            if packedStuff[indexPath.row].name != nil {
                saveStuff(packedStuff[indexPath.row], indexPath: indexPath)
            }
        }
    }
    func nameTextFieldDidChange(_ text: String, at indexPath: IndexPath) {
        guard text.count > 0 else {
            deleteCell(at: indexPath)
            return
        }
        if indexPath.section == 0 {
            guard unpackedStuff.indices.contains(indexPath.row) else { return }
            unpackedStuff[indexPath.row].name = text
            saveStuff(unpackedStuff[indexPath.row], indexPath: indexPath)
        } else if indexPath.section == 1 {
            guard packedStuff.indices.contains(indexPath.row) else { return }
            packedStuff[indexPath.row].name = text
            saveStuff(packedStuff[indexPath.row], indexPath: indexPath)
        }
    }
    
    func didChangedKeyboardType(to type: StuffCell.KeyboardType) {
        currenStuffCellKeyboardType = type
    }
}

extension StuffPresenter: StuffTableViewControllerOutput {
    func numberOfSection() -> Int? {
        2
    }
    
    func numberOfRows(in section: Int) -> Int? {
        guard isDataObtained else {
            return 1
        }
        if section == 0 {
            return unpackedStuff.count + 1
        } else if section == 1 {
            return packedStuff.count + 1
        }
        return 1
    }
    
    func sectionHeaderText(_ section: Int) -> String {
        if section == 0 {
            return  L10n.unpacked
        } else if section == 1 {
            return  L10n.packed
        }
        return ""
    }
    
    func stuffCellDisplayData(for indexPath: IndexPath) -> StuffCell.DisplayData? {
        guard let vc = view as? UIViewController else { return nil }
        if indexPath.section == 0 {
            if !unpackedStuff.indices.contains(indexPath.row) {
                return nil
            }
            let stuff = unpackedStuff[indexPath.row]
            guard let name = stuff.name else {
                return StuffCell.DisplayData(stuffData: StuffCell.StuffData(emoji: "",
                                                                            name: "",
                                                                            isPacked: stuff.isPacked),
                                             backgroundColor: vc.view.backgroundColor,
                                             changeMode: .on)
            }
            return StuffCell.DisplayData(stuffData: StuffCell.StuffData(emoji: stuff.emoji,
                                                                        name: name,
                                                                        isPacked: stuff.isPacked),
                                         backgroundColor: vc.view.backgroundColor,
                                         changeMode: .off)
        } else if indexPath.section == 1 {
            if !packedStuff.indices.contains(indexPath.row) {
                return nil
            }
            let stuff = packedStuff[indexPath.row]
            guard let name = stuff.name,
                  let emoji = stuff.emoji else {
                return StuffCell.DisplayData(stuffData: StuffCell.StuffData(emoji: "",
                                                                            name: "",
                                                                            isPacked: stuff.isPacked),
                                             backgroundColor: vc.view.backgroundColor,
                                             changeMode: .on)
            }
            return StuffCell.DisplayData(stuffData: StuffCell.StuffData(emoji: emoji,
                                                                        name: name,
                                                                        isPacked: stuff.isPacked),
                                         backgroundColor: vc.view.backgroundColor,
                                         changeMode: .off)
        }
        return nil
    }
    
    func didSelectRow(at indexPath: IndexPath,
                      rowsInSection: Int,
                      completion: () -> Void) {
        if indexPath.row == rowsInSection - 1 {
            if indexPath.section == 0 {
                unpackedStuff.append(Stuff(isPacked: false))
            } else if indexPath.section == 1 {
                packedStuff.append(Stuff(isPacked: true))
            }
            lastChangedIndexPath = indexPath
            completion()
        }
    }
    
    func handleCellDelete(at indexPath: IndexPath) {
        if indexPath.section == 0,
           unpackedStuff.indices.contains(indexPath.row),
           let baggage {
            guard let id = unpackedStuff[indexPath.row].id else {
                unpackedStuff.remove(at: indexPath.row)
                return
            }
            if unpackedStuff.indices.contains(indexPath.row) {
                unpackedStuff.remove(at: indexPath.row)
            }
            model.deleteStuff(baggage: baggage, stuffId: id)
        } else if indexPath.section == 1,
                  packedStuff.indices.contains(indexPath.row),
                  let baggage {
            guard let id = packedStuff[indexPath.row].id else {
                packedStuff.remove(at: indexPath.row)
                return
            }
            if packedStuff.indices.contains(indexPath.row) {
                packedStuff.remove(at: indexPath.row)
            }
            model.deleteStuff(baggage: baggage, stuffId: id)
        } else {
            didRecieveError(.deleteDataError)
        }
    }
    
    func handleCellEdit(at indexPath: IndexPath, tableView: UITableView?) {
        view?.reloadData()
        guard let cell = tableView?.cellForRow(at: indexPath) as? StuffCell else { return }
        lastChangedIndexPath = indexPath
        cell.startEditMode()
    }
    
    func editingCellIndexPath() -> IndexPath? {
        lastChangedIndexPath
    }
    
    func keyBoardToShowType() -> StuffCell.KeyboardType {
        currenStuffCellKeyboardType
    }
}

extension StuffPresenter: AskToShowAlertProtocol {
}
