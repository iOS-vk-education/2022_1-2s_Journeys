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
    private var isDataLoaded: Bool = false

    init(model: StuffListsModelInput, moduleType: ModuleType) {
        self.model = model
        self.moduleType = moduleType
    }
}

extension StuffListsPresenter: StuffListsModuleInput {
}

extension StuffListsPresenter: StuffListsViewOutput {
    func viewWillAppear() {
        view?.reloadData()
        model.obtainStuffLists()
    }
    
    func didTapBackBarButton() {
        switch moduleType {
        case .stuffListsAdding: moduleOutput?.closePresentedStuffListsModule()
        case .usual: moduleOutput?.closePushedStuffListsModule()
        default: break
        }
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard stuffLists.count > indexPath.row else { return }
        switch moduleType {
        case .usual: moduleOutput?.openCertainStuffListModule(for: stuffLists[indexPath.row])
        case .stuffListsAdding: print("\(indexPath) was tapped")
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
        case .stuffListsAdding(let baggage):
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
