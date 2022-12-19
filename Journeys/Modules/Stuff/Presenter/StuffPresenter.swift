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
    
    private var allStuff: [Stuff] = []
    private var unpackedStuff: [Stuff] = []
    private var packedStuff: [Stuff] = []
    
    private let addNewCellClosure: (StuffViewController, UITableView, Int)->() = { view, tableView, section in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StuffCell") as? StuffCell
        else {
            assertionFailure("Error while creating cell")
            return
        }
        let newIndexPath = IndexPath(row: tableView.numberOfRows(inSection: section) - 1, section: section)
        cell.configure(data: StuffCell.DisplayData(emoji: "", name: "", isPacked: true, cellType: .new), delegate: view)

        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath as IndexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    private let deleteRow: (UITableView, IndexPath) -> [UITableViewRowAction]? = { tableView, indexPath in
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        return[deleteAction]
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
                return StuffCell.DisplayData(emoji: "",
                                             name: "",
                                             isPacked: stuff.isPacked,
                                             cellType: .new)
            }
            return StuffCell.DisplayData(emoji: emoji,
                                         name: name,
                                         isPacked: stuff.isPacked,
                                         cellType: .usual)
        } else if indexpath.section == 1 {
            if !packedStuff.indices.contains(indexpath.row) {
                return nil
            }
            let stuff = packedStuff[indexpath.row]
            guard let name = stuff.name,
                  let emoji = stuff.emoji else {
                return StuffCell.DisplayData(emoji: "",
                                             name: "",
                                             isPacked: stuff.isPacked,
                                             cellType: .new)
            }
            return StuffCell.DisplayData(emoji: emoji,
                                         name: name,
                                         isPacked: stuff.isPacked,
                                         cellType: .usual)
        }
        return nil
    }
    
    func didSelectRow(at indexPath: IndexPath, rowsInSection: Int) -> ((StuffViewController, UITableView, Int)->())? {
        if indexPath.row == rowsInSection - 1 {
            if indexPath.section == 0 {
                unpackedStuff.append(Stuff(isPacked: false))
            } else if indexPath.section == 1 {
                packedStuff.append(Stuff(isPacked: true))
            }
            return addNewCellClosure
        } 
        return nil
    }
}
