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
    
    private let baggageId: String
    private var baggage: Baggage?
    private var allStuff: [Stuff] = []
    private var unpackedStuff: [Stuff] = []
    private var packedStuff: [Stuff] = []
    
    private var cellToDeleteIndexPath: IndexPath?
    private var lastChangedIndexPath: IndexPath?
    
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
    
    private func saveCellData(cell: StuffCell) {
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
}

extension StuffPresenter: StuffModelOutput {
    func didDeleteStuff() {
        view.reloadData()
        self.cellToDeleteIndexPath = nil
    }
    
    func didRecieveError(_ error: Errors) {
        switch error {
        case .obtainDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при получении данных")
        case .saveDataError:
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при сохранении данных. Проверьте корректность данных и поробуйте снова")
        case .deleteDataError:
            cellToDeleteIndexPath = nil
            view.showAlert(title: "Ошибка",
                           message: "Возникла ошибка при удалении данных")
        default:
            break
        }
    }
    
    func didRecieveStuffData(data: [Stuff]) {
        allStuff = data
        
        sortStuff()
//        for stuff in allStuff {
//            if stuff.isPacked {
//                packedStuff.append(stuff)
//            } else {
//                unpackedStuff.append(stuff)
//            }
//        }
        
        view.reloadData()
    }
    
    func didRecieveBaggageData(data: Baggage) {
        baggage = data
    }
    
    func didChangeStuffStatus(stuff: Stuff, indexPath: IndexPath) {
        if indexPath.section == 0 {
            packedStuff.append(unpackedStuff[indexPath.row])
            unpackedStuff.remove(at: indexPath.row)
            view.moveTableViewRow(at: indexPath, to: IndexPath(row: packedStuff.count - 1, section: 1))
        } else if indexPath.section == 1 {
            unpackedStuff.append(packedStuff[indexPath.row])
            packedStuff.remove(at: indexPath.row)
            view.moveTableViewRow(at: indexPath, to: IndexPath(row: packedStuff.count - 1, section: 0))
        }
    }
}

extension StuffPresenter: StuffModuleInput {
}

extension StuffPresenter: StuffViewOutput {
    func viewDidLoad() {
        model.obtainStuffData(baggageId: baggageId)
        model.obtainBaggageData(baggageId: baggageId)
    }
    
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
        if indexPath.section == 0,
            unpackedStuff.indices.contains(indexPath.row),
            let baggage {
            guard let id = unpackedStuff[indexPath.row].id else {
                didRecieveError(.deleteDataError)
                return
            }
            if unpackedStuff.indices.contains(indexPath.row) {
                unpackedStuff.remove(at: indexPath.row)
            }
            cellToDeleteIndexPath = indexPath
            model.deleteStuff(baggage: baggage, stuffId: id)
        } else if indexPath.section == 1,
                  packedStuff.indices.contains(indexPath.row),
                  let baggage {
            guard let id = packedStuff[indexPath.row].id else {
                didRecieveError(.deleteDataError)
                return
            }
            if packedStuff.indices.contains(indexPath.row) {
                packedStuff.remove(at: indexPath.row)
            }
            cellToDeleteIndexPath = indexPath
            model.deleteStuff(baggage: baggage, stuffId: id)
        } else {
            didRecieveError(.deleteDataError)
        }
    }

    func handeleCellEdit(at indexPath: IndexPath, tableView: UITableView?) {
        view.reloadData()
        guard let cell = tableView?.cellForRow(at: indexPath) as? StuffCell else { return }
        lastChangedIndexPath = indexPath
        cell.startEditMode()
    }

    func didTapCellPackButton(at indexpath: IndexPath?) {
        guard let indexpath,
              let baggage else {
            return
        }
        if indexpath.section == 0 {
            unpackedStuff[indexpath.row].isPacked.toggle()
            model.changeStuffIsPackedFlag(stuff: unpackedStuff[indexpath.row],
                                          baggage: baggage,
                                          indexPath: indexpath)
        } else if indexpath.section == 1 {
            packedStuff[indexpath.row].isPacked.toggle()
            model.changeStuffIsPackedFlag(stuff: packedStuff[indexpath.row],
                                          baggage: baggage,
                                          indexPath: indexpath)
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
