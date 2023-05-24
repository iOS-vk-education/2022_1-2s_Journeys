//
//  StuffListsPresenter.swift
//  Journeys
//
//  Created by Nastya Ischenko on 07/05/2023.
//

import Foundation
import UIKit

// MARK: - StuffListsPresenter

final class StuffListsPresenter {
    // MARK: - Public Properties
    
    enum ModuleType {
        case usual
        case stuffListsAdding(Baggage)
    }

    weak var view: StuffListsViewInput?
    weak var moduleOutput: StuffListsModuleOutput?
    private let model: StuffListsModelInput
    
    private let moduleType: ModuleType
    
    private var stuffLists: [StuffList] = []
    private var baggage: Baggage?
    private var isDataLoaded: Bool = false

    init(model: StuffListsModelInput, moduleType: ModuleType) {
        self.model = model
        self.moduleType = moduleType
        switch moduleType {
        case .stuffListsAdding(let baggage): self.baggage = baggage
        default: break
        }
    }
}

extension StuffListsPresenter: StuffListsModuleInput {
}

extension StuffListsPresenter: StuffListsViewOutput {
    func viewWillAppear() {
        switch moduleType {
        case .usual: view?.showNewStuffListButton()
        default: break
        }
        view?.reloadData()
        model.obtainStuffLists()
    }
    
    func didTapBackBarButton() {
        moduleOutput?.closeStuffListsModule()
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard stuffLists.count > indexPath.row else { return }
        switch moduleType {
        case .usual:
            moduleOutput?.openCertainStuffListModule(for: stuffLists[indexPath.row])
        case .stuffListsAdding:
            guard let baggage else { return }
            if let stuffListId = stuffLists[indexPath.row].id,
                baggage.addedStuffListsIDs.contains(stuffListId) {
                deleteStuffListFromBagagge(baggage: baggage, stuffList: stuffLists[indexPath.row]) { [weak self] in
                    self?.view?.setCheckmarkVisibility(to: false, at: indexPath)
                }
            } else {
                addStuffListToBagagge(baggage: baggage, stuffList: stuffLists[indexPath.row]) { [weak self] in
                    self?.view?.setCheckmarkVisibility(to: true, at: indexPath)
                }
            }
        }
    }
    
    func addStuffListToBagagge(baggage: Baggage, stuffList: StuffList, completion: @escaping () -> Void) {
        model.addStuffListToBaggage(baggage: baggage,
                                    stuffList: stuffList) { [weak self] baggage in
            self?.baggage = baggage
            completion()
        }
    }
    
    func deleteStuffListFromBagagge(baggage: Baggage, stuffList: StuffList, completion: @escaping () -> Void) {
        model.deleteStuffListFromBaggage(baggage: baggage, stuffList: stuffList) { [weak self] baggage in
            self?.baggage = baggage
            completion()
        }
    }
    
    func cellsCount(for section: Int) -> Int {
        if isDataLoaded {
            return stuffLists.count
        }
        return stuffLists.count == 0 ? 5 : stuffLists.count
    }
    
    func cellData(for indexPath: IndexPath) -> StuffListCell.Displaydata? {
        guard stuffLists.count > indexPath.row else { return nil }
        var showCheckmark: Bool = false
        switch moduleType {
        case .stuffListsAdding:
            guard let baggage else { return nil }
            if let curStuffListId = stuffLists[indexPath.row].id,
               baggage.addedStuffListsIDs.contains(curStuffListId) {
                showCheckmark = true
            }
        default: break
        }
        return StuffListCell.Displaydata(stuffListData: StuffListCell.StuffListData(title: stuffLists[indexPath.row].name,
                                         roundColor: stuffLists[indexPath.row].color.toUIColor()),
                                         cellType: .usual,
                                         showCheckmark: showCheckmark)
    }
    
    func didTapNewStuffListButton() {
        moduleOutput?.openCertainStuffListModule(for: nil)
    }
}

extension StuffListsPresenter: StuffListsModelOutput {
    func didReceiveStuffLists(_ stuffLists: [StuffList]) {
        self.stuffLists = stuffLists
        isDataLoaded = true
        view?.reloadData()
        if stuffLists.isEmpty {
            view?.embedPlaceholder()
        } else {
            view?.hidePlaceholder()
        }
    }
    
    func didReceiveError(_ error: Error) {
        if stuffLists.isEmpty {
            view?.embedPlaceholder()
        } else {
            view?.hidePlaceholder()
        }
    }
}
