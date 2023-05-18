//
//  CertainStuffListPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import UIKit

// MARK: - CertainStuffListPresenter

final class CertainStuffListPresenter {
    // MARK: - Public Properties

    weak var view: CertainStuffListViewInput?
    private var model: CertainStuffListModelInput
    private var moduleOutput: CertainStuffListModuleOutput
    private var stuffList: StuffList?
    
    private var lastChangedIndexPath: IndexPath?
    private var stuff: [Stuff] = []
    
    private var currenStuffCellKeyboardType: StuffCell.KeyboardType = .usual
    
    init(stuffList: StuffList?,
         model: CertainStuffListModelInput,
         moduleOutput: CertainStuffListModuleOutput) {
        self.stuffList = stuffList
        self.model = model
        self.moduleOutput = moduleOutput
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        guard stuff.indices.contains(indexPath.row) else { return }
        stuff.remove(at: indexPath.row)
        view?.deleteCell(at: indexPath)
    }
}

extension CertainStuffListPresenter: CertainStuffListViewOutput {
    func viewDidLoad() {
        view?.reloadData()
        if let stuffList {
            model.obtainStuff(with: stuffList.stuffIDs)
        }
    }
    
    func didTapBackBarButton() {
        moduleOutput.closeCertainStuffListsModule()
    }
    
    func cellData(for indexPath: IndexPath) -> StuffListCell.Displaydata? {
        if let stuffList {
            return StuffListCell.Displaydata(stuffListData: StuffListCell.StuffListData(title: stuffList.name,
                                                                                        roundColor: stuffList.color.toUIColor()),
                                             cellType: .editable(delegate: self))
        }
        return StuffListCell.Displaydata(stuffListData: StuffListCell.StuffListData(title: "",
                                                                                    roundColor: .blue),
                                         cellType: .editable(delegate: self))
    }
    
    func didPickColor(color: UIColor) {
        view?.changeStuffListCellColoredViewColor(to: color, at: IndexPath(row: 0, section: 0))
    }
    
    func didTapScreen(tableView: UITableView) {
        guard let lastChangedIndexPath = lastChangedIndexPath else { return }
        if let cell = view?.getTableCell(for: lastChangedIndexPath) as? StuffCell {
            let data = cell.getData()
            cell.finishEditMode()
            if data.name.count == 0 {
                deleteCell(at: lastChangedIndexPath)
            }
        }
    }
    
    func didTapSaveButton() {
        guard let stuffListData = view?.getCollectionCellData(for: IndexPath(item: 0, section: 0))
        else { return }
        let stuffListToSave = StuffList(id: stuffList?.id,
                                        color: ColorForFB(color: stuffListData.roundColor),
                                        name: stuffListData.title,
                                        stuffIDs: [],
                                        autoAddToAllTrips: false)
        let stuffToSave = stuff.filter({ $0.name != nil && $0.name?.count != 0 })
        model.saveStuffList(stuffListToSave, stuff: stuffToSave)
    }
    
    func didTapTrashButton() {
        guard let stuffList else { return }
        model.deleteStuffList(stuffList, stuff: stuff)
    }
    
    func editingCellIndexPath() -> IndexPath? {
        lastChangedIndexPath
    }
}

extension CertainStuffListPresenter: StuffTableViewControllerOutput {
    func numberOfSection() -> Int? {
        1
    }
    
    func numberOfRows(in section: Int) -> Int? {
        stuff.count + 1
    }
    
    func sectionHeaderText(_ section: Int) -> String {
        "Вещи"
    }
    
    func stuffCellDisplayData(for indexPath: IndexPath) -> StuffCell.DisplayData? {
        guard stuff.count > indexPath.row else { return nil }
        let curStuff = stuff[indexPath.row]
        guard let name = curStuff.name else {
            return StuffCell.DisplayData(stuffData: StuffCell.StuffData(emoji: "",
                                                                        name: "",
                                                                        isPacked: false),
                                         showPackedButton: false,
                                         backgroundColor: view?.tableViewBackgroundColor(),
                                         changeMode: .on)
        }
        return StuffCell.DisplayData(stuffData: StuffCell.StuffData(emoji: curStuff.emoji,
                                                                    name: name,
                                                                    isPacked: false),
                                     showPackedButton: false,
                                     backgroundColor: view?.tableViewBackgroundColor(),
                                     changeMode: .off)
    }
    
    func didSelectRow(at indexPath: IndexPath,
                      rowsInSection: Int,
                      completion: () -> Void) {
        if indexPath.row == rowsInSection - 1 {
            stuff.append(Stuff(isPacked: false))
            lastChangedIndexPath = indexPath
            completion()
        }
    }
    
    func handeleCellDelete(at indexPath: IndexPath) {
        guard stuff.count > indexPath.row else { return }
        guard let id = stuff[indexPath.row].id else {
            stuff.remove(at: indexPath.row)
            return
        }
        if stuff.indices.contains(indexPath.row) {
            stuff.remove(at: indexPath.row)
        }
    }
    
    func handeleCellEdit(at indexPath: IndexPath, tableView: UITableView?) {
//        view?.reloadData()
        guard let cell = tableView?.cellForRow(at: indexPath) as? StuffCell else { return }
        lastChangedIndexPath = indexPath
        cell.startEditMode()
    }
    
    func keyBoardToShowType() -> StuffCell.KeyboardType {
        currenStuffCellKeyboardType
    }
}

extension CertainStuffListPresenter: StuffListCellDelegate {
    func didTapColorRoundView(selectedColor: UIColor) {
        view?.showColorPicker(selectedColor: selectedColor)
    }
}

extension CertainStuffListPresenter: StuffCellDelegate {
    func cellPackButtonWasTapped(at indexPath: IndexPath) {
        return
    }
    
    func emojiTextFieldDidChange(_ text: String, at indexPath: IndexPath) {
        guard text.count > 0 else {
            return
        }
        guard stuff.indices.contains(indexPath.row) else { return }
        stuff[indexPath.row].emoji = text
    }
    
    func nameTextFieldDidChange(_ text: String, at indexPath: IndexPath) {
        guard text.count > 0 else {
            deleteCell(at: indexPath)
            return
        }
        guard stuff.indices.contains(indexPath.row) else { return }
        stuff[indexPath.row].name = text
    }
    
    func didChangedKeyboardType(to type: StuffCell.KeyboardType) {
        currenStuffCellKeyboardType = type
    }
}

extension CertainStuffListPresenter: CertainStuffListModelOutput {
    func didReceiveStuff(_ stuff: [Stuff]) {
        self.stuff = stuff
        view?.reloadData()
    }
    
    func didReceiveError(_ error: Error) {
        view?.showAlert(title: "ERROR", message: error.localizedDescription)
    }
    
    func didSaveStuffList(stuffList: StuffList, stuff: [Stuff]) {
        self.stuffList = stuffList
        self.stuff = stuff
        view?.reloadData()
        view?.showAlert(title: "Save successful", message: "")
    }
    
    func didDeleteStuffList() {
        view?.showAlert(title: "Delete successful", message: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.moduleOutput.closeCertainStuffListsModule()
        }
    }
}
extension CertainStuffListPresenter: CertainStuffListModuleInput {
    
}



